// Configuration des variables d'environnement
// Remplacez ces valeurs par vos vraies informations de connexion Supabase

class EnvConfig {
  // Supabase Configuration
  // Remplacez ces valeurs par vos vraies informations de connexion
  static const String supabaseUrl = 'https://mwfwbxqknguqkuqljmwb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13ZndieHFrbmd1cWt1cWxqbXdiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzUzNDk2NywiZXhwIjoyMDY5MTEwOTY3fQ.O2LlvYZJry_A69TEhvYujBDkACL0bmuhlbrAsqmKZR8';
  
  // Exemple de configuration complète :
  // static const String supabaseUrl = 'https://abcdefghijklmnop.supabase.co';
  // static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNjU0NzIwMCwiZXhwIjoxOTUyMTIzMjAwfQ.example';
  
  // Autres configurations d'environnement
  static const bool isDevelopment = true;
  static const String apiBaseUrl = 'https://api.example.com';
} 