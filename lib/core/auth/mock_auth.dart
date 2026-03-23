import 'dart:math';

class MockUser {
  final String username;
  final String role;
  final String displayName;
  final String accessCode;
  const MockUser({required this.username, required this.role, required this.displayName, this.accessCode = ''});
}

class MockAuth {
  static const String _adminUser = 'admin';
  static const String _adminPass = 'secure@2024';
  static final List<String> _codes = [];
  static MockUser? _current;

  static String generateCode() {
    final code = 'SP-${(Random().nextInt(9000) + 1000)}';
    _codes.add(code);
    return code;
  }

  static List<String> get generatedCodes => List.unmodifiable(_codes);
  static void removeCode(String code) => _codes.remove(code);

  static bool loginWithCode(String code) {
    final t = code.trim().toUpperCase();
    if (_codes.contains(t)) {
      _current = MockUser(username: t, role: 'customer', displayName: 'Customer ($t)', accessCode: t);
      return true;
    }
    return false;
  }

  static MockUser? loginAdmin(String u, String p) {
    if (u.trim() == _adminUser && p == _adminPass) {
      _current = const MockUser(username: 'admin', role: 'admin', displayName: 'Ko Phyo Si Thu');
      return _current;
    }
    return null;
  }

  static MockUser? get currentUser => _current;
  static bool get isLoggedIn => _current != null;
  static void logout() => _current = null;
}
