import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/prefs/app_prefs.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';

class SessionState {
  const SessionState({
    this.user,
    required this.onboardingDone,
    required this.role,
  });

  final User? user;
  final bool onboardingDone;
  final UserRole role;

  bool get signedIn => user != null;

  SessionState copyWith({
    User? user,
    bool clearUser = false,
    bool? onboardingDone,
    UserRole? role,
  }) {
    return SessionState(
      user: clearUser ? null : (user ?? this.user),
      onboardingDone: onboardingDone ?? this.onboardingDone,
      role: role ?? this.role,
    );
  }
}

class SessionController extends AsyncNotifier<SessionState> {
  @override
  Future<SessionState> build() async {
    final prefs = ref.watch(sharedPrefsProvider);
    final auth = ref.watch(authRepositoryProvider);
    await Future<void>.delayed(const Duration(milliseconds: 550));

    final id = prefs.getString(PrefKeys.userId);
    final user = id == null ? null : await auth.findById(id);
    if (id != null && user == null) {
      await prefs.remove(PrefKeys.userId);
    }
    final storedRole = prefs.getString(PrefKeys.lastRole);
    final role =
        user?.role ??
        (storedRole == UserRole.buyer.name ? UserRole.buyer : UserRole.owner);
    return SessionState(
      user: user,
      onboardingDone: prefs.getBool(PrefKeys.onboarded) ?? false,
      role: role,
    );
  }

  SessionState get _current =>
      state.value ??
      const SessionState(onboardingDone: false, role: UserRole.owner);

  Future<void> completeOnboarding() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(PrefKeys.onboarded, true);
    state = AsyncData(_current.copyWith(onboardingDone: true));
  }

  Future<void> selectRole(UserRole role) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(PrefKeys.lastRole, role.name);
    state = AsyncData(_current.copyWith(role: role));
  }

  Future<void> register({
    required String name,
    required String phone,
    String? email,
  }) async {
    final role = _current.role;
    final user = await ref
        .read(authRepositoryProvider)
        .register(name: name, phone: phone, email: email, role: role);
    await _persistUser(user);
  }

  Future<void> signInDemo() async {
    final auth = ref.read(authRepositoryProvider);
    final user = _current.role == UserRole.buyer
        ? await auth.demoBuyer()
        : await auth.demoOwner();
    await _persistUser(user);
  }

  Future<void> signIn(String phone) async {
    final user = await ref.read(authRepositoryProvider).findByPhone(phone);
    if (user == null) {
      throw const FormatException('No account found for that number');
    }
    await _persistUser(user);
  }

  Future<void> switchRole(UserRole role) async {
    final user = _current.user;
    if (user == null) return selectRole(role);
    final updated = await ref
        .read(authRepositoryProvider)
        .updateRole(user.id, role);
    await ref.read(sharedPrefsProvider).setString(PrefKeys.lastRole, role.name);
    state = AsyncData(_current.copyWith(user: updated, role: role));
  }

  Future<void> signOut() async {
    await ref.read(sharedPrefsProvider).remove(PrefKeys.userId);
    state = AsyncData(_current.copyWith(clearUser: true));
  }

  Future<void> _persistUser(User user) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(PrefKeys.userId, user.id);
    await prefs.setString(PrefKeys.lastRole, user.role.name);
    state = AsyncData(
      _current.copyWith(user: user, role: user.role, onboardingDone: true),
    );
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
