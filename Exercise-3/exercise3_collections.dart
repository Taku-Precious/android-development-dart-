// ============================================================
//  Assignment — Exercise 3: Filtering and Transforming Collections
//
//  Task:
//  Given: val numbers: List<Int?> = listOf(1, null, 3, null, 5, 6, null, 8)
//
//  Operations:
//  1. Filter out nulls — keep only non-null values
//  2. Double each remaining number
//  3. Sum the doubled values
//  4. Print the sum using filterNotNull(), map(), and sum()
//
//  One-liner challenge:
//  Do it in a single chain
// ============================================================

void main() {
  print("=" * 50);
  print("  Exercise 3: Filtering and Transforming");
  print("=" * 50);

  // Given list of nullable integers
  final List<int?> numbers = [1, null, 3, null, 5, 6, null, 8];

  print("\n📋 Original list: $numbers");
  print("-" * 50);

  // ── Step 1: Filter out nulls — keep only non-null values ──
  // whereType<int>() is Dart's equivalent of filterNotNull()
  final List<int> nonNullNumbers = numbers.whereType<int>().toList();
  print("\n✅ Step 1 — After filtering nulls:");
  print("   $nonNullNumbers");

  // ── Step 2: Double each remaining number ──
  final List<int> doubled = nonNullNumbers.map((n) => n * 2).toList();
  print("\n✖️  Step 2 — After doubling each number:");
  print("   $doubled");

  // ── Step 3: Sum the doubled values ──
  final int total = doubled.reduce((a, b) => a + b);
  print("\n➕ Step 3 — Sum of doubled values:");
  print("   $total");

  // ── Step 4: Print using filterNotNull + map + sum chain ──
  print("\n🔗 Step 4 — Using whereType + map + reduce chain:");
  final int chainResult = numbers
      .whereType<int>()        // filterNotNull() equivalent
      .map((n) => n * 2)       // double each number
      .reduce((a, b) => a + b); // sum them all
  print("   Sum = $chainResult");

  // ── ONE-LINER CHALLENGE ──
  print("\n⚡ One-liner challenge:");
  print("-" * 50);
  final int oneLiner = numbers.whereType<int>().map((n) => n * 2).reduce((a, b) => a + b);
  print("   numbers.whereType<int>().map((n) => n * 2).reduce((a, b) => a + b)");
  print("   Result = $oneLiner");

  // ── Summary ──
  print("\n📊 Summary:");
  print("-" * 50);
  print("  Original list   : $numbers");
  print("  After filtering : $nonNullNumbers");
  print("  After doubling  : $doubled");
  print("  Final sum       : $total");
  print("\n" + "=" * 50);
}
