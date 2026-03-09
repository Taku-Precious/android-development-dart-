// ============================================================
//  Grade Calculator — Dart Backend Server (server.dart)
//  
//  This is the BACKEND. It:
//  - Reads uploaded Excel/CSV files
//  - Calculates grades using OOP logic
//  - Serves data to the HTML frontend via HTTP API
//
//  Run:
//    dart pub get
//    dart run server.dart
//
//  Then open: http://localhost:8080
// ============================================================

import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// ============================================================
// OOP — Student Data Class (same as grade_calculator.dart)
// ============================================================

class Student {
  final String id;
  final String name;
  final double? score;

  const Student({required this.id, required this.name, this.score});

  // TASK 1A: Validation function
  bool isValid() {
    if (id.trim().isEmpty || name.trim().isEmpty) return false;
    if (score == null) return false;
    if (score! < 0 || score! > 100) return false;
    return true;
  }

  // TASK 1B: Formatting function
  String formatSummary() {
    final scoreText = score?.toStringAsFixed(1) ?? 'N/A';
    return '[${id.padRight(5)}] ${name.padRight(20)} | Score: $scoreText | Grade: $grade | $remarks';
  }

  // Computed: Grade
  String get grade {
    final s = score;
    if (s == null) return 'N/A';
    if (s >= 80) return 'A';
    if (s >= 70) return 'B+';
    if (s >= 60) return 'B';
    if (s >= 56) return 'C+';
    if (s >= 50) return 'C';
    if (s >= 46) return 'D+';
    if (s >= 40) return 'D';
    return 'F';
  }

  // Computed: Remarks
  String get remarks {
    switch (grade) {
      case 'A':  return 'Excellent';
      case 'B+': return 'Very Good';
      case 'B':  return 'Good';
      case 'C+': return 'Above Average';
      case 'C':  return 'Average';
      case 'D+': return 'Below Average';
      case 'D':  return 'Poor';
      case 'F':  return 'Fail';
      default:   return 'No Data';
    }
  }

  // Convert to JSON for API response
  Map<String, dynamic> toJson() => {
    'id':      id,
    'name':    name,
    'score':   score,
    'grade':   grade,
    'remarks': remarks,
    'valid':   isValid(),
    'summary': formatSummary(),
  };
}

// ============================================================
// OOP — GradeCalculator Class
// TASK 2 & 3: Higher-order functions + collection operations
// ============================================================

class GradeCalculator {
  final List<Student> students;

  GradeCalculator(this.students);

  // TASK 2: Higher-order — filter
  List<Student> filterStudents(bool Function(Student) predicate) =>
      students.where(predicate).toList();

  // TASK 2: Higher-order — map
  List<T> mapStudents<T>(T Function(Student) transform) =>
      students.map(transform).toList();

  // TASK 3A: Custom higher-order function with lambda
  void processEach(String label, void Function(Student) action) {
    print('\n$label');
    for (final s in students) action(s);
  }

  // TASK 3B: Collection operations
  List<Student> getPassingStudents() => filterStudents((s) => (s.score ?? 0) >= 40);
  List<Student> getFailingStudents() => filterStudents((s) => (s.score ?? 0) < 40);
  List<Student> getTopStudents()     => filterStudents((s) => s.grade == 'A');

