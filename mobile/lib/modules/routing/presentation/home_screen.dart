import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_buttons.dart';
import 'package:ayni_ruta/core/widgets/molecules/brand_mark.dart';
import 'package:ayni_ruta/core/widgets/organisms/app_screen.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.name,
    required this.priority,
    required this.onProfile,
  });

  final String name;
  final TravelPriority priority;
  final VoidCallback onProfile;

  String get _initial =>
      name.isEmpty ? 'A' : name.characters.first.toUpperCase();

  @override
  Widget build(BuildContext context) => ScrollableScreen(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: BrandMark()),
            Semantics(
              button: true,
              label: 'Abrir perfil',
              child: IconButton(
                tooltip: 'Perfil',
                onPressed: onProfile,
                icon: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.strong,
                  child: Text(
                    _initial,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 46),
        Text('Hola, $name', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          '¿A dónde quieres ir hoy?',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 28),
        const _DestinationSearch(),
        const SizedBox(height: 36),
        _ProfileReadyCard(priority: priority),
        const SizedBox(height: 20),
        AppOutlinedButton(
          label: 'Ver y editar mi perfil',
          icon: Icons.person_outline_rounded,
          onPressed: onProfile,
        ),
      ],
    ),
  );
}

class _DestinationSearch extends StatelessWidget {
  const _DestinationSearch();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.hairline),
      borderRadius: BorderRadius.circular(999),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search_rounded, color: AppColors.ink),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Busca un destino',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        ),
      ],
    ),
  );
}

class _ProfileReadyCard extends StatelessWidget {
  const _ProfileReadyCard({required this.priority});

  final TravelPriority priority;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.soft,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.map_outlined, color: AppColors.primary, size: 32),
        const SizedBox(height: 18),
        Text(
          'Tu perfil está listo',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Priorizaremos ${priority.label} en tus próximas rutas.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );
}
