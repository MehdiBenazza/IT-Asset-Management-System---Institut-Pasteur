import 'env_config.dart';

class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = EnvConfig.supabaseUrl;
  static const String supabaseAnonKey = EnvConfig.supabaseAnonKey;
  
  // App Configuration
  static const String appName = 'IT Asset Management System';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const int apiTimeout = 30000; // 30 seconds
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  // Database Table Names
  static const String usersTable = 'users';
  static const String materielsTable = 'materiels';
  static const String departementsTable = 'departements';
  static const String localisationsTable = 'localisations';
  static const String interventionsTable = 'interventions';
  static const String appartenancesTable = 'appartenances';
  static const String bureauxTable = 'bureaux';
} 