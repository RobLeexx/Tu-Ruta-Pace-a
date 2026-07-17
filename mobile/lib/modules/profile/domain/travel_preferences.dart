enum AccessibilityProfile { none, visual, reducedMobility }

enum TravelPriority { time, cost, safety }

extension AccessibilityProfileLabel on AccessibilityProfile {
  String get apiValue => switch (this) {
    AccessibilityProfile.none => 'none',
    AccessibilityProfile.visual => 'visual',
    AccessibilityProfile.reducedMobility => 'reduced_mobility',
  };

  static AccessibilityProfile fromApi(String value) => switch (value) {
    'visual' => AccessibilityProfile.visual,
    'reduced_mobility' => AccessibilityProfile.reducedMobility,
    _ => AccessibilityProfile.none,
  };

  String get label => switch (this) {
    AccessibilityProfile.none => 'Sin necesidades',
    AccessibilityProfile.visual => 'Discapacidad visual',
    AccessibilityProfile.reducedMobility => 'Movilidad reducida',
  };
}

extension TravelPriorityLabel on TravelPriority {
  String get apiValue => switch (this) {
    TravelPriority.time => 'time',
    TravelPriority.cost => 'cost',
    TravelPriority.safety => 'safety',
  };

  static TravelPriority fromApi(String value) => switch (value) {
    'cost' => TravelPriority.cost,
    'safety' => TravelPriority.safety,
    _ => TravelPriority.time,
  };

  String get label => switch (this) {
    TravelPriority.time => 'tiempo',
    TravelPriority.cost => 'costo',
    TravelPriority.safety => 'seguridad',
  };
}
