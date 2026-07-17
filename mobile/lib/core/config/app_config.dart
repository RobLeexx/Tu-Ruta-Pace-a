class AppConfig {
  const AppConfig._();

  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'mock',
  );
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static bool get isProduction => environment == 'production';

  static bool get isMock => !isProduction;

  static bool get hasProductionCredentials =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      apiBaseUrl.isNotEmpty;
}
