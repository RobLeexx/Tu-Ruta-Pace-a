import 'package:ayni_ruta/core/api/api_client.dart';
import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_buttons.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_input_label.dart';
import 'package:ayni_ruta/core/widgets/molecules/brand_mark.dart';
import 'package:ayni_ruta/core/widgets/organisms/app_screen.dart';
import 'package:ayni_ruta/modules/auth/domain/flow_zero_session.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.initiallyNewUser,
    required this.onBack,
    required this.onComplete,
  });

  final bool initiallyNewUser;
  final VoidCallback onBack;
  final Future<void> Function({
    required String name,
    required String email,
    required String password,
    required bool isNewUser,
  })
  onComplete;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _isNewUser = widget.initiallyNewUser;
  var _hidePassword = true;
  var _submitting = false;
  String? _errorMessage;

  bool get _isRegistration => _isNewUser;

  String get _title =>
      _isRegistration ? 'Crea tu cuenta' : 'Bienvenida de nuevo';

  String get _subtitle => _isRegistration
      ? 'Guarda tus preferencias y tus puntos Ayni.'
      : 'Ingresa para continuar tu viaje.';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() => setState(() => _isNewUser = !_isNewUser);

  void _togglePasswordVisibility() =>
      setState(() => _hidePassword = !_hidePassword);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      final email = _emailController.text.trim();
      final name = _isRegistration
          ? _nameController.text.trim()
          : email.split('@').first;
      await widget.onComplete(
        name: name,
        email: email,
        password: _passwordController.text,
        isNewUser: _isNewUser,
      );
    } on ApiException catch (error) {
      _showError(error.message);
    } on AuthException catch (error) {
      _showError(error.message);
    } on FlowZeroException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('No pudimos completar tu solicitud. Intenta de nuevo.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _errorMessage = message;
    });
  }

  String? _validateName(String? value) =>
      value == null || value.trim().length < 2
      ? 'Escribe un nombre de al menos 2 letras.'
      : null;

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Escribe un correo válido.';
  }

  String? _validatePassword(String? value) => (value?.length ?? 0) < 8
      ? 'La contraseña debe tener al menos 8 caracteres.'
      : null;

  @override
  Widget build(BuildContext context) => ScrollableScreen(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBackButton(onPressed: widget.onBack),
        const SizedBox(height: 20),
        const BrandMark(),
        const SizedBox(height: 40),
        Text(_title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          _subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 32),
        _buildForm(),
        const SizedBox(height: 32),
        AppPrimaryButton(
          label: _submitting
              ? 'Conectando...'
              : _isRegistration
              ? 'Crear cuenta'
              : 'Iniciar sesión',
          onPressed: _submitting ? null : _submit,
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
        const SizedBox(height: 16),
        _buildModeToggle(context),
        const SizedBox(height: 20),
        Text(
          'Al continuar aceptas los Términos y la Política de privacidad.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );

  Widget _buildForm() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isRegistration) ...[
          const AppInputLabel('¿Cómo te llamamos?'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(hintText: 'Tu nombre'),
            validator: _validateName,
          ),
          const SizedBox(height: 20),
        ],
        const AppInputLabel('Correo electrónico'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(hintText: 'tu@correo.com'),
          validator: _validateEmail,
        ),
        const SizedBox(height: 20),
        const AppInputLabel('Contraseña'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _hidePassword,
          autofillHints: const [AutofillHints.password],
          decoration: InputDecoration(
            hintText: 'Mínimo 8 caracteres',
            suffixIcon: IconButton(
              tooltip: _hidePassword
                  ? 'Mostrar contraseña'
                  : 'Ocultar contraseña',
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: _validatePassword,
        ),
      ],
    ),
  );

  Widget _buildModeToggle(BuildContext context) => Center(
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          _isRegistration
              ? '¿Ya tienes una cuenta?'
              : '¿Aún no tienes una cuenta?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        AppTextButton(
          label: _isRegistration ? 'Inicia sesión' : 'Regístrate',
          onPressed: _submitting ? () {} : _toggleMode,
        ),
      ],
    ),
  );
}
