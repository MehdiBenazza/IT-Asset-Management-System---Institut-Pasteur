import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
//import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ================= MODERN LOGIN SCREEN =================
// ================= MODERN LOGIN SCREEN =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";
  bool _isLoading = false;
  bool _imageError = false;

  void _login() async {
    setState(() {
      _isLoading = true;
      error = "";
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (password != "00000") {
      setState(() {
        error = "Incorrect password";
        _isLoading = false;
      });
      return;
    }

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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DashboardScreen(title: title, loggedInEmail: email),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pasteur Image with simple error handling
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _imageError
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "IP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://www.santenews-dz.com/wp-content/uploads/2018/12/FB_IMG_1544035059585.jpg',
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            // Set the error flag and rebuild
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!_imageError) {
                                setState(() {
                                  _imageError = true;
                                });
                              }
                            });
                            return Container(
                              color: const Color(0xFFF1F5F9),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to your account",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                "Use password: 00000 for demo",
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ================= MODERN AI ASSISTANT WIDGET =================
class _AiAssistant extends StatefulWidget {
  const _AiAssistant();

  @override
  State<_AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<_AiAssistant> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _send(String text) async {
    setState(() {
      _messages.add({"role": "user", "content": text});
      _loading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    const apiKey = "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";
    
    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": "http://localhost:3000",
          "X-Title": "Flutter Dashboard",
        },
        body: jsonEncode({
          "model": "deepseek/deepseek-chat",
          "messages": _messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];
        setState(() {
          _messages.add({"role": "assistant", "content": reply});
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "Error ${response.statusCode}: ${response.body}"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Text(
                  "AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_messages.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.white70),
                    tooltip: "Clear chat",
                    onPressed: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
          // Messages area
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: Stack(
                children: [
                  // Chat messages
                  if (_messages.isNotEmpty)
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final msg = _messages[i];
                        final isUser = msg["role"] == "user";
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: isUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isUser)
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.white),
                                ),
                              if (!isUser) const SizedBox(width: 12),
                              Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? const Color(0xFFE0E7FF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isUser
                                          ? const Color(0xFFC7D2FE)
                                          : const Color(0xFFE2E8F0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    msg["content"] ?? "",
                                    style: TextStyle(
                                      color: isUser
                                          ? const Color(0xFF3730A3)
                                          : const Color(0xFF374151),
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                              if (isUser) const SizedBox(width: 12),
                              if (isUser)
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF6366F1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  // Empty state - simplified without suggestions
                  if (_messages.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "How can I help you today?",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Loading indicator
                  if (_loading)
                    const Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask something...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF9CA3AF)),
                          onPressed: () {},
                        ),
                      ),
                      minLines: 1,
                      maxLines: 3,
                      onSubmitted: (_) {
                        final txt = _controller.text.trim();
                        if (txt.isNotEmpty) {
                          _controller.clear();
                          _send(txt);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    onPressed: () {
                      final txt = _controller.text.trim();
                      if (txt.isNotEmpty) {
                        _controller.clear();
                        _send(txt);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============== MODELS ==============
class MaterialItem {
  String id;
  String type;
  String userId; // assigned employee user id or empty
  String etat; // working / not working (changed from state to etat)
  String modele; // changed from os to modele
  String iddepartement; // changed from department to iddepartement
  int idbureau; // changed from bureau to idbureau

  MaterialItem({
    required this.id,
    required this.type,
    this.userId = '',
    required this.etat,
    this.modele = '',
    this.iddepartement = '',
    this.idbureau = 0, // 0 means no bureau selected
  });
}

class EmployeeItem {
  String id; // changed from userId to id
  String nom;
  String prenom;
  String dateNaissance;
  String dateRecrutement;
  String email;
  String iddepartement; // changed from department to iddepartement
  int idbureau; // changed from bureau to idbureau
  String role; // added role field

  EmployeeItem({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.dateRecrutement,
    required this.email,
    this.iddepartement = '',
    this.idbureau = 0, // 0 means no bureau selected
    this.role = 'employe', // default to employe
  });
}

class DepartementItem { // changed from DepartmentItem to DepartementItem
  String id;
  String nom;
  String description;
  int bureauCount; // Number of bureaus (1-30)

  DepartementItem({
    required this.id,
    required this.nom,
    this.description = '',
    this.bureauCount = 0, // 0 means no bureaus
  });
}

class NotificationItem {
  String title;
  String details;
  String time;
  // structured fields
  String employeeName;
  String deviceId;
  String deviceType;
  String problem;
  String iddepartement; // changed from department to iddepartement
  String status; // NEW: added status field (pending, accepted, rejected)

  NotificationItem({
    required this.title,
    required this.details,
    required this.time,
    this.employeeName = '',
    this.deviceId = '',
    this.deviceType = '',
    this.problem = '',
    this.iddepartement = '',
    this.status = 'pending', // NEW: default status is pending
  });
}

// ============== MODERN DASHBOARD SCREEN ==============
enum Menu {
  home,
  notifications,
  profile,
  report,
  antiviruses,
  database,
  addEmployee,
  createMaterial,
  manageDepartments,
  logout
}

class DashboardScreen extends StatefulWidget {
  final String title;
  final String loggedInEmail;

  const DashboardScreen({super.key, required this.title, required this.loggedInEmail});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isMenuOpen = true;
  Menu selected = Menu.home;
  int _deptBureauCount = 0;
  bool _isDarkMode = false;


  // Modern color scheme
  static const Color sidebarBg = Color(0xFF1E293B);
  static const Color activeBlue = Color(0xFF6366F1);
  static const Color cardWhite = Colors.white;
  static const Color pageBg = Color(0xFFF8FAFC);
  static const Color profileBoxBg = Color(0xFFF1F5F9);
  static const Color textOutside = Color(0xFF1E293B);
  static const Color textInside = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Demo in-memory DB (updated with new field names)
  final List<MaterialItem> materials = [
    MaterialItem(id: 'LT-2023-0456', type: 'Laptop', userId: 'U001', etat: 'actif', modele: 'Dell XPS 15', iddepartement: 'IT', idbureau: 5),
    MaterialItem(id: 'DT-2022-0789', type: 'Desktop', userId: 'U002', etat: 'en panne', modele: 'HP EliteDesk', iddepartement: 'Finance', idbureau: 12),
  ];

  final List<EmployeeItem> employees = [
    EmployeeItem(id: 'U001', nom: 'Dupont', prenom: 'Jean', dateNaissance: '1993-04-02', dateRecrutement: '2021-06-12', email: 'jean.dupont@example.com', iddepartement: 'IT', idbureau: 5, role: 'employe'),
    EmployeeItem(id: 'U002', nom: 'Martin', prenom: 'Alice', dateNaissance: '1990-09-10', dateRecrutement: '2020-01-05', email: 'alice.martin@example.com', iddepartement: 'Finance', idbureau: 12, role: 'employe'),
  ];

  final List<DepartementItem> departements = [ // changed from departments to departements
    DepartementItem(id: 'D-IT', nom: 'IT', description: 'Information Technology', bureauCount: 6),
    DepartementItem(id: 'D-FIN', nom: 'Finance', description: 'Finance Department', bureauCount: 4),
  ];

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Backup completed successfully',
      details: '',
      time: '2025-08-25',
    ),
    NotificationItem(
      title: 'Maintenance request',
      details: 'Please check boot issue for Laptop',
      time: '2025-08-26',
      employeeName: 'Jean Dupont',
      deviceId: 'LT-2023-0456',
      deviceType: 'Laptop',
      problem: 'No boot',
      iddepartement: 'IT',
      status: 'pending',
    ),
    // Example: Accepted notification (with dates)
    NotificationItem(
      title: 'Maintenance request accepted',
      details: 'Your maintenance request has been accepted.',
      time: '2025-08-27',
      employeeName: 'Jean Dupont',
      deviceId: 'LT-2023-0456',
      deviceType: 'Laptop',
      problem: 'No boot',
      iddepartement: 'IT',
      status: 'accepted',
    ),
    // Example: Rejected notification
    NotificationItem(
      title: 'Maintenance request rejected',
      details: 'Your maintenance request has been rejected.',
      time: '2025-08-28',
      employeeName: 'Jean Dupont',
      deviceId: 'LT-2023-0456',
      deviceType: 'Laptop',
      problem: 'No boot',
      iddepartement: 'IT',
      status: 'rejected',
    ),
  ];

  // Feddi maintenance accepted items
  final List<Map<String, String>> feeddiMaintenance = [];

  // Controllers (updated with new field names)
  final _matIdController = TextEditingController();
  final _matTypeController = TextEditingController();
  final _matUserIdController = TextEditingController();
  final _matEtatController = TextEditingController();
  final _matModeleController = TextEditingController();
  final _matIddepartementController = TextEditingController();
  final _matIdbureauController = TextEditingController();
  final _empIdController = TextEditingController();
  final _empNomController = TextEditingController();
  final _empPrenomController = TextEditingController();
  final _empEmailController = TextEditingController();
  final _empDateNaissanceController = TextEditingController();
  final _empDateRecrutementController = TextEditingController();
  final _empIddepartementController = TextEditingController();
  final _empIdbureauController = TextEditingController();
  final _empRoleController = TextEditingController();
  final _deptIdController = TextEditingController();
  final _deptNomController = TextEditingController();
  final _deptDescController = TextEditingController();
  final _deptBureausController = TextEditingController();

  // Bureau selection state
  final Set<int> _selectedBureaus = {};

  // ========= CHAT ASSISTANT STATE (ONLY USED BY _roleHome) =========
  final List<_ChatMessage> _chat = <_ChatMessage>[];
  final TextEditingController _chatController = TextEditingController();
  bool _chatLoading = false;

  // Filter state
  String _currentFilter = 'all';
  final _filterController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers
    _matIdController.dispose();
    _matTypeController.dispose();
    _matUserIdController.dispose();
    _matEtatController.dispose();
    _matModeleController.dispose();
    _matIddepartementController.dispose();
    _matIdbureauController.dispose();
    _empIdController.dispose();
    _empNomController.dispose();
    _empPrenomController.dispose();
    _empEmailController.dispose();
    _empDateNaissanceController.dispose();
    _empDateRecrutementController.dispose();
    _empIddepartementController.dispose();
    _empIdbureauController.dispose();
    _empRoleController.dispose();
    _deptIdController.dispose();
    _deptNomController.dispose();
    _deptDescController.dispose();
    _deptBureausController.dispose();
    _chatController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  // Role helpers
  bool get isFeddi => widget.loggedInEmail == 'feddi@gmail.com';
  bool get isDepartementUser => widget.loggedInEmail == 'departement@gmail.com';
  bool get isNormalUser => !isFeddi && !isDepartementUser;

  String get currentUserDepartement {
    if (isDepartementUser) return 'IT';
    final mapped = _employeeByEmail(widget.loggedInEmail);
    if (mapped != null) return mapped.iddepartement;
    return '';
  }

  EmployeeItem? _employeeByEmail(String email) {
    try {
      return employees.firstWhere((e) => e.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  // Permission checks
  bool canEditEmployee(EmployeeItem e) {
    if (isFeddi) return true;
    if (isDepartementUser) return e.iddepartement == currentUserDepartement;
    return false;
  }

  bool canRemoveEmployee(EmployeeItem e) => canEditEmployee(e);

  bool canEditMaterial(MaterialItem m) {
    if (isFeddi) return true;
    if (isDepartementUser) return m.iddepartement == currentUserDepartement;
    return false;
  }

  bool canRemoveMaterial(MaterialItem m) => canEditMaterial(m);

  bool canManageDepartements() => isFeddi;
  bool canCreateReport() => !isFeddi;

  // Helper to get available bureaus for a departement
  List<int> _getBureausForDepartement(String departementName) {
    final dept = departements.firstWhere(
      (d) => d.nom == departementName,
      orElse: () => DepartementItem(id: '', nom: '', bureauCount: 0),
    );
    return List.generate(dept.bureauCount, (index) => index + 1);
  }

  // Helper to create bureau dropdown
  Widget _bureauDropdown(String departement, TextEditingController bureauController, {String label = 'Bureau'}) {
    final availableBureaus = _getBureausForDepartement(departement);
    final currentBureau = bureauController.text.isNotEmpty ? int.tryParse(bureauController.text) : null;

    return DropdownButtonFormField<int>(
      value: currentBureau,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: [
        const DropdownMenuItem(value: 0, child: Text('No bureau')),
        ...availableBureaus.map((bureau) => DropdownMenuItem(
              value: bureau,
              child: Text('Bureau $bureau'),
            )).toList(),
      ],
      onChanged: (value) {
        bureauController.text = value?.toString() ?? '0';
      },
    );
  }

  // Helper to create bureau selection chips for departements
  Widget _bureauSelectionChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Bureaus (1-30)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(30, (index) {
            final bureauNumber = index + 1;
            return FilterChip(
              label: Text('Bureau $bureauNumber'),
              selected: _selectedBureaus.contains(bureauNumber),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedBureaus.add(bureauNumber);
                  } else {
                    _selectedBureaus.remove(bureauNumber);
                  }
                  _deptBureausController.text = _selectedBureaus.join(', ');
                });
              },
            );
          }),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _deptBureausController,
          decoration: const InputDecoration(labelText: 'Selected Bureaus'),
          readOnly: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        // Modern Sidebar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isMenuOpen ? 280 : 70,
          decoration: BoxDecoration(
            color: sidebarBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isMenuOpen
                    ? Row(
                        children: const [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: activeBlue,
                            child: Text('IP',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Institut Pasteur',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const CircleAvatar(
                        radius: 20,
                        backgroundColor: activeBlue,
                        child: Text('IP',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: _buildMenuItemsForRole(),
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 1),
                    SizedBox(
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              tooltip: isMenuOpen ? 'Collapse' : 'Expand',
                              icon: Icon(
                                isMenuOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen())),
                            icon: const Icon(Icons.logout, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8)
                  ],
                ),
              )
            ],
          ),
        ),

        // Main Content Area
        Expanded(
          child: Container(
            color: pageBg,
            child: Column(
              children: [
                // Modern App Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: textOutside,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Clickable user icon with dropdown
                      GestureDetector(
                        onTap: () {
                          _showUserMenu(context);
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFEFF6FF),
                          child: Icon(Icons.person, color: activeBlue),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildBody(),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  // Show user menu when clicking on the user icon
   void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Change Email'),
                onTap: () {
                  Navigator.pop(context);
                  _showChangeEmailDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                //  _showChangePasswordDialog();
                },
              ),
              // Removed: Toggle Dark Mode
              // Removed: Admin Settings
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Current Email'),
                controller: TextEditingController(text: widget.loggedInEmail),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'New Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Confirm New Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email change functionality would be implemented here')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password change functionality would be implemented here')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildMenuItemsForRole() {
    final common = <Widget>[
      _menuItem(icon: Icons.dashboard, label: 'Dashboard', value: Menu.home),
      _menuItem(icon: Icons.notifications, label: 'Notifications', value: Menu.notifications),
      _menuItem(icon: Icons.person, label: 'Profile', value: Menu.profile),
    ];

    if (!isFeddi) {
      common.add(_menuItem(icon: Icons.assignment, label: 'Report', value: Menu.report));
    }

    common.add(_menuItem(icon: Icons.security, label: 'Anti Viruses', value: Menu.antiviruses));

    if (isDepartementUser || isFeddi) {
      final List<Widget> roleExtras = [];
      roleExtras.add(const Divider(color: Colors.white24));
      roleExtras.add(_menuItem(icon: Icons.storage, label: 'Data Base', value: Menu.database));
      roleExtras.add(_menuItem(icon: Icons.person_add, label: 'Add Employee', value: Menu.addEmployee));
      roleExtras.add(_menuItem(icon: Icons.devices, label: 'Create Material', value: Menu.createMaterial));

      if (isFeddi) roleExtras.add(_menuItem(icon: Icons.business, label: 'Manage Departments', value: Menu.manageDepartments));

      return [...common, ...roleExtras];
    }

    return common;
  }

  Widget _menuItem({required IconData icon, required String label, required Menu value}) {
    final isActive = selected == value;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? activeBlue.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? activeBlue : Colors.white70),
        title: isMenuOpen
            ? Text(
                label,
                style: TextStyle(
                  color: isActive ? activeBlue : Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        onTap: () => setState(() => selected = value),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBody() {
    if (isNormalUser && widget.title == 'User Dashboard') return _userBody();

    switch (selected) {
      case Menu.home:
        return _roleHome();
      case Menu.notifications:
        return _roleNotifications();
      case Menu.profile:
        return _cardWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Personal info'),
            _personalInfoForRole(),
          ],
        ));
      case Menu.report:
        return _cardWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Create Report'),
            const SizedBox(height: 16),
            _textField(label: 'Device type'),
            const SizedBox(height: 12),
            _textField(label: 'Device ID'),
            const SizedBox(height: 12),
            _textField(label: 'Date of creation'),
            const SizedBox(height: 12),
            _textField(label: 'Describe the problem', maxLines: 4),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Submit'))),
          ],
        ));
      case Menu.antiviruses:
        return _cardWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Anti Viruses'),
            const SizedBox(height: 16),
            _linkTile('Malwarebytes', 'https://www.malwarebytes.com/'),
            _linkTile('Kaspersky', 'https://www.kaspersky.com/'),
            _linkTile('Bitdefender', 'https://www.bitdefender.com/'),
          ],
        ));
      case Menu.database:
        return _databaseView();
      case Menu.addEmployee:
        return _addEmployeeView();
      case Menu.createMaterial:
        return _createMaterialView();
      case Menu.manageDepartments:
        if (!canManageDepartements()) return _cardWrapper(child: const Text('Access denied.'));
        return _manageDepartementsView();
      case Menu.logout:
        return const SizedBox.shrink();
    }
  }

  // -- User body --
Widget _userBody() {
    switch (selected) {
      case Menu.home:
        // Wider design, same as Feddi/Departement, but only AI Assistant for normal users
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const _AiAssistant(),
        );
      case Menu.notifications:
        return _cardWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Notifications'),
          const SizedBox(height: 16),
          for (var n in notifications)
            if (n.employeeName.isNotEmpty) _deptNotifTile(n) else _notifTile(n.title, n.time)
        ]));
      case Menu.profile:
        final sampleUserId = _emailToSampleUserId(widget.loggedInEmail);
        return _cardWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Personal info'),
          _personalInfoBoxForEmployee(userId: sampleUserId),
          const SizedBox(height: 20),
          _sectionTitle('Assigned Materials'),
          const SizedBox(height: 16),
          for (var m in materials.where((x) => x.userId == sampleUserId))
            _materialItem(deviceType: m.type, deviceId: m.id, modele: m.modele, etat: m.etat, idbureau: m.idbureau),
        ]));
      case Menu.report:
        return _cardWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Create Report'),
          const SizedBox(height: 16),
          _textField(label: 'Device type'),
          const SizedBox(height: 12),
          _textField(label: 'Device ID'),
          const SizedBox(height: 12),
          _textField(label: 'Date of creation'),
          const SizedBox(height: 12),
          _textField(label: 'Describe the problem', maxLines: 4),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Submit'))),
        ]));
      case Menu.antiviruses:
        return _cardWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Anti Viruses'),
          const SizedBox(height: 16),
          _linkTile('Malwarebytes', 'https://www.malwarebytes.com/'),
          _linkTile('Kaspersky', 'https://www.kaspersky.com/'),
          _linkTile('Bitdefender', 'https://www.bitdefender.com/'),
        ]));
      default:
        return const SizedBox.shrink();
    }
  }

  String _emailToSampleUserId(String email) {
    if (email == 'jean.dupont@example.com' || email == 'user@example.com' || email == 'u001@example.com') return 'U001';
    if (email == 'alice.martin@example.com') return 'U002';
    return 'U001';
  }

  // -- Role home --
  Widget _roleHome() {
    // For normal users, show only AI Assistant without statistics
    if (isNormalUser) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // Only the AI Assistant, no statistics or Expanded
        child: const _AiAssistant(),
      );
    }

    // For Feddi and department users, show statistics + AI Assistant
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _statCard('Employees', employees.length.toString()),
              const SizedBox(width: 16),
              if (isFeddi)
                _statCard('Departements', departements.length.toString())
              else
                _statCard('Bureaus', _getBureauCountForDepartement(currentUserDepartement).toString()),
              const SizedBox(width: 16),
              _statCard('Materials', materials.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Expanded(child: _AiAssistant()),
        ],
      ),
    );
  }

  // Helper to get bureau count for a departement
  int _getBureauCountForDepartement(String departementName) {
    final dept = departements.firstWhere(
      (d) => d.nom == departementName,
      orElse: () => DepartementItem(id: '', nom: '', bureauCount: 0),
    );
    return dept.bureauCount;
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: textInside,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: activeBlue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- DeepSeek API call --
  Future<void> _sendChat() async {
    final userText = _chatController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _chat.add(_ChatMessage(fromUser: true, text: userText));
      _chatController.clear();
      _chatLoading = true;
    });

    try {
      final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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',
        'HTTP-Referer': 'http://localhost:3000',
        'X-Title': 'Flutter Dashboard',
      };

      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': 'You are an AI assistant embedded inside a Flutter web admin dashboard for an institute. '
              'You can answer general questions and also guide the user about app features (roles, materials, employees, departments). '
              'Be concise and helpful.'
        },
      ];

      for (final m in _chat) {
        messages.add({'role': m.fromUser ? 'user' : 'assistant', 'content': m.text});
      }

      final body = jsonEncode({
        'model': 'deepseek/deepseek-chat',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 800,
      });

      final resp = await http.post(uri, headers: headers, body: body);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final content = (data['choices']?[0]?['message']?['content'] ?? '').toString();
        setState(() {
          _chat.add(_ChatMessage(fromUser: false, text: content.isEmpty ? '(No response)' : content));
        });
      } else {
        setState(() {
          _chat.add(_ChatMessage(fromUser: false, text: 'Error ${resp.statusCode}: ${resp.body}'));
        });
      }
    } catch (e) {
      setState(() {
        _chat.add(_ChatMessage(fromUser: false, text: 'Request failed: $e'));
      });
    } finally {
      if (mounted) {
        setState(() => _chatLoading = false);
      }
    }
  }

  // -- Notifications --
