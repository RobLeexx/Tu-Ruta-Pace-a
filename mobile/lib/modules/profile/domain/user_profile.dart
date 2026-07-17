import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.accessibility,
    required this.priority,
    required this.ayniPoints,
  });

  final String id;
  final String? displayName;
  final AccessibilityProfile accessibility;
  final TravelPriority priority;
  final int ayniPoints;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    displayName: json['displayName'] as String?,
    accessibility: AccessibilityProfileLabel.fromApi(
      json['accessibilityProfile'] as String,
    ),
    priority: TravelPriorityLabel.fromApi(json['defaultPriority'] as String),
    ayniPoints: json['ayniPoints'] as int,
  );
}
