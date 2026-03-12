# GradeCalc Pro — Dart Backend + HTML Frontend

## Project Structure

```
Grading Calculator/
├── server.dart          ← DART BACKEND  (run this first)
├── frontend.html        ← HTML FRONTEND (open in browser)
├── grade_calculator.dart← Original Dart program (terminal)
├── GradeCalculator.kt   ← Partner's Kotlin program
├── pubspec.yaml         ← Dart dependencies
├── students_scores.xlsx ← Input data file
└── .vscode/
    └── launch.json      ← VS Code run config
```

---

## How to Run in VS Code

### Step 1 — Install dependencies (one time only)
Open terminal in VS Code (`Ctrl + backtick`) and run:
```
dart pub get
```

### Step 2 — Start the Dart Backend Server
In the VS Code terminal run:
```
dart run server.dart
```
You should see:
```
╔══════════════════════════════════════════╗
║   GradeCalc Pro — Dart Backend Server   ║
╠══════════════════════════════════════════╣
║  Server running at http://localhost:8080 ║
╚══════════════════════════════════════════╝
```

### Step 3 — Open the Frontend
Open `frontend.html` in your browser:
- Right-click `frontend.html` → Open with → Chrome/Edge
- OR open Chrome and drag the file into it

### Step 4 — Use the App
1. The green dot in the header confirms Dart server is connected
2. Drop your `students_scores.xlsx` onto the drop zone
3. The file goes to Dart → Dart calculates grades → results appear in the GUI

---

## How It Works (Backend ↔ Frontend)

```
[You drop a file]
      ↓
[HTML Frontend]  ──POST /upload──►  [Dart Server]
                                          ↓
                                    Reads Excel file
                                    Calculates grades
                                    Applies OOP logic
                                          ↓
[HTML Frontend]  ◄──JSON response──  [Dart Server]
      ↓
[Table displays results]
```

## API Endpoints (Dart Server)

| Method | URL | Description |
|--------|-----|-------------|
| GET | / | Serves frontend.html |
| POST | /upload | Receives file, returns graded students |
| GET | /stats | Returns statistics for loaded data |
| GET | /export/csv | Downloads CSV of results |

---

## pubspec.yaml Dependencies
```yaml
dependencies:
  excel: ^2.1.0
  shelf: ^1.4.1
  shelf_router: ^1.1.4
  shelf_cors_headers: ^0.1.5
```