Widget _roleNotifications() {
  return _cardWrapper(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Notifications'),
      const SizedBox(height: 16),
      for (var n in notifications)
        if (n.employeeName.isNotEmpty) _deptNotifTile(n) else _notifTile(n.title, n.time),
      const SizedBox(height: 16),
      if (isFeddi)
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Feddi Maintenance Actions'),
          const SizedBox(height: 16),
          for (var m in feeddiMaintenance) _feddiActionTile(m),
        ]),
    ]));
}

Widget _deptNotifTile(NotificationItem n) {
  // For normal users, show notification with status
  if (isNormalUser) {
    Color statusColor;
    switch (n.status) {
      case 'accepted':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.report_problem, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Expanded(
            child: Text('${n.title} --- ${n.time}',
                style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              n.status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text('Employee: ${n.employeeName}', style: const TextStyle(color: textInside)),
        Text('Device ID: ${n.deviceId}', style: const TextStyle(color: textInside)),
        Text('Device Type: ${n.deviceType}', style: const TextStyle(color: textInside)),
        Text('Problem: ${n.problem}', style: const TextStyle(color: textInside)),
        if (n.iddepartement.isNotEmpty) Text('Departement: ${n.iddepartement}', style: const TextStyle(color: textInside)),
      ]),
    );
  }
  
  // For Feddi and department users, show with action buttons
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(12)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.report_problem, color: Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Expanded(
          child: Text('${n.title} --- ${n.time}',
              style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600)))
      ]),
      const SizedBox(height: 12),
      Text('Employee: ${n.employeeName}', style: const TextStyle(color: textInside)),
      Text('Device ID: ${n.deviceId}', style: const TextStyle(color: textInside)),
      Text('Device Type: ${n.deviceType}', style: const TextStyle(color: textInside)),
      Text('Problem: ${n.problem}', style: const TextStyle(color: textInside)),
      if (n.iddepartement.isNotEmpty) Text('Departement: ${n.iddepartement}', style: const TextStyle(color: textInside)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (isFeddi) // Only Feddi can accept with date selection
          ElevatedButton(
            onPressed: () => _showDateSelectionDialog(n),
            style: ElevatedButton.styleFrom(
              backgroundColor: activeBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accept'),
          ),
        if (isDepartementUser) // Department users can "accept" but it does nothing
          ElevatedButton(
            onPressed: () {
              // Do nothing as requested - button exists but has no functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Only Feddi can process maintenance requests')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: activeBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accept'),
          ),
        if (isFeddi || isDepartementUser)
          const SizedBox(width: 12),
        if (isFeddi || isDepartementUser)
          ElevatedButton(
            onPressed: () {
              _rejectRequest(n);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
      ])
    ]),
  );
}

