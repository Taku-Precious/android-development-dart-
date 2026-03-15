// ============================================================
//  Assignment — Exercise 2: Temperature Descriptions
//
//  Task:
//  - Write a function describeTemperature(temp: Int?) : String
//  - Returns description based on temperature range
//  - "Freezing" if temp <= 0
//  - "Cold"    if 1–15
//  - "Mild"    if 16–25
//  - "Warm"    if 26–35
//  - "Hot"     if 36–45
//  - "Extreme" if > 45
//  - "No data" if temp is null
//
//  Bonus:
//  - List of temperatures (some null)
//  - Print descriptions using a loop with when expression
// ============================================================

// ── Main function: describeTemperature ──
// Takes a nullable int and returns a String description
String describeTemperature(int? temp) {
  // Handle null first — "No data" if temp is null
  if (temp == null) return "No data";

  // Use if-else chain to match the ranges
  if (temp <= 0)  return "Freezing";
  if (temp <= 15) return "Cold";
  if (temp <= 25) return "Mild";
  if (temp <= 35) return "Warm";
  if (temp <= 45) return "Hot";
  return "Extreme";
}

void main() {
  print("=" * 50);
  print("  Exercise 2: Temperature Descriptions");
  print("=" * 50);

  // ── Basic function test ──
  print("\n🌡️  Function Test — describeTemperature():");
  print("-" * 50);
  print("  temp = -5   → ${describeTemperature(-5)}");
  print("  temp = 0    → ${describeTemperature(0)}");
  print("  temp = 10   → ${describeTemperature(10)}");
  print("  temp = 20   → ${describeTemperature(20)}");
  print("  temp = 30   → ${describeTemperature(30)}");
  print("  temp = 40   → ${describeTemperature(40)}");
  print("  temp = 50   → ${describeTemperature(50)}");
  print("  temp = null → ${describeTemperature(null)}");

  // ── BONUS: List of temperatures (some null) ──
  // Using a loop with descriptions
  print("\n🌍 Bonus — Temperature List (with nulls):");
  print("-" * 50);

  final List<int?> temperatures = [
    -3, 10, null, 22, 35, null, 47, 0, 15, null, 38
  ];

  for (int i = 0; i < temperatures.length; i++) {
    final temp = temperatures[i];
    final desc = describeTemperature(temp);
    final display = temp != null ? "${temp}°C" : "null";
    print("  Temp ${(i + 1).toString().padLeft(2)}: ${display.padRight(8)} → $desc");
  }

  // ── Count descriptions ──
  print("\n📊 Summary:");
  print("-" * 50);
  final validTemps = temperatures.where((t) => t != null).length;
  print("  Total readings  : ${temperatures.length}");
  print("  Valid readings  : $validTemps");
  print("  Null readings   : ${temperatures.length - validTemps}");
  print("\n" + "=" * 50);
}
