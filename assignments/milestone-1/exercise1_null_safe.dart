// ============================================================
//  Assignment — Exercise 1: Null-Safe Data Processing
//
//  Task:
//  - Print email addresses for users who have them (uppercase)
//  - For users without email, print "[Name] has no email"
//  - Count how many users have valid emails and print total
// ============================================================

// Data class — User with nullable email (String?)
class User {
  final String name;
  final String? email; // nullable — email might be missing

  const User(this.name, this.email);
}

void main() {
  // Given list of users with some null emails
  final List<User> users = [
    User("Alex",  "alex@example.com"),
    User("Blake", null),
    User("Casey", "casey@work.com"),
  ];

  print("=" * 50);
  print("  Exercise 1: Null-Safe Data Processing");
  print("=" * 50);

  // ── Requirement 1 & 2 ──
  // Print emails in uppercase OR "[Name] has no email"
  print("\n📧 User Email Report:");
  print("-" * 50);

  for (final user in users) {
    if (user.email != null) {
      // User HAS an email — print it in uppercase
      print("  ✅ ${user.name}: ${user.email!.toUpperCase()}");
    } else {
      // User has NO email — print the message
      print("  ❌ ${user.name} has no email");
    }
  }

  // ── Requirement 3 ──
  // Count how many users have valid emails
  final int validEmailCount = users
      .where((user) => user.email != null)
      .length;

  print("\n📊 Summary:");
  print("-" * 50);
  print("  Total users       : ${users.length}");
  print("  Users with email  : $validEmailCount");
  print("  Users without     : ${users.length - validEmailCount}");
  print("\n" + "=" * 50);
}
