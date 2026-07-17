import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_buttons.dart';
import 'package:ayni_ruta/core/widgets/molecules/choice_controls.dart';
import 'package:ayni_ruta/core/widgets/organisms/app_screen.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({
    super.key,
    required this.accessibility,
    required this.priority,
    required this.onBack,
    required this.onComplete,
  });

  final AccessibilityProfile accessibility;
  final TravelPriority priority;
  final VoidCallback onBack;
  final Future<void> Function(AccessibilityProfile, TravelPriority) onComplete;

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  var _step = 0;
  late AccessibilityProfile _accessibility = widget.accessibility;
  late TravelPriority _priority = widget.priority;
  var _saving = false;
  String? _errorMessage;

  bool get _choosingAccessibility => _step == 0;

  Future<void> _continue() async {
    if (_choosingAccessibility) {
      setState(() => _step = 1);
      return;
    }

    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await widget.onComplete(_accessibility, _priority);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _goBack() {
    if (_choosingAccessibility) {
      widget.onBack();
      return;
    }
    setState(() => _step = 0);
  }

  @override
  Widget build(BuildContext context) => ScrollableScreen(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBackButton(onPressed: _goBack),
        const SizedBox(height: 26),
        Text(
          'Paso ${_step + 1} de 2',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: (_step + 1) / 2,
          minHeight: 4,
          color: AppColors.primary,
          backgroundColor: AppColors.strong,
          borderRadius: BorderRadius.circular(99),
        ),
        const SizedBox(height: 34),
        Text(
          _choosingAccessibility
              ? '¿Cómo te acompañamos?'
              : '¿Qué es más importante para ti?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          _choosingAccessibility
              ? 'Podrás cambiar esta preferencia cuando quieras.'
              : 'Usaremos esta preferencia para ordenar tus rutas.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 28),
        _buildChoices(),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: _saving
              ? 'Guardando...'
              : _choosingAccessibility
              ? 'Continuar'
              : 'Guardar preferencias',
          onPressed: _saving ? null : _continue,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    ),
  );

  Widget _buildChoices() => _choosingAccessibility
      ? Column(
          children: AccessibilityProfile.values
              .map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SelectionCard(
                    selected: _accessibility == profile,
                    icon: _accessibilityIcon(profile),
                    title: _accessibilityTitle(profile),
                    subtitle: _accessibilitySubtitle(profile),
                    onTap: () => setState(() => _accessibility = profile),
                  ),
                ),
              )
              .toList(),
        )
      : Column(
          children: TravelPriority.values
              .map(
                (priority) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SelectionCard(
                    selected: _priority == priority,
                    icon: _priorityIcon(priority),
                    title: _priorityTitle(priority),
                    subtitle: _prioritySubtitle(priority),
                    onTap: () => setState(() => _priority = priority),
                  ),
                ),
              )
              .toList(),
        );

  IconData _accessibilityIcon(AccessibilityProfile profile) =>
      switch (profile) {
        AccessibilityProfile.none => Icons.person_outline_rounded,
        AccessibilityProfile.visual => Icons.visibility_outlined,
        AccessibilityProfile.reducedMobility =>
          Icons.accessible_forward_rounded,
      };

  String _accessibilityTitle(AccessibilityProfile profile) => switch (profile) {
    AccessibilityProfile.none => 'Sin necesidades específicas',
    AccessibilityProfile.visual => 'Discapacidad visual',
    AccessibilityProfile.reducedMobility => 'Movilidad reducida',
  };

  String _accessibilitySubtitle(AccessibilityProfile profile) =>
      switch (profile) {
        AccessibilityProfile.none => 'Una experiencia estándar.',
        AccessibilityProfile.visual =>
          'Indicaciones y controles pensados para voz.',
        AccessibilityProfile.reducedMobility =>
          'Rutas que priorizan accesibilidad.',
      };

  IconData _priorityIcon(TravelPriority priority) => switch (priority) {
    TravelPriority.time => Icons.bolt_outlined,
    TravelPriority.cost => Icons.account_balance_wallet_outlined,
    TravelPriority.safety => Icons.shield_outlined,
  };

  String _priorityTitle(TravelPriority priority) => switch (priority) {
    TravelPriority.time => 'Llegar más rápido',
    TravelPriority.cost => 'Gastar menos',
    TravelPriority.safety => 'Viajar más seguro',
  };

  String _prioritySubtitle(TravelPriority priority) => switch (priority) {
    TravelPriority.time => 'Primero las opciones con menor tiempo.',
    TravelPriority.cost => 'Primero las rutas más económicas.',
    TravelPriority.safety => 'Primero las rutas con mejores condiciones.',
  };
}
