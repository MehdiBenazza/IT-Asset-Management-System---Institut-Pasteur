import 'package:flutter/material.dart';
import '../../../main.dart'; // Import depuis main.dart où DashboardScreen est défini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";

  void _login() {
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (password != "00000") {
      setState(() => error = "Incorrect password");
      return;
    }

    // Decide role by email (demo)
    String title;
    if (email == 'feddi@gmail.com') {
      title = 'Fedi Dashboard';
    } else if (email == 'departement@gmail.com') {
      title = 'Departement Dashboard';
    } else {
      title = 'User Dashboard';
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen(title: title, loggedInEmail: email)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 380,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Login", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 10),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _login, child: const SizedBox(width: double.infinity, child: Center(child: Text("Login")))),
              if (error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error, style: const TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }
}

