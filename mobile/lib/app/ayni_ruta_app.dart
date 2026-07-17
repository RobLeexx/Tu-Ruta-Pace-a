import 'package:ayni_ruta/core/api/api_client.dart';
import 'package:ayni_ruta/core/config/app_config.dart';
import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/design/app_theme.dart';
import 'package:ayni_ruta/core/supabase/auth_service.dart';
import 'package:ayni_ruta/core/widgets/organisms/app_screen.dart';
import 'package:ayni_ruta/modules/auth/presentation/auth_screen.dart';
import 'package:ayni_ruta/modules/auth/presentation/welcome_screen.dart';
import 'package:ayni_ruta/modules/profile/data/profile_api.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:ayni_ruta/modules/profile/domain/user_profile.dart';
import 'package:ayni_ruta/modules/profile/presentation/preferences_screen.dart';
import 'package:ayni_ruta/modules/profile/presentation/profile_screen.dart';
import 'package:ayni_ruta/modules/routing/presentation/home_screen.dart';
import 'package:flutter/material.dart';

enum FlowStage { loading, welcome, auth, preferences, home, profile }

class AyniRutaApp extends StatefulWidget {
  const AyniRutaApp({super.key, this.initializationError});

  final String? initializationError;

  @override
  State<AyniRutaApp> createState() => _AyniRutaAppState();
}

class _AyniRutaAppState extends State<AyniRutaApp> {
  final _authService = AuthService();
  final _profileApi = ProfileApi();

  FlowStage _stage = FlowStage.loading;
  var _isNewUser = true;
  String _name = '';
  String _email = '';
  int _ayniPoints = 0;
  AccessibilityProfile _accessibility = AccessibilityProfile.none;
  TravelPriority _priority = TravelPriority.time;

  bool get _isReadyForAuth =>
      AppConfig.isConfigured && widget.initializationError == null;

  @override
  void initState() {
    super.initState();
    if (_isReadyForAuth) {
      _restoreSession();
    }
  }

  void _showStage(FlowStage stage) => setState(() => _stage = stage);

  void _showAuth({required bool isNewUser}) => setState(() {
    _isNewUser = isNewUser;
    _stage = FlowStage.auth;
  });

  Future<void> _restoreSession() async {
    final session = _authService.currentSession;
    if (session == null) {
      if (mounted) _showStage(FlowStage.welcome);
      return;
    }

    try {
      await _loadProfile(displayName: null, nextStage: FlowStage.home);
    } catch (_) {
      if (mounted) _showStage(FlowStage.welcome);
    }
  }

  Future<void> _authenticate({
    required String name,
    required String email,
    required String password,
    required bool isNewUser,
  }) async {
    if (isNewUser) {
      final session = await _authService.signUp(
        email: email,
        password: password,
      );
      if (session == null) {
        throw const ApiException(
          'Revisa tu correo y confirma tu cuenta antes de iniciar sesión.',
        );
      }
    } else {
      await _authService.signIn(email: email, password: password);
    }

    await _loadProfile(
      displayName: isNewUser ? name : null,
      nextStage: isNewUser ? FlowStage.preferences : FlowStage.home,
    );
  }

  Future<void> _loadProfile({
    required String? displayName,
    required FlowStage nextStage,
  }) async {
    await _profileApi.bootstrap(displayName: displayName);
    final profile = await _profileApi.getMe();
    final email = _authService.currentSession?.user.email ?? _email;
    if (!mounted) return;
    setState(() {
      _applyProfile(profile, email: email);
      _stage = nextStage;
    });
  }

  Future<void> _savePreferences(
    AccessibilityProfile accessibility,
    TravelPriority priority,
  ) => _updateProfile(
    displayName: _name,
    accessibility: accessibility,
    priority: priority,
  );

  Future<void> _saveProfile({
    required String name,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  }) => _updateProfile(
    displayName: name,
    accessibility: accessibility,
    priority: priority,
  );

  Future<void> _updateProfile({
    required String displayName,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  }) async {
    final profile = await _profileApi.update(
      displayName: displayName,
      accessibility: accessibility,
      priority: priority,
    );
    if (!mounted) return;
    setState(() {
      _applyProfile(
        profile,
        email: _authService.currentSession?.user.email ?? _email,
      );
      _stage = FlowStage.home;
    });
  }

  void _applyProfile(UserProfile profile, {required String email}) {
    _name = profile.displayName ?? email.split('@').first;
    _email = email;
    _ayniPoints = profile.ayniPoints;
    _accessibility = profile.accessibility;
    _priority = profile.priority;
  }

  Widget _buildCurrentScreen() {
    if (!_isReadyForAuth) {
      return ConfigurationRequiredScreen(error: widget.initializationError);
    }

    return switch (_stage) {
      FlowStage.loading => const _LoadingScreen(),
      FlowStage.welcome => WelcomeScreen(
        onCreateAccount: () => _showAuth(isNewUser: true),
        onSignIn: () => _showAuth(isNewUser: false),
      ),
      FlowStage.auth => AuthScreen(
        initiallyNewUser: _isNewUser,
        onBack: () => _showStage(FlowStage.welcome),
        onComplete: _authenticate,
      ),
      FlowStage.preferences => PreferencesScreen(
        accessibility: _accessibility,
        priority: _priority,
        onBack: () => _showStage(FlowStage.auth),
        onComplete: _savePreferences,
      ),
      FlowStage.home => HomeScreen(
        name: _name,
        priority: _priority,
        onProfile: () => _showStage(FlowStage.profile),
      ),
      FlowStage.profile => ProfileScreen(
        name: _name,
        email: _email,
        ayniPoints: _ayniPoints,
        accessibility: _accessibility,
        priority: _priority,
        onBack: () => _showStage(FlowStage.home),
        onSave: _saveProfile,
      ),
    };
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ayni Ruta',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: AppShell(child: _buildCurrentScreen()),
  );
}

class ConfigurationRequiredScreen extends StatelessWidget {
  const ConfigurationRequiredScreen({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.settings_outlined, size: 48, color: AppColors.primary),
        const SizedBox(height: 20),
        Text(
          'Conecta Ayni Ruta',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          error ??
              'Inicia la app con SUPABASE_URL, SUPABASE_ANON_KEY y API_BASE_URL para usar tu cuenta real.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.primary));
}