  double averageScore() {
    final scores = students.where((s) => s.score != null).map((s) => s.score!).toList();
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  Student? topStudent() => students.isEmpty ? null :
      students.reduce((a, b) => (a.score ?? -1) >= (b.score ?? -1) ? a : b);

  Map<String, int> gradeDistribution() {
    final dist = <String, int>{};
    for (final s in students) {
      dist[s.grade] = (dist[s.grade] ?? 0) + 1;
    }
    return dist;
  }

  // Full statistics summary for API
  Map<String, dynamic> getStats() {
    final passing = getPassingStudents();
    final failing = getFailingStudents();
    final top     = getTopStudents();
    final avg     = averageScore();
    final best    = topStudent();
    final dist    = gradeDistribution();

    return {
      'total':        students.length,
      'passing':      passing.length,
      'failing':      failing.length,
      'topGrade':     top.length,
      'averageScore': double.parse(avg.toStringAsFixed(2)),
      'highestScore': best?.score,
      'topStudent':   best?.name,
      'distribution': dist,
    };
  }
}

// ============================================================
// File Parsers
// ============================================================

List<Student> parseExcel(List<int> bytes) {
  final excel = Excel.decodeBytes(bytes);
  final sheetName = excel.tables.keys.first;
  final sheet = excel.tables[sheetName]!;
  final students = <Student>[];

  for (var rowIdx = 0; rowIdx < sheet.maxRows; rowIdx++) {
    final row = sheet.row(rowIdx);
    if (row.isEmpty) continue;

    final id = row[0]?.value?.toString().trim() ?? '';
    if (id.toLowerCase() == 'student id' || id.toLowerCase() == 'id') continue;
    if (id.isEmpty) continue;

    final name  = row[1]?.value?.toString().trim() ?? '';
    final raw   = row[2]?.value;
    final score = raw != null ? double.tryParse(raw.toString()) : null;

    if (name.isNotEmpty) {
      students.add(Student(id: id, name: name, score: score));
    }
  }
  return students;
}

List<Student> parseCsv(String content) {
  final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();
  if (lines.isEmpty) return [];

  // Detect delimiter
  final sample = lines[0];
  final delim  = sample.contains('\t') ? '\t' : ',';

  final students = <Student>[];
  // Skip header
  for (var i = 1; i < lines.length; i++) {
    final parts = lines[i].split(delim).map((p) => p.trim().replaceAll('"', '')).toList();
    if (parts.length < 2) continue;

    final id    = parts.length > 0 ? parts[0] : '';
    if (id.isEmpty) continue;
    final name  = parts.length > 1 ? parts[1] : '';
    final score = parts.length > 2 ? double.tryParse(parts[2]) : null;

    students.add(Student(id: id, name: name, score: score));
  }
  return students;
}

// ============================================================
// HTTP API Server
// ============================================================

// Store students in memory between requests
List<Student> _currentStudents = [];

Future<void> main() async {
  final router = Router();

  // ── GET / — Serve the HTML frontend ──
  router.get('/', (Request req) async {
    final htmlFile = File('frontend.html');
    if (!await htmlFile.exists()) {
      return Response.notFound('frontend.html not found');
    }
    final html = await htmlFile.readAsString();
    return Response.ok(html, headers: {'Content-Type': 'text/html; charset=utf-8'});
  });

  // ── POST /upload — Receive file, parse it, return students + stats ──
  router.post('/upload', (Request req) async {
    try {
      final contentType = req.headers['content-type'] ?? '';
      final bodyBytes   = await req.read().expand((chunk) => chunk).toList();

      List<Student> students = [];

      if (contentType.contains('application/json')) {
        // CSV sent as JSON body
        final body = jsonDecode(utf8.decode(bodyBytes));
        final csvContent = body['content'] as String;
        students = parseCsv(csvContent);
      } else {
        // Excel binary
        students = parseExcel(bodyBytes);
      }

      _currentStudents = students;
      final calc = GradeCalculator(students);

      // Log using higher-order functions (Task 3A)
      calc.processEach('Processing students:', (s) {
        print('  ${s.formatSummary()}');
      });

      final response = {
        'success':  true,
        'students': students.map((s) => s.toJson()).toList(),
        'stats':    calc.getStats(),
      };

      return Response.ok(
        jsonEncode(response),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'success': false, 'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // ── GET /stats — Return stats for current students ──
  router.get('/stats', (Request req) {
    if (_currentStudents.isEmpty) {
      return Response.ok(
        jsonEncode({'success': false, 'error': 'No data loaded'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    final calc = GradeCalculator(_currentStudents);
    return Response.ok(
      jsonEncode({'success': true, 'stats': calc.getStats()}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // ── GET /export/csv — Download results as CSV ──
  router.get('/export/csv', (Request req) {
    if (_currentStudents.isEmpty) {
      return Response.notFound('No data to export');
    }
    final sb = StringBuffer();
    sb.writeln('Student ID,Student Name,Score,Grade,Remarks,Valid');
    for (final s in _currentStudents) {
      sb.writeln('${s.id},${s.name},${s.score ?? "N/A"},${s.grade},${s.remarks},${s.isValid() ? "YES" : "NO"}');
    }
    return Response.ok(
      sb.toString(),
      headers: {
        'Content-Type': 'text/csv',
        'Content-Disposition': 'attachment; filename="grade_report.csv"',
      },
    );
  });

  // ── Pipeline with CORS ──
  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('');
  print('╔══════════════════════════════════════════╗');
  print('║   GradeCalc Pro — Dart Backend Server   ║');
  print('╠══════════════════════════════════════════╣');
  print('║  Server running at http://localhost:8080 ║');
  print('║  Open this URL in your browser           ║');
  print('║  Press Ctrl+C to stop                    ║');
  print('╚══════════════════════════════════════════╝');
  print('');
}
