import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/sevices/supabase_client.dart';
import 'core/services/database_test_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Supabase
  try {
    await SupabaseClientService.initialize();
    print('Supabase initialisé avec succès');
    
    // Tester la connexion à la base de données
    await DatabaseTestService.runAllTests();
  } catch (e) {
    print('Erreur lors de l\'initialisation de Supabase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IT Asset Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const App(),
      debugShowCheckedModeBanner: false,
    );
  }
}
