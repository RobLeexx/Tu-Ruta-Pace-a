import 'package:ayni_ruta/core/api/api_client.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:ayni_ruta/modules/profile/domain/user_profile.dart';

class ProfileApi {
  ProfileApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<UserProfile> bootstrap({String? displayName}) async {
    final profile = await _client.post(
      '/users/me/bootstrap',
      data: displayName == null ? null : {'displayName': displayName},
    );
    return UserProfile.fromJson(profile);
  }

  Future<UserProfile> getMe() async {
    final profile = await _client.get('/users/me');
    return UserProfile.fromJson(profile);
  }

  Future<UserProfile> update({
    required String displayName,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  }) async {
    final profile = await _client.patch(
      '/users/me',
      data: {
        'displayName': displayName,
        'accessibilityProfile': accessibility.apiValue,
        'defaultPriority': priority.apiValue,
      },
    );
    return UserProfile.fromJson(profile);
  }
}
