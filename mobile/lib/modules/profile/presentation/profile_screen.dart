import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_buttons.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_input_label.dart';
import 'package:ayni_ruta/core/widgets/molecules/choice_controls.dart';
import 'package:ayni_ruta/core/widgets/organisms/app_screen.dart';
import 'package:ayni_ruta/modules/profile/domain/travel_preferences.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.ayniPoints,
    required this.accessibility,
    required this.priority,
    required this.onBack,
    required this.onSave,
  });

  final String name;
  final String email;
  final int ayniPoints;
  final AccessibilityProfile accessibility;
  final TravelPriority priority;
  final VoidCallback onBack;
  final Future<void> Function({
    required String name,
    required AccessibilityProfile accessibility,
    required TravelPriority priority,
  })
  onSave;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.name);
  late AccessibilityProfile _accessibility = widget.accessibility;
  late TravelPriority _priority = widget.priority;
  var _saving = false;
  String? _errorMessage;

  String get _initial => _nameController.text.isEmpty
      ? 'A'
      : _nameController.text.characters.first.toUpperCase();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await widget.onSave(
        name: _nameController.text.trim(),
        accessibility: _accessibility,
        priority: _priority,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = error.toString();
      });
    }
  }

  String? _validateName(String? value) =>
      value == null || value.trim().length < 2
      ? 'Escribe un nombre válido.'
      : null;

  @override
  Widget build(BuildContext context) => ScrollableScreen(
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBackButton(onPressed: widget.onBack),
          const SizedBox(height: 24),
          Text('Mi perfil', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Personaliza cómo quieres viajar.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          _buildAyniCard(context),
          const SizedBox(height: 28),
          const AppInputLabel('Nombre'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.words,
            validator: _validateName,
          ),
          const SizedBox(height: 20),
          const AppInputLabel('Correo electrónico'),
          const SizedBox(height: 8),
          _ReadOnlyField(value: widget.email),
          const SizedBox(height: 30),
          Text('Accesibilidad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ChoiceChips<AccessibilityProfile>(
            value: _accessibility,
            values: AccessibilityProfile.values,
            label: (profile) => profile.label,
            onChanged: (profile) => setState(() => _accessibility = profile),
          ),
          const SizedBox(height: 26),
          Text(
            'Prioridad de viaje',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ChoiceChips<TravelPriority>(
            value: _priority,
            values: TravelPriority.values,
            label: (priority) => priority.label,
            onChanged: (priority) => setState(() => _priority = priority),
          ),
          const SizedBox(height: 32),
          AppPrimaryButton(
            label: _saving ? 'Guardando...' : 'Guardar cambios',
            onPressed: _saving ? null : _save,
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
    ),
  );

  Widget _buildAyniCard(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.hairline),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.strong,
          child: Text(
            _initial,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Puntos Ayni',
                style: TextStyle(color: AppColors.muted, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.ayniPoints} puntos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const Icon(Icons.stars_outlined, color: AppColors.primary),
      ],
    ),
  );
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    decoration: BoxDecoration(
      color: AppColors.soft,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      value,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
    ),
  );
}
