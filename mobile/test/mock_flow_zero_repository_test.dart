import 'package:ayni_ruta/modules/auth/data/flow_zero_repository.dart';
import 'package:ayni_ruta/modules/auth/domain/flow_zero_session.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock Flow 0 creates and updates an in-memory profile', () async {
    final repository = MockFlowZeroRepository();

    expect(await repository.restore(), isNull);

    final session = await repository.authenticate(
      const FlowZeroCredentials(
        name: 'Lucia',
        email: 'lucia@example.com',
        password: 'password123',
        isNewUser: true,
      ),
    );
    expect(session.profile.ayniPoints, 24);

    final updated = await repository.updateProfile(
      displayName: 'Lucia Quispe',
      accessibility: AccessibilityProfile.visual,
      priority: TravelPriority.safety,
    );
    expect(updated.profile.displayName, 'Lucia Quispe');
    expect(updated.profile.accessibility, AccessibilityProfile.visual);
    expect(updated.profile.priority, TravelPriority.safety);
  });
}