// Show date selection dialog for Feddi
void _showDateSelectionDialog(NotificationItem n) {
  final takeDateController = TextEditingController();
  final returnDateController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Schedule Maintenance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: takeDateController,
              decoration: const InputDecoration(
                labelText: 'Take Date (YYYY-MM-DD)',
                hintText: '2023-12-25'
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: returnDateController,
              decoration: const InputDecoration(
                labelText: 'Return Date (YYYY-MM-DD)',
                hintText: '2023-12-28'
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final takeDate = takeDateController.text.trim();
              final returnDate = returnDateController.text.trim();
              
              if (takeDate.isEmpty || returnDate.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter both dates')),
                );
                return;
              }
              
              // Update notification status
              n.status = 'accepted';
              
              // Add to Feddi maintenance list
              feeddiMaintenance.add({
                'employee': n.employeeName,
                'deviceId': n.deviceId,
                'problem': n.problem,
                'iddepartement': n.iddepartement,
                'takeDate': takeDate,
                'returnDate': returnDate,
              });
              
              // Send email notification
              _sendEmailNotification(
                n.employeeName, 
                'accepted', 
                takeDate, 
                returnDate
              );
              
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

// Reject request
void _rejectRequest(NotificationItem n) {
  // Update notification status
  n.status = 'rejected';
  
  // Send email notification
  _sendEmailNotification(n.employeeName, 'rejected', '', '');
  
  setState(() {});
}

// Send email notification (simulated)
void _sendEmailNotification(String employeeName, String status, String takeDate, String returnDate) {
  final message = status == 'accepted' 
    ? 'Your maintenance request has been accepted. Device will be taken on $takeDate and returned on $returnDate.'
    : 'Your maintenance request has been rejected.';
  
  // In a real app, you would integrate with an email service here
  print('Email sent to $employeeName: $message');
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Notification sent to $employeeName')),
  );
}

  Widget _feddiActionTile(Map<String, String> m) {
    final take = m['takeDate'] ?? '';
    final ret = m['returnDate'] ?? '';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Feddi Maintenance for ${m['employee'] ?? ''} --- ${m['deviceId'] ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text('Problem: ${m['problem'] ?? ''}'),
        if ((m['iddepartement'] ?? '').isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 8), child: Text('Departement: ${m['iddepartement']!}')),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: TextFormField(
                  initialValue: take,
                  decoration: const InputDecoration(labelText: 'Take Date (YYYY-MM-DD)'),
                  onChanged: (v) => m['takeDate'] = v)),
          const SizedBox(width: 12),
          Expanded(
              child: TextFormField(
                  initialValue: ret,
                  decoration: const InputDecoration(labelText: 'Return Date (YYYY-MM-DD)'),
                  onChanged: (v) => m['returnDate'] = v)),
        ]),
        const SizedBox(height: 12),
        Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                onPressed: () => setState(() {}),
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'))),
      ]),
    );
  }

  // -- Database view --
  Widget _databaseView() {
    if (isFeddi) {
      return _cardWrapper(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Data Base (Feddi -- full access)'),
          const SizedBox(height: 16),
          // Filter dropdown
          Row(
            children: [
              const Text("Filter by:", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _currentFilter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text("All")),
                  DropdownMenuItem(value: 'type', child: Text("Material Type")),
                  DropdownMenuItem(value: 'modele', child: Text("Modele")),
                  DropdownMenuItem(value: 'iddepartement', child: Text("Departement")),
                  DropdownMenuItem(value: 'idbureau', child: Text("Bureau")),
                ],
                onChanged: (val) {
                  setState(() => _currentFilter = val ?? 'all');
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(
                    hintText: 'Enter filter value',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          // Group by departement
          for (var dept in departements) ...[
            Text('Departement: ${dept.nom}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (dept.bureauCount > 0)
              Text('Bureaus: ${dept.bureauCount}', style: const TextStyle(fontSize: 14, color: textInside)),
            const SizedBox(height: 12),
            // Materials
            const Text('Materials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            for (var m in materials.where((m) => m.iddepartement == dept.nom && _matchesFilter(m)))
              _materialRowAdmin(m),
            const SizedBox(height: 16),
            // Employees
            const Text('Employees', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            for (var e in employees.where((e) => e.iddepartement == dept.nom && _matchesFilter(e)))
              _employeeRowAdmin(e),
            const Divider(thickness: 1, color: borderColor),
            const SizedBox(height: 16),
          ],
        ],
      ));
    }

    if (isDepartementUser) {
      final dept = currentUserDepartement;
      return _cardWrapper(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Data Base (Departement: $dept)'),
        const SizedBox(height: 16),
        _sectionTitle('Materials (this departement only)'),
        const SizedBox(height: 12),
        for (var m in materials.where((mv) => mv.iddepartement == dept)) _materialRowAdmin(m),
        const SizedBox(height: 16),
        _sectionTitle('Employees (this departement only)'),
        const SizedBox(height: 12),
        for (var e in employees.where((ev) => ev.iddepartement == dept)) _employeeRowAdmin(e),
      ]));
    }

    return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Departements Overview'),
      const SizedBox(height: 16),
      _departementOverview(),
    ]));
  }

  bool _matchesFilter(dynamic item) {
    final query = _filterController.text.trim().toLowerCase();
    if (query.isEmpty || _currentFilter == 'all') return true;

    if (item is MaterialItem) {
      switch (_currentFilter) {
        case 'type':
          return item.type.toLowerCase().contains(query);
        case 'modele':
          return item.modele.toLowerCase().contains(query);
        case 'iddepartement':
          return item.iddepartement.toLowerCase().contains(query);
        case 'idbureau':
          return item.idbureau.toString().contains(query);
      }
    } else if (item is EmployeeItem) {
      switch (_currentFilter) {
        case 'iddepartement':
          return item.iddepartement.toLowerCase().contains(query);
        case 'idbureau':
          return item.idbureau.toString().contains(query);
        default:
          return item.nom.toLowerCase().contains(query) ||
              item.prenom.toLowerCase().contains(query) ||
              item.email.toLowerCase().contains(query);
      }
    }
    return true;
  }

  Widget _materialRowAdmin(MaterialItem m) {
    final editable = canEditMaterial(m);
    final removable = canRemoveMaterial(m);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ID: ${m.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Type: ${m.type}'),
            Text('Assigned to: ${m.userId.isEmpty ? "-" : m.userId}'),
            Text('Etat: ${m.etat}'),
            if (m.modele.isNotEmpty) Text('Modele: ${m.modele}'),
            if (m.iddepartement.isNotEmpty) Text('Departement: ${m.iddepartement}'),
            if (m.idbureau > 0) Text('Bureau: ${m.idbureau}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable
                ? () {
                    _matIdController.text = m.id;
                    _matTypeController.text = m.type;
                    _matUserIdController.text = m.userId;
                    _matEtatController.text = m.etat;
                    _matModeleController.text = m.modele;
                    _matIddepartementController.text = m.iddepartement;
                    _matIdbureauController.text = m.idbureau.toString();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Material'),
                        content: SizedBox(
                          width: 420,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(
                                controller: _matIdController,
                                decoration: const InputDecoration(labelText: 'ID')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _matTypeController,
                                decoration: const InputDecoration(labelText: 'Type')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _matUserIdController,
                                decoration: const InputDecoration(labelText: 'User ID (assign)')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _matEtatController,
                                decoration: const InputDecoration(labelText: 'Etat')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _matModeleController,
                                decoration: const InputDecoration(labelText: 'Modele')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _matIddepartementController,
                                decoration: const InputDecoration(labelText: 'Departement')),
                            const SizedBox(height: 12),
                            _bureauDropdown(_matIddepartementController.text, _matIdbureauController),
                          ]),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                m.id = _matIdController.text.trim();
                                m.type = _matTypeController.text.trim();
                                m.userId = _matUserIdController.text.trim();
                                m.etat = _matEtatController.text.trim();
                                m.modele = _matModeleController.text.trim();
                                m.iddepartement = _matIddepartementController.text.trim();
                                m.idbureau = int.tryParse(_matIdbureauController.text) ?? 0;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: activeBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: removable
                ? () {
                    setState(() {
                      materials.remove(m);
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ])
      ]),
    );
  }

  Widget _employeeRowAdmin(EmployeeItem e) {
    final editable = canEditEmployee(e);
    final removable = canRemoveEmployee(e);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e.id} -- ${e.nom} ${e.prenom}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Email: ${e.email}'),
            Text('DOB: ${e.dateNaissance}'),
            Text('Hired: ${e.dateRecrutement}'),
            if (e.iddepartement.isNotEmpty) Text('Departement: ${e.iddepartement}'),
            if (e.idbureau > 0) Text('Bureau: ${e.idbureau}'),
            if (e.role.isNotEmpty) Text('Role: ${e.role}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable
                ? () {
                    _empIdController.text = e.id;
                    _empNomController.text = e.nom;
                    _empPrenomController.text = e.prenom;
                    _empEmailController.text = e.email;
                    _empDateNaissanceController.text = e.dateNaissance;
                    _empDateRecrutementController.text = e.dateRecrutement;
                    _empIddepartementController.text = e.iddepartement;
                    _empIdbureauController.text = e.idbureau.toString();
                    _empRoleController.text = e.role;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Employee'),
                        content: SizedBox(
                          width: 420,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(
                                controller: _empIdController,
                                decoration: const InputDecoration(labelText: 'ID')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empNomController,
                                decoration: const InputDecoration(labelText: 'Nom')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empPrenomController,
                                decoration: const InputDecoration(labelText: 'Prenom')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empEmailController,
                                decoration: const InputDecoration(labelText: 'Email')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empDateNaissanceController,
                                decoration: const InputDecoration(labelText: 'Date de Naissance')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empDateRecrutementController,
                                decoration: const InputDecoration(labelText: 'Date de Recrutement')),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empIddepartementController,
                                decoration: const InputDecoration(labelText: 'Departement')),
                            const SizedBox(height: 12),
                            _bureauDropdown(_empIddepartementController.text, _empIdbureauController),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _empRoleController,
                                decoration: const InputDecoration(labelText: 'Role')),
                          ]),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                e.id = _empIdController.text.trim();
                                e.nom = _empNomController.text.trim();
                                e.prenom = _empPrenomController.text.trim();
                                e.email = _empEmailController.text.trim();
                                e.dateNaissance = _empDateNaissanceController.text.trim();
                                e.dateRecrutement = _empDateRecrutementController.text.trim();
                                e.iddepartement = _empIddepartementController.text.trim();
                                e.idbureau = int.tryParse(_empIdbureauController.text) ?? 0;
                                e.role = _empRoleController.text.trim();
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: activeBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: removable
                ? () {
                    setState(() {
                      employees.remove(e);
                      for (var m in materials) {
                        if (m.userId == e.id) m.userId = '';
                      }
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ])
      ]),
    );
  }

  Widget _departementOverview() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var d in departements)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Departement: ${d.nom}', style: const TextStyle(fontWeight: FontWeight.w700)),
            if (d.description.isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 8), child: Text(d.description)),
            if (d.bureauCount > 0)
              Padding(padding: const EdgeInsets.only(top: 8), child: Text('Bureaus: ${d.bureauCount}')),
            const SizedBox(height: 12),
            _sectionTitle('Employees'),
            for (var e in employees.where((ev) => ev.iddepartement == d.nom))
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      '${e.id} -- ${e.nom} ${e.prenom}${e.idbureau > 0 ? ' (Bureau ${e.idbureau})' : ''}')),
            const SizedBox(height: 12),
            _sectionTitle('Materials'),
            for (var m in materials.where((mv) => mv.iddepartement == d.nom))
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      '${m.id} -- ${m.type} (${m.etat})${m.idbureau > 0 ? ' - Bureau ${m.idbureau}' : ''}')),
          ]),
        )
    ]);
  }

  // -- Add Employee view --
  Widget _addEmployeeView() {
    return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Add New Employee'),
      const SizedBox(height: 16),
      TextField(
          controller: _empIdController, decoration: const InputDecoration(labelText: 'ID')),
      const SizedBox(height: 12),
      TextField(controller: _empNomController, decoration: const InputDecoration(labelText: 'Nom')),
      const SizedBox(height: 12),
      TextField(
          controller: _empPrenomController, decoration: const InputDecoration(labelText: 'Prenom')),
      const SizedBox(height: 12),
      TextField(
          controller: _empEmailController, decoration: const InputDecoration(labelText: 'Email')),
      const SizedBox(height: 12),
      TextField(
          controller: _empDateRecrutementController,
          decoration: const InputDecoration(labelText: 'Date de Recrutement (YYYY-MM-DD)')),
      const SizedBox(height: 12),
      TextField(
          controller: _empDateNaissanceController,
          decoration: const InputDecoration(labelText: 'Date de Naissance (YYYY-MM-DD)')),
      const SizedBox(height: 12),
      // For Departement users, default departement to their own (but they can override)
      TextField(
          controller: _empIddepartementController,
          decoration: InputDecoration(
              labelText: 'Departement', hintText: isDepartementUser ? currentUserDepartement : '')),
      const SizedBox(height: 12),
      // Bureau number input (text field)
      TextField(
        controller: _empIdbureauController,
        decoration: const InputDecoration(
          labelText: 'Bureau Number',
          hintText: 'Enter bureau number (1-30)',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      const SizedBox(height: 12),
      TextField(
          controller: _empRoleController,
          decoration: const InputDecoration(labelText: 'Role (admin, employe)')),
      const SizedBox(height: 20),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            final deptValue = _empIddepartementController.text.trim();
            // If departement user didn't set anything, auto-fill currentUserDepartement
            final resolvedDept =
                deptValue.isEmpty && isDepartementUser ? currentUserDepartement : deptValue;

            final newEmp = EmployeeItem(
              id: _empIdController.text.trim(),
              nom: _empNomController.text.trim(),
              prenom: _empPrenomController.text.trim(),
              dateNaissance: _empDateNaissanceController.text.trim(),
              dateRecrutement: _empDateRecrutementController.text.trim(),
              email: _empEmailController.text.trim(),
              iddepartement: resolvedDept,
              idbureau: int.tryParse(_empIdbureauController.text) ?? 0,
              role: _empRoleController.text.trim(),
            );

            // Permission: only Feddi or Departement user (adding only in their departement) may create employees
            if (isFeddi) {
              setState(() {
                employees.add(newEmp);
              });
            } else if (isDepartementUser) {
              if (newEmp.iddepartement == currentUserDepartement) {
                setState(() {
                  employees.add(newEmp);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Departement users can only add employees to their own departement.')));
                return;
              }
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('You have no permission to add employees.')));
              return;
            }

            // Clear
            _empIdController.clear();
            _empNomController.clear();
            _empPrenomController.clear();
            _empEmailController.clear();
            _empDateNaissanceController.clear();
            _empDateRecrutementController.clear();
            _empIddepartementController.clear();
            _empIdbureauController.clear();
            _empRoleController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: activeBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Create'),
        ),
      )
    ]));
  }

  // -- Create Material view --
  Widget _createMaterialView() {
    return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Create New Material'),
      const SizedBox(height: 16),
      TextField(controller: _matIdController, decoration: const InputDecoration(labelText: 'ID')),
      const SizedBox(height: 12),
      TextField(
          controller: _matTypeController, decoration: const InputDecoration(labelText: 'Type')),
      const SizedBox(height: 12),
      TextField(
          controller: _matUserIdController,
          decoration: const InputDecoration(labelText: 'User ID (optional)')),
      const SizedBox(height: 12),
      TextField(
          controller: _matEtatController,
          decoration: const InputDecoration(labelText: 'Etat (actif, en panne, en reparation)')),
      const SizedBox(height: 12),
      TextField(controller: _matModeleController, decoration: const InputDecoration(labelText: 'Modele')),
      const SizedBox(height: 12),
      TextField(
          controller: _matIddepartementController,
          decoration: InputDecoration(
              labelText: 'Departement (optional)',
              hintText: isDepartementUser ? currentUserDepartement : '')),
      const SizedBox(height: 12),
      // Bureau number input (text field)
      TextField(
        controller: _matIdbureauController,
        decoration: const InputDecoration(
          labelText: 'Bureau Number',
          hintText: 'Enter bureau number (1-30)',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      const SizedBox(height: 20),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            final deptValue = _matIddepartementController.text.trim();
            final resolvedDept =
                deptValue.isEmpty && isDepartementUser ? currentUserDepartement : deptValue;

            final newMat = MaterialItem(
              id: _matIdController.text.trim(),
              type: _matTypeController.text.trim(),
              userId: _matUserIdController.text.trim(),
              etat: _matEtatController.text.trim(),
              modele: _matModeleController.text.trim(),
              iddepartement: resolvedDept,
              idbureau: int.tryParse(_matIdbureauController.text) ?? 0,
            );

            // Permission: Feddi can add any; Departement user can add only materials for their departement
            if (isFeddi) {
              setState(() {
                materials.add(newMat);
              });
            } else if (isDepartementUser) {
              if (newMat.iddepartement == currentUserDepartement) {
                setState(() {
                  materials.add(newMat);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Departement users can only create materials for their own departement.')));
                return;
              }
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('You have no permission to create materials.')));
              return;
            }

            // Clear
            _matIdController.clear();
            _matTypeController.clear();
            _matUserIdController.clear();
            _matEtatController.clear();
            _matModeleController.clear();
            _matIddepartementController.clear();
            _matIdbureauController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: activeBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Create Material'),
        ),
      )
    ]));
  }

  // -- Manage Departements (Feddi) --
  Widget _manageDepartementsView() {
    if (!canManageDepartements()) {
      return _cardWrapper(child: const Text('Access denied.'));
    }

    return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Manage Departements (Feddi)'),
      const SizedBox(height: 16),
      TextField(
          controller: _deptIdController,
          decoration: const InputDecoration(labelText: 'Departement ID (e.g. D-IT)')),
      const SizedBox(height: 12),
      TextField(
          controller: _deptNomController,
          decoration: const InputDecoration(labelText: 'Departement Name (e.g. IT)')),
      const SizedBox(height: 12),
      TextField(
          controller: _deptDescController, decoration: const InputDecoration(labelText: 'Description')),
      const SizedBox(height: 12),
      // Bureau count selection
      _sectionTitle('Number of Bureaus (1-30)'),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        value: _deptBureauCount,
        decoration: const InputDecoration(labelText: 'Bureau Count'),
        items: List.generate(31, (index) {
          return DropdownMenuItem(
            value: index,
            child: Text(index == 0 ? 'No bureaus' : '$index bureaus'),
          );
        }),
        onChanged: (value) {
          setState(() {
            _deptBureauCount = value ?? 0;
          });
        },
      ),
      const SizedBox(height: 20),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            final id = _deptIdController.text.trim();
            final nom = _deptNomController.text.trim();
            if (id.isEmpty || nom.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('ID and Name required')));
              return;
            }

            setState(() {
              departements.add(DepartementItem(
                id: id,
                nom: nom,
                description: _deptDescController.text.trim(),
                bureauCount: _deptBureauCount,
              ));

              // Clear form
              _deptIdController.clear();
              _deptNomController.clear();
              _deptDescController.clear();
              _deptBureauCount = 0;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: activeBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Create Departement'),
        ),
      ),
      const SizedBox(height: 24),
      _sectionTitle('Existing Departements'),
      const SizedBox(height: 16),
      for (var d in departements)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${d.id} -- ${d.nom}', style: const TextStyle(fontWeight: FontWeight.w700)),
              if (d.description.isNotEmpty) Text(d.description),
              if (d.bureauCount > 0) Text('Bureaus: ${d.bureauCount}'),
            ])),
            Column(children: [
              ElevatedButton(
                onPressed: () {
                  _deptIdController.text = d.id;
                  _deptNomController.text = d.nom;
                  _deptDescController.text = d.description;
                  _deptBureauCount = d.bureauCount;
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Edit Departement'),
                      content: SizedBox(
                        width: 420,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                              controller: _deptIdController,
                              decoration: const InputDecoration(labelText: 'ID')),
                          const SizedBox(height: 12),
                          TextField(
                              controller: _deptNomController,
                              decoration: const InputDecoration(labelText: 'Name')),
                          const SizedBox(height: 12),
                          TextField(
                              controller: _deptDescController,
                              decoration: const InputDecoration(labelText: 'Description')),
                          const SizedBox(height: 12),
                          _sectionTitle('Number of Bureaus (1-30)'),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                            value: _deptBureauCount,
                            decoration: const InputDecoration(labelText: 'Bureau Count'),
                            items: List.generate(31, (index) {
                              return DropdownMenuItem(
                                value: index,
                                child: Text(index == 0 ? 'No bureaus' : '$index bureaus'),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _deptBureauCount = value ?? 0;
                              });
                            },
                          ),
                        ]),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              d.id = _deptIdController.text.trim();
                              d.nom = _deptNomController.text.trim();
                              d.description = _deptDescController.text.trim();
                              d.bureauCount = _deptBureauCount;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeBlue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save'),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Edit'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    departements.remove(d);
                    // clear references
                    for (var m in materials) {
                      if (m.iddepartement == d.nom) m.iddepartement = '';
                    }
                    for (var e in employees) {
                      if (e.iddepartement == d.nom) e.iddepartement = '';
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              )
            ])
          ]),
        )
    ]));
  }

  // -- Personal info depending on role --
  Widget _personalInfoForRole() {
    if (isFeddi) {
      // show Feddi-specific info: accepted maintenance tasks etc
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Feddi Info'),
        const SizedBox(height: 12),
        const Text('Role: Feddi -- maintenance & coordination'),
        const SizedBox(height: 16),
        _sectionTitle('Accepted maintenance tasks'),
        const SizedBox(height: 12),
        for (var m in feeddiMaintenance) _feddiActionTile(m),
      ]);
    } else if (isDepartementUser) {
      // show departement info and materials for that departement
      final deptName = currentUserDepartement;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxDepartement(name: deptName),
        const SizedBox(height: 16),
        _sectionTitle('Materials owned by this departement'),
        const SizedBox(height: 12),
        for (var m in materials.where((x) => x.iddepartement == deptName))
          _materialItem(deviceType: m.type, deviceId: m.id, modele: m.modele, etat: m.etat, idbureau: m.idbureau),
      ]);
    } else {
      // normal user
      final sampleUserId = _emailToSampleUserId(widget.loggedInEmail);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxForEmployee(userId: sampleUserId),
        const SizedBox(height: 16),
        _sectionTitle('Assigned Materials'),
        const SizedBox(height: 12),
        for (var m in materials.where((x) => x.userId == sampleUserId))
          _materialItem(deviceType: m.type, deviceId: m.id, modele: m.modele, etat: m.etat, idbureau: m.idbureau),
      ]);
    }
  }

  Widget _personalInfoBoxDepartement({required String name}) {
    final dept = departements.firstWhere((d) => d.nom == name,
        orElse: () => DepartementItem(id: '', nom: ''));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: profileBoxBg, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Departement: $name', style: const TextStyle(fontWeight: FontWeight.w700)),
        if (dept.bureauCount > 0) Text('Bureaus: ${dept.bureauCount}'),
        const SizedBox(height: 8),
        Text('This view lists materials and employees assigned to the departement ($name).')
      ]),
    );
  }

  Widget _personalInfoBoxForEmployee({required String userId}) {
    final emp = employees.firstWhere(
      (e) => e.id == userId,
      orElse: () => EmployeeItem(
          id: userId,
          nom: 'Unknown',
          prenom: '',
          dateNaissance: '',
          dateRecrutement: '',
          email: '',
          iddepartement: '',
          idbureau: 0,
          role: 'employe'),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: profileBoxBg, borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nom: ${emp.nom}',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('Prenom: ${emp.prenom}',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          if (emp.iddepartement.isNotEmpty)
            Text('Departement: ${emp.iddepartement}', style: const TextStyle(color: textInside)),
          if (emp.idbureau > 0) Text('Bureau: ${emp.idbureau}', style: const TextStyle(color: textInside)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Email: ${emp.email}',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('UserID: ${emp.id}',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          if (emp.role.isNotEmpty) Text('Role: ${emp.role}', style: const TextStyle(color: textInside)),
        ]),
      ]),
    );
  }

  // -- UI helpers --
  Widget _cardWrapper({required Widget child}) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      )
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(color: textOutside, fontSize: 18, fontWeight: FontWeight.w700));

  Widget _materialItem(
      {required String deviceType,
      required String deviceId,
      required String modele,
      required String etat,
      required int idbureau}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Device Type: $deviceType',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('ID: $deviceId',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          if (idbureau > 0)
            Text('Bureau: $idbureau',
                style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Modele: $modele',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('Etat: $etat',
              style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }

  Widget _repairHistoryItem(
      {required String deviceType,
      required String deviceId,
      required String problemType,
      required String date}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.build, size: 16, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Text('$deviceType - $deviceId',
              style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600))
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const SizedBox(width: 28),
          Expanded(child: Text('Problem: $problemType', style: const TextStyle(color: textInside, fontSize: 14))),
          Text('Date: $date', style: const TextStyle(color: textInside, fontSize: 14))
        ]),
      ]),
    );
  }

  Widget _maintenanceHistoryItem(
      {required String deviceType, required String deviceId, required String date}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.settings, size: 16, color: Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Text('$deviceType - $deviceId',
            style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text('Date: $date', style: const TextStyle(color: textInside, fontSize: 14))
      ]),
    );
  }

  Widget _textField({required String label, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borderColor),
            ),
          ),
          style: const TextStyle(color: textInside),
        ),
      ],
    );
  }

  Widget _notifTile(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.notifications, color: Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Expanded(
            child: Text(title, style: const TextStyle(color: textOutside, fontWeight: FontWeight.w500))),
        Text(time, style: const TextStyle(color: textInside))
      ]),
    );
  }

  Widget _linkTile(String label, String url) {
    return InkWell(
      onTap: () => _openWebUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.link, color: Color(0xFF6366F1), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_outward, color: Color(0xFF6366F1), size: 16),
          ],
        ),
      ),
    );
  }

  void _openWebUrl(String url) {
    if (kIsWeb) html.window.open(url, '_blank');
  }
}

// ====== Simple chat message model (UI only) ======
class _ChatMessage {
  final bool fromUser;
  final String text;

  _ChatMessage({required this.fromUser, required this.text});
}