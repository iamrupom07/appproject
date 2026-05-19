import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── User Model ───────────────────────────────────────────────────────────────

class UserState {
  const UserState({
    required this.isGuest,
    required this.name,
    required this.email,
    required this.password,
  });

  final bool isGuest;
  final String name;
  final String email;
  final String password;

  UserState copyWith({
    bool? isGuest,
    String? name,
    String? email,
    String? password,
  }) {
    return UserState(
      isGuest: isGuest ?? this.isGuest,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

// ─── Keys ─────────────────────────────────────────────────────────────────────

const _kIsGuest = 'user_is_guest';
const _kName = 'user_name';
const _kEmail = 'user_email';
const _kPassword = 'user_password';

// ─── Notifier ─────────────────────────────────────────────────────────────────

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier()
      : super(const UserState(
    isGuest: true,
    name: 'Guest',
    email: '',
    password: '',
  )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserState(
      isGuest: prefs.getBool(_kIsGuest) ?? true,
      name: prefs.getString(_kName) ?? 'Guest',
      email: prefs.getString(_kEmail) ?? '',
      password: prefs.getString(_kPassword) ?? '',
    );
  }

  Future<void> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsGuest, true);
    await prefs.setString(_kName, 'Guest');
    await prefs.setString(_kEmail, '');
    state = state.copyWith(isGuest: true, name: 'Guest', email: '');
  }

  Future<void> login({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final name = email.split('@').first;
    await prefs.setBool(_kIsGuest, false);
    await prefs.setString(_kName, name);
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kPassword, password);
    state = state.copyWith(
      isGuest: false,
      name: name,
      email: email,
      password: password,
    );
  }

  Future<void> updateName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, newName);
    state = state.copyWith(name: newName);
  }

  Future<void> updatePassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPassword, newPassword);
    state = state.copyWith(password: newPassword);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kIsGuest);
    await prefs.remove(_kName);
    await prefs.remove(_kEmail);
    await prefs.remove(_kPassword);
    state = const UserState(
      isGuest: true,
      name: 'Guest',
      email: '',
      password: '',
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
      (ref) => UserNotifier(),
);