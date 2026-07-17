import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:ayni_ruta/modules/profile/domain/user_profile.dart';

class FlowZeroCredentials {
  const FlowZeroCredentials({
    required this.name,
    required this.email,
    required this.password,
    required this.isNewUser,
  });

  final String name;
  final String email;
  final String password;
  final bool isNewUser;
}

class FlowZeroSession {
  const FlowZeroSession({required this.email, required this.profile});

  final String email;
  final UserProfile profile;
}

class FlowZeroException implements Exception {
  const FlowZeroException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class FlowZeroRepository {
  Future<FlowZeroSession?> restore();

  Future<FlowZeroSession> authenticate(FlowZeroCredentials credentials);

  Future<FlowZeroSession> updateProfile({
    required String displayName,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  });
}
