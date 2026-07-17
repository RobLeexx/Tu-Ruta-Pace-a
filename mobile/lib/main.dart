import 'package:ayni_ruta/app/ayni_ruta_app.dart';
import 'package:ayni_ruta/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

export 'app/ayni_ruta_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initializationError;

  if (AppConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabaseAnonKey,
      );
    } on AuthException catch (error) {
      initializationError = error.message;
    } catch (_) {
      initializationError = 'No se pudo inicializar Supabase.';
    }
  }

  runApp(AyniRutaApp(initializationError: initializationError));
}
