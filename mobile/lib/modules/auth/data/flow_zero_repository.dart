import 'package:ayni_ruta/core/api/api_client.dart';
import 'package:ayni_ruta/core/config/app_config.dart';
import 'package:ayni_ruta/core/supabase/auth_service.dart';
import 'package:ayni_ruta/modules/auth/domain/flow_zero_session.dart';
import 'package:ayni_ruta/modules/profile/data/profile_api.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:ayni_ruta/modules/profile/domain/user_profile.dart';

FlowZeroRepository createFlowZeroRepository() => AppConfig.isMock
    ? MockFlowZeroRepository()
    : ProductionFlowZeroRepository();

class MockFlowZeroRepository implements FlowZeroRepository {
  FlowZeroSession? _session;

  @override
  Future<FlowZeroSession?> restore() async => null;

  @override
  Future<FlowZeroSession> authenticate(FlowZeroCredentials credentials) async {
    final name = credentials.isNewUser
        ? credentials.name
        : credentials.email.split('@').first;
    _session = FlowZeroSession(
      email: credentials.email,
      profile: UserProfile(
        id: 'mock-user-001',
        displayName: name,
        accessibility: AccessibilityProfile.none,
        priority: TravelPriority.time,
        ayniPoints: 24,
      ),
    );
    return _session!;
  }

  @override
  Future<FlowZeroSession> updateProfile({
    required String displayName,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  }) async {
    final current = _session;
    if (current == null) {
      throw const FlowZeroException('Inicia sesión para guardar tu perfil.');
    }
    _session = FlowZeroSession(
      email: current.email,
      profile: UserProfile(
        id: current.profile.id,
        displayName: displayName,
        accessibility: accessibility,
        priority: priority,
        ayniPoints: current.profile.ayniPoints,
      ),
    );
    return _session!;
  }
}

class ProductionFlowZeroRepository implements FlowZeroRepository {
  ProductionFlowZeroRepository({
    AuthService? authService,
    ProfileApi? profileApi,
  }) : _authService = authService ?? AuthService(),
       _profileApi = profileApi ?? ProfileApi();

  final AuthService _authService;
  final ProfileApi _profileApi;

  @override
  Future<FlowZeroSession?> restore() async {
    final session = _authService.currentSession;
    if (session == null) return null;
    return _sessionFromProfile(await _profileApi.getMe());
  }

  @override
  Future<FlowZeroSession> authenticate(FlowZeroCredentials credentials) async {
    if (credentials.isNewUser) {
      final session = await _authService.signUp(
        email: credentials.email,
        password: credentials.password,
      );
      if (session == null) {
        throw const FlowZeroException(
          'Revisa tu correo y confirma tu cuenta antes de iniciar sesión.',
        );
      }
    } else {
      await _authService.signIn(
        email: credentials.email,
        password: credentials.password,
      );
    }

    await _profileApi.bootstrap(
      displayName: credentials.isNewUser ? credentials.name : null,
    );
    return _sessionFromProfile(await _profileApi.getMe());
  }

  @override
  Future<FlowZeroSession> updateProfile({
    required String displayName,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  }) async {
    final profile = await _profileApi.update(
      displayName: displayName,
      accessibility: accessibility,
      priority: priority,
    );
    return _sessionFromProfile(profile);
  }

  FlowZeroSession _sessionFromProfile(UserProfile profile) {
    final email = _authService.currentSession?.user.email;
    if (email == null) {
      throw const ApiException('Tu sesión expiró. Vuelve a iniciar sesión.');
    }
    return FlowZeroSession(email: email, profile: profile);
  }
}
