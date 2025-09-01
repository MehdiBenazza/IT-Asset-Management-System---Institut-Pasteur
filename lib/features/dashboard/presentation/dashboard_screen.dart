import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../core/models/models.dart';

enum Menu { home, profile, report, antiviruses, database, addEmployee, createMaterial, manageDepartments, logout }

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

  // Colors
  static const Color sidebarBg = Colors.black;
  static const Color activeBlue = Colors.blue;
  static const Color cardWhite = Colors.white;
  static const Color pageBg = Color(0xFF2B2B2B);
  static const Color profileBoxBg = Color(0xFFEAECEF);
  static const Color textOutside = Colors.black;
  static const Color textInside = Color(0xFF404040);

  // Demo in-memory DB
  final List<Materiel> materials = [
    Materiel(id: 1, type: 'Laptop', modele: 'Dell', etat: EtatMaterielEnum.actif),
    Materiel(id: 2, type: 'Desktop', modele: 'HP', etat: EtatMaterielEnum.enPanne),
  ];

  final List<User> employees = [
    User(id: 1, nom: 'Dupont', prenom: 'Jean', email: 'jean.dupont@example.com', role: RoleEnum.employe, actif: true),
    User(id: 2, nom: 'Martin', prenom: 'Alice', email: 'alice.martin@example.com', role: RoleEnum.employe, actif: true),
  ];

  final List<Departement> departments = [
    Departement(id: 1, nom: 'IT'),
    Departement(id: 2, nom: 'Finance'),
  ];

  // Feddi maintenance accepted items
  final List<Map<String, String>> feeddiMaintenance = [];

  // Controllers
  final _matIdController = TextEditingController();
  final _matTypeController = TextEditingController();
  final _matUserIdController = TextEditingController();
  final _matStateController = TextEditingController();
  final _matOsController = TextEditingController();
  final _matDepartmentController = TextEditingController();

  final _empUserIdController = TextEditingController();
  final _empNomController = TextEditingController();
  final _empPrenomController = TextEditingController();
  final _empEmailController = TextEditingController();
  final _empDateNaissanceController = TextEditingController();
  final _empDateRecrutementController = TextEditingController();
  final _empDepartmentController = TextEditingController();

  final _deptIdController = TextEditingController();
  final _deptNameController = TextEditingController();
  final _deptDescController = TextEditingController();

  @override
  void dispose() {
    _matIdController.dispose();
    _matTypeController.dispose();
    _matUserIdController.dispose();
    _matStateController.dispose();
    _matOsController.dispose();
    _matDepartmentController.dispose();

    _empUserIdController.dispose();
    _empNomController.dispose();
    _empPrenomController.dispose();
    _empEmailController.dispose();
    _empDateNaissanceController.dispose();
    _empDateRecrutementController.dispose();
    _empDepartmentController.dispose();

    _deptIdController.dispose();
    _deptNameController.dispose();
    _deptDescController.dispose();
    super.dispose();
  }

  // Role helpers
  bool get isFeddi => widget.loggedInEmail == 'feddi@gmail.com';
  bool get isDepartementUser => widget.loggedInEmail == 'departement@gmail.com';
  bool get isNormalUser => !isFeddi && !isDepartementUser;

  // For the demo, map the department user email to a department name. Replace with real mapping in production.
  String get currentUserDepartment {
    if (isDepartementUser) return 'IT'; // demo mapping: departement@gmail.com => IT
    // If normal user has mapping to employee id with department, you could return that employee's department
    final mapped = _employeeByEmail(widget.loggedInEmail);
    if (mapped != null) return mapped.bureau?.departement?.nom ?? '';
    return '';
  }

  // find employee by email
  User? _employeeByEmail(String email) {
    try {
      return employees.firstWhere((e) => e.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  // Permission checks
  bool canEditEmployee(User e) {
    if (isFeddi) return true; // feddi can edit all
    if (isDepartementUser) {
      return e.bureau?.departement?.nom == currentUserDepartment; // can edit employees within own department
    }
    return false;
  }

  bool canRemoveEmployee(User e) {
    return canEditEmployee(e);
  }

  bool canEditMaterial(Materiel m) {
    if (isFeddi) return true;
    if (isDepartementUser) return m.getBureauByMateriel()?.departement?.nom == currentUserDepartment;
    return false;
  }

  bool canRemoveMaterial(Materiel m) {
    return canEditMaterial(m);
  }

  bool canManageDepartments() {
    return isFeddi; // only feddi
  }

  bool canCreateReport() {
    // Department user and normal user can create reports. Feddi can view but not necessarily submit (keep open — we won't block)
    return !isFeddi; // per your earlier rules, depart & normal can create reports; feddi typically doesn't
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        // Sidebar
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isMenuOpen ? 260 : 64,
          color: sidebarBg,
          child: Column(children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: isMenuOpen
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                      CircleAvatar(radius: 18, backgroundColor: Colors.blue, child: Text('IP', style: TextStyle(fontSize: 12))),
                      SizedBox(width: 10),
                      Text('Institut Pasteur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ])
                  : const CircleAvatar(radius: 16, backgroundColor: Colors.blue, child: Text('IP', style: TextStyle(fontSize: 11))),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(children: [
                Expanded(child: ListView(padding: EdgeInsets.zero, children: _buildMenuItemsForRole())),
                const Divider(color: Colors.white24, height: 1),
                SizedBox(
                  height: 56,
                  child: Row(children: [
                    Expanded(
                      child: IconButton(
                        tooltip: isMenuOpen ? 'Collapse' : 'Expand',
                        icon: Icon(isMenuOpen ? Icons.arrow_back_ios : Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        onPressed: () => setState(() => isMenuOpen = !isMenuOpen),
                      ),
                    ),
                    IconButton(onPressed: () { /* TODO: Implement logout. The LoginScreen is not defined. */ }, icon: const Icon(Icons.logout, color: Colors.white)),
                  ]),
                ),
                const SizedBox(height: 8)
              ]),
            )
          ]),
        ),

        // Main area
        Expanded(
          child: Container(
            color: pageBg,
            child: Column(children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                ]),
              ),
              Expanded(child: _buildBody()),
            ]),
          ),
        )
      ]),
    );
  }

  List<Widget> _buildMenuItemsForRole() {
    final common = <Widget>[
      _menuItem(icon: Icons.home, label: 'Home', value: Menu.home),
      _menuItem(icon: Icons.person, label: 'Profile', value: Menu.profile),
    ];

    if (!isFeddi) {
      // Report can be created by Department & Normal users
      common.add(_menuItem(icon: Icons.assignment, label: 'Report', value: Menu.report));
    }

    common.add(_menuItem(icon: Icons.shield, label: 'Anti Viruses', value: Menu.antiviruses));

    if (isDepartementUser || isFeddi) {
      final List<Widget> roleExtras = [];
      roleExtras.add(const Divider(color: Colors.white24));
      roleExtras.add(_menuItem(icon: Icons.storage, label: 'Data Base', value: Menu.database));
      roleExtras.add(_menuItem(icon: Icons.person_add, label: 'Add Employee', value: Menu.addEmployee));
      roleExtras.add(_menuItem(icon: Icons.add_box, label: 'Create Material', value: Menu.createMaterial));
      if (isFeddi) roleExtras.add(_menuItem(icon: Icons.apartment, label: 'Manage Departments', value: Menu.manageDepartments));
      return [...common, ...roleExtras];
    }

    return common;
  }

  Widget _menuItem({required IconData icon, required String label, required Menu value}) {
    final isActive = selected == value;
    return ListTile(
      leading: Icon(icon, color: isActive ? activeBlue : Colors.white),
      title: isMenuOpen ? Text(label, style: TextStyle(color: isActive ? activeBlue : Colors.white, fontWeight: FontWeight.w500)) : null,
      onTap: () => setState(() => selected = value),
    );
  }

  Widget _buildBody() {
    if (isNormalUser && widget.title == 'User Dashboard') return _userBody();

    switch (selected) {
      case Menu.home:
        return _roleHome();
      case Menu.profile:
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Personal info'),
          _personalInfoForRole(),
        ]));
      case Menu.report:
        // shown for normal & department users
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Create Report'),
          const SizedBox(height: 12),
          _textField(label: 'Device type'),
          const SizedBox(height: 10),
          _textField(label: 'Device ID'),
          const SizedBox(height: 10),
          _textField(label: 'Date of creation'),
          const SizedBox(height: 10),
          _textField(label: 'Describe the problem', maxLines: 6),
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: canCreateReport() ? () {} : null, child: const Text('Submit'))),
        ]));
      case Menu.antiviruses:
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Anti Viruses'),
          const SizedBox(height: 8),
          _linkTile('Malwarebytes', 'https://www.malwarebytes.com/'),
          _linkTile('Kaspersky', 'https://www.kaspersky.com/'),
          _linkTile('Bitdefender', 'https://www.bitdefender.com/'),
        ]));
      case Menu.database:
        return _databaseView();
      case Menu.addEmployee:
        return _addEmployeeView();
      case Menu.createMaterial:
        return _createMaterialView();
      case Menu.manageDepartments:
        if (!canManageDepartments()) return _cardWrapper(child: const Text('Access denied.'));
        return _manageDepartmentsView();
      case Menu.logout:
        return const SizedBox.shrink();
    }
  }

  // ---------------- User body ----------------
  Widget _userBody() {
    switch (selected) {
      case Menu.home:
        return LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Container(
                  width: 520,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(12)),
                  child: const Text('AI Assistant Placeholder', textAlign: TextAlign.center, style: TextStyle(color: textOutside, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          );
        });
      case Menu.profile:
        final sampleUserId = _emailToSampleUserId(widget.loggedInEmail);
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Personal info'),
          _personalInfoBoxForEmployee(userId: sampleUserId),
          const SizedBox(height: 20),
          _sectionTitle('Assigned Materials'),
          const SizedBox(height: 8),
          for (var m in materials.where((x) => x. User.id == sampleUserId)) _materialItem(deviceType: m.type, deviceId: m.id, marque: m.os, os: m.state),
        ]));
      case Menu.report:
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Create Report'),
          const SizedBox(height: 12),
          _textField(label: 'Device type'),
          const SizedBox(height: 10),
          _textField(label: 'Device ID'),
          const SizedBox(height: 10),
          _textField(label: 'Date of creation'),
          const SizedBox(height: 10),
          _textField(label: 'Describe the problem', maxLines: 6),
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, child: const Text('Submit'))),
        ]));
      case Menu.antiviruses:
        return _cardWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Anti Viruses'),
          const SizedBox(height: 8),
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
    // fallback demo id
    return 'U001';
  }

  // ---------------- Role home ----------------
  Widget _roleHome() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Container(
              width: 720,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                const Text('AI Assistant Placeholder', textAlign: TextAlign.center, style: TextStyle(color: textOutside, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 18),
                const Text('Quick stats:', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _statCard('Employees', employees.length.toString()),
                  _statCard('Materials', materials.length.toString()),
                ]),
              ]),
            ),
          ),
        ),
      );
    });
  }

  Widget _statCard(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: profileBoxBg, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))]),
    );
  }

  Widget _feddiActionTile(Map<String, String> m) {
    final take = m['takeDate'] ?? '';
    final ret = m['returnDate'] ?? '';
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Feddi Maintenance for ${m['employee'] ?? ''} — ${m['deviceId'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Problem: ${m['problem'] ?? ''}'),
        if ((m['department'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Department: ${m['department']!}')),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextFormField(initialValue: take, decoration: const InputDecoration(labelText: 'Take Date (YYYY-MM-DD)'), onChanged: (v) => m['takeDate'] = v)),
          const SizedBox(width: 8),
          Expanded(child: TextFormField(initialValue: ret, decoration: const InputDecoration(labelText: 'Return Date (YYYY-MM-DD)'), onChanged: (v) => m['returnDate'] = v)),
        ]),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => setState(() {}), child: const Text('Save'))),
      ]),
    );
  }

// ---------------- Database view ----------------
Widget _databaseView() {
  // For Feddi: grouped by department with filter
  if (isFeddi) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Data Base (Feddi — full access)'),
          const SizedBox(height: 12),

          // Filter dropdown
          Row(
            children: [
              const Text("Filter by:", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _currentFilter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text("All")),
                  DropdownMenuItem(value: 'type', child: Text("Material Type")),
                  DropdownMenuItem(value: 'os', child: Text("OS")),
                  DropdownMenuItem(value: 'department', child: Text("Department")),
                ],
                onChanged: (val) {
                  setState(() => _currentFilter = val ?? 'all');
                },
              ),
              const SizedBox(width: 10),
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

          const SizedBox(height: 20),

          // Group by department
          for (var dept in departments) ...[
            Text('Department: ${dept.nom}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Materials
            const Text('Materials',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            for (var m in materials.where((m) =>
                m.department == dept.nom && _matchesFilter(m))) _materialRowAdmin(m),

            const SizedBox(height: 12),

            // Employees
            const Text('Employees',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            for (var e in employees.where((e) =>
                e.department == dept.nom && _matchesFilter(e))) _employeeRowAdmin(e),

            const Divider(thickness: 1),
          ],
        ],
      ),
    );
  }

  // Department user: unchanged
  if (isDepartementUser) {
    final dept = currentUserDepartment;
    return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle('Data Base (Department: $dept)'),
      const SizedBox(height: 12),
      _sectionTitle('Materials (this department only)'),
      const SizedBox(height: 8),
      for (var m in materials.where((mv) => mv.department == dept)) _materialRowAdmin(m),
      const SizedBox(height: 12),
      _sectionTitle('Employees (this department only)'),
      const SizedBox(height: 8),
      for (var e in employees.where((ev) => ev.department == dept)) _employeeRowAdmin(e),
    ]));
  }

  // Normal user: unchanged
  return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _sectionTitle('Departments Overview'),
    const SizedBox(height: 8),
    _departmentOverview(),
  ]));
}

// --- helpers for filtering ---
String _currentFilter = 'all';
final _filterController = TextEditingController();

bool _matchesFilter(dynamic item) {
  final query = _filterController.text.trim().toLowerCase();
  if (query.isEmpty || _currentFilter == 'all') return true;

  if (item is MaterialItem) {
    switch (_currentFilter) {
      case 'type':
        return item.type.toLowerCase().contains(query);
      case 'os':
        return item.os.toLowerCase().contains(query);
      case 'department':
        return item.department.toLowerCase().contains(query);
    }
  } else if (item is EmployeeItem) {
    switch (_currentFilter) {
      case 'department':
        return item.department.toLowerCase().contains(query);
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ID: ${m.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Type: ${m.type}'),
            Text('Assigned to: ${m.userId.isEmpty ? "-" : m.userId}'),
            Text('State: ${m.state}'),
            if (m.os.isNotEmpty) Text('OS: ${m.os}'),
            if (m.department.isNotEmpty) Text('Department: ${m.department}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable
                ? () {
                    _matIdController.text = m.id;
                    _matTypeController.text = m.type;
                    _matUserIdController.text = m.userId;
                    _matStateController.text = m.state;
                    _matOsController.text = m.os;
                    _matDepartmentController.text = m.department;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Material'),
                        content: SizedBox(
                          width: 420,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(controller: _matIdController, decoration: const InputDecoration(labelText: 'ID')),
                            TextField(controller: _matTypeController, decoration: const InputDecoration(labelText: 'Type')),
                            TextField(controller: _matUserIdController, decoration: const InputDecoration(labelText: 'User ID (assign)')),
                            TextField(controller: _matStateController, decoration: const InputDecoration(labelText: 'State')),
                            TextField(controller: _matOsController, decoration: const InputDecoration(labelText: 'OS')),
                            TextField(controller: _matDepartmentController, decoration: const InputDecoration(labelText: 'Department')),
                          ]),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                m.id = _matIdController.text.trim();
                                m.type = _matTypeController.text.trim();
                                m.userId = _matUserIdController.text.trim();
                                m.state = _matStateController.text.trim();
                                m.os = _matOsController.text.trim();
                                m.department = _matDepartmentController.text.trim();
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  }
                : null,
            child: const Text('Edit'),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: removable
                ? () {
                    setState(() {
                      materials.remove(m);
                    });
                  }
                : null,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e.userId} — ${e.nom} ${e.prenom}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Email: ${e.email}'),
            Text('DOB: ${e.dateNaissance}'),
            Text('Hired: ${e.dateRecrutement}'),
            if (e.department.isNotEmpty) Text('Department: ${e.department}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable
                ? () {
                    _empUserIdController.text = e.userId;
                    _empNomController.text = e.nom;
                    _empPrenomController.text = e.prenom;
                    _empEmailController.text = e.email;
                    _empDateNaissanceController.text = e.dateNaissance;
                    _empDateRecrutementController.text = e.dateRecrutement;
                    _empDepartmentController.text = e.department;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Employee'),
                        content: SizedBox(
                          width: 420,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(controller: _empUserIdController, decoration: const InputDecoration(labelText: 'User ID')),
                            TextField(controller: _empNomController, decoration: const InputDecoration(labelText: 'Nom')),
                            TextField(controller: _empPrenomController, decoration: const InputDecoration(labelText: 'Prenom')),
                            TextField(controller: _empEmailController, decoration: const InputDecoration(labelText: 'Email')),
                            TextField(controller: _empDateNaissanceController, decoration: const InputDecoration(labelText: 'Date de Naissance')),
                            TextField(controller: _empDateRecrutementController, decoration: const InputDecoration(labelText: 'Date de Recrutement')),
                            TextField(controller: _empDepartmentController, decoration: const InputDecoration(labelText: 'Department')),
                          ]),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                e.userId = _empUserIdController.text.trim();
                                e.nom = _empNomController.text.trim();
                                e.prenom = _empPrenomController.text.trim();
                                e.email = _empEmailController.text.trim();
                                e.dateNaissance = _empDateNaissanceController.text.trim();
                                e.dateRecrutement = _empDateRecrutementController.text.trim();
                                e.department = _empDepartmentController.text.trim();
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  }
                : null,
            child: const Text('Edit'),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: removable
                ? () {
                    setState(() {
                      employees.remove(e);
                      for (var m in materials) {
                        if (m.userId == e.userId) m.userId = '';
                      }
                    });
                  }
                : null,
            child: const Text('Remove'),
          ),
        ])
      ]),
    );
  }

  Widget _departmentOverview() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var d in departments)
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Department: ${d.nom}', style: const TextStyle(fontWeight: FontWeight.w700)),
            if (d.description.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(d.description)),
            const SizedBox(height: 8),
            _sectionTitle('Employees'),
            for (var e in employees.where((ev) => ev.department == d.nom)) Padding(padding: const EdgeInsets.only(top: 6), child: Text('${e.userId} — ${e.nom} ${e.prenom}')),
            const SizedBox(height: 8),
            _sectionTitle('Materials'),
            for (var m in materials.where((mv) => mv.department == d.nom)) Padding(padding: const EdgeInsets.only(top: 6), child: Text('${m.id} — ${m.type} (${m.state})')),
          ]),
        )
    ]);
  }

  // ---------------- Add Employee view ----------------
  Widget _addEmployeeView() {
    return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Add New Employee'),
        const SizedBox(height: 12),
        TextField(controller: _empUserIdController, decoration: const InputDecoration(labelText: 'User ID')),
        const SizedBox(height: 8),
        TextField(controller: _empNomController, decoration: const InputDecoration(labelText: 'Nom')),
        const SizedBox(height: 8),
        TextField(controller: _empPrenomController, decoration: const InputDecoration(labelText: 'Prenom')),
        const SizedBox(height: 8),
        TextField(controller: _empEmailController, decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 8),
        TextField(controller: _empDateRecrutementController, decoration: const InputDecoration(labelText: 'Date de Recrutement (YYYY-MM-DD)')),
        const SizedBox(height: 8),
        TextField(controller: _empDateNaissanceController, decoration: const InputDecoration(labelText: 'Date de Naissance (YYYY-MM-DD)')),
        const SizedBox(height: 8),
        // For Department users, default department to their own (but they can override)
        TextField(controller: _empDepartmentController, decoration: InputDecoration(labelText: 'Department', hintText: isDepartementUser ? currentUserDepartment : '')),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              final deptValue = _empDepartmentController.text.trim();
              // If department user didn't set anything, auto-fill currentUserDepartment
              final resolvedDept = deptValue.isEmpty && isDepartementUser ? currentUserDepartment : deptValue;
              final newEmp = EmployeeItem(
                userId: _empUserIdController.text.trim(),
                nom: _empNomController.text.trim(),
                prenom: _empPrenomController.text.trim(),
                dateNaissance: _empDateNaissanceController.text.trim(),
                dateRecrutement: _empDateRecrutementController.text.trim(),
                email: _empEmailController.text.trim(),
                department: resolvedDept,
              );

              // Permission: only Feddi or Department user (adding only in their department) may create employees
              if (isFeddi) {
                setState(() {
                  employees.add(newEmp);
                });
              } else if (isDepartementUser) {
                if (newEmp.department == currentUserDepartment) {
                  setState(() {
                    employees.add(newEmp);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Department users can only add employees to their own department.')));
                  return;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have no permission to add employees.')));
                return;
              }

              // Clear
              _empUserIdController.clear();
              _empNomController.clear();
              _empPrenomController.clear();
              _empEmailController.clear();
              _empDateNaissanceController.clear();
              _empDateRecrutementController.clear();
              _empDepartmentController.clear();
            },
            child: const Text('Create'),
          ),
        )
      ]),
    );
  }

  // ---------------- Create Material view ----------------
  Widget _createMaterialView() {
    return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Create New Material'),
        const SizedBox(height: 12),
        TextField(controller: _matIdController, decoration: const InputDecoration(labelText: 'ID')),
        const SizedBox(height: 8),
        TextField(controller: _matTypeController, decoration: const InputDecoration(labelText: 'Type')),
        const SizedBox(height: 8),
        TextField(controller: _matUserIdController, decoration: const InputDecoration(labelText: 'User ID (optional)')),
        const SizedBox(height: 8),
        TextField(controller: _matStateController, decoration: const InputDecoration(labelText: 'State (working / not working)')),
        const SizedBox(height: 8),
        TextField(controller: _matOsController, decoration: const InputDecoration(labelText: 'OS')),
        const SizedBox(height: 8),
        TextField(controller: _matDepartmentController, decoration: InputDecoration(labelText: 'Department (optional)', hintText: isDepartementUser ? currentUserDepartment : '')),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              final deptValue = _matDepartmentController.text.trim();
              final resolvedDept = deptValue.isEmpty && isDepartementUser ? currentUserDepartment : deptValue;

              final newMat = MaterialItem(
                id: _matIdController.text.trim(),
                type: _matTypeController.text.trim(),
                userId: _matUserIdController.text.trim(),
                state: _matStateController.text.trim(),
                os: _matOsController.text.trim(),
                department: resolvedDept,
              );

              // Permission: Feddi can add any; Department user can add only materials for their department
              if (isFeddi) {
                setState(() {
                  materials.add(newMat);
                });
              } else if (isDepartementUser) {
                if (newMat.department == currentUserDepartment) {
                  setState(() {
                    materials.add(newMat);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Department users can only create materials for their own department.')));
                  return;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have no permission to create materials.')));
                return;
              }

              // Clear
              _matIdController.clear();
              _matTypeController.clear();
              _matUserIdController.clear();
              _matStateController.clear();
              _matOsController.clear();
              _matDepartmentController.clear();
            },
            child: const Text('Create Material'),
          ),
        )
      ]),
    );
  }

  // ---------------- Manage Departments (Feddi) ----------------
  Widget _manageDepartmentsView() {
    if (!canManageDepartments()) {
      return _cardWrapper(child: const Text('Access denied.'));
    }

    return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Manage Departments (Feddi)'),
        const SizedBox(height: 12),
        TextField(controller: _deptIdController, decoration: const InputDecoration(labelText: 'Department ID (e.g. D-IT)')),
        const SizedBox(height: 8),
        TextField(controller: _deptNameController, decoration: const InputDecoration(labelText: 'Department Name (e.g. IT)')),
        const SizedBox(height: 8),
        TextField(controller: _deptDescController, decoration: const InputDecoration(labelText: 'Description')),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              final id = _deptIdController.text.trim();
              final name = _deptNameController.text.trim();
              if (id.isEmpty || name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID and Name required')));
                return;
              }
              setState(() {
                departments.add(DepartmentItem(id: id, nom: name, description: _deptDescController.text.trim()));
                _deptIdController.clear();
                _deptNameController.clear();
                _deptDescController.clear();
              });
            },
            child: const Text('Create Department'),
          ),
        ),
        const SizedBox(height: 12),
        _sectionTitle('Existing Departments'),
        const SizedBox(height: 8),
        for (var d in departments)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${d.id} — ${d.nom}', style: const TextStyle(fontWeight: FontWeight.w700)), if (d.description.isNotEmpty) Text(d.description)])),
              Column(children: [
                ElevatedButton(
                  onPressed: () {
                    _deptIdController.text = d.id;
                    _deptNameController.text = d.nom;
                    _deptDescController.text = d.description;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Department'),
                        content: SizedBox(
                          width: 420,
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(controller: _deptIdController, decoration: const InputDecoration(labelText: 'ID')),
                            TextField(controller: _deptNameController, decoration: const InputDecoration(labelText: 'Name')),
                            TextField(controller: _deptDescController, decoration: const InputDecoration(labelText: 'Description')),
                          ]),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  d.id = _deptIdController.text.trim();
                                  d.nom = _deptNameController.text.trim();
                                  d.description = _deptDescController.text.trim();
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Save'))
                        ],
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      departments.remove(d);
                      // clear references
                      for (var m in materials) {
                        if (m.department == d.nom) m.department = '';
                      }
                      for (var e in employees) {
                        if (e.department == d.nom) e.department = '';
                      }
                    });
                  },
                  child: const Text('Remove'),
                ),
              ])
            ]),
          )
      ]),
    );
  }

  // ---------------- Personal info depending on role ----------------
  Widget _personalInfoForRole() {
    if (isFeddi) {
      // show Feddi-specific info: accepted maintenance tasks etc
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Feddi Info'),
        const SizedBox(height: 8),
        const Text('Role: Feddi — maintenance & coordination'),
        const SizedBox(height: 12),
        _sectionTitle('Accepted maintenance tasks'),
        const SizedBox(height: 8),
        for (var m in feeddiMaintenance) _feddiActionTile(m),
      ]);
    } else if (isDepartementUser) {
      // show department info and materials for that department
      final deptName = currentUserDepartment;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxDepartment(name: deptName),
        const SizedBox(height: 12),
        _sectionTitle('Materials owned by this department'),
        const SizedBox(height: 8),
        for (var m in materials.where((x) => x.department == deptName)) _materialItem(deviceType: m.type, deviceId: m.id, marque: m.os, os: m.state),
      ]);
    } else {
      // normal user
      final sampleUserId = _emailToSampleUserId(widget.loggedInEmail);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxForEmployee(userId: sampleUserId),
        const SizedBox(height: 12),
        _sectionTitle('Assigned Materials'),
        const SizedBox(height: 8),
        for (var m in materials.where((x) => x.userId == sampleUserId)) _materialItem(deviceType: m.type, deviceId: m.id, marque: m.os, os: m.state),
      ]);
    }
  }

  Widget _personalInfoBoxDepartment({required String name}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: profileBoxBg, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Department: $name', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text('This view lists materials and employees assigned to the department ($name).')]),
    );
  }

  Widget _personalInfoBoxForEmployee({required String userId}) {
    final emp = employees.firstWhere((e) => e.userId == userId, orElse: () => EmployeeItem(userId: userId, nom: 'Unknown', prenom: '', dateNaissance: '', dateRecrutement: '', email: '', department: ''));
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: profileBoxBg, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nom: ${emp.nom}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('Prenom: ${emp.prenom}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          if (emp.department.isNotEmpty) Text('Department: ${emp.department}', style: const TextStyle(color: textInside)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Email: ${emp.email}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('UserID: ${emp.userId}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }

  // ---------------- UI helpers ----------------
  Widget _cardWrapper({required Widget child}) {
    return SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(30.0), child: Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: cardWhite, borderRadius: BorderRadius.circular(12)), child: child)));
  }

  Widget _sectionTitle(String text) => Text(text, style: const TextStyle(color: textOutside, fontSize: 16, fontWeight: FontWeight.w700));

  Widget _materialItem({required String deviceType, required String deviceId, required String marque, required String os}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Device Type: $deviceType', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)), Text('ID: $deviceId', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500))]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('OS: $marque', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)), Text('State: $os', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500))]),
      ]),
    );
  }

  Widget _repairHistoryItem({required String deviceType, required String deviceId, required String problemType, required String date}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Icon(Icons.build, size: 16, color: Colors.black54), const SizedBox(width: 8), Text('$deviceType - $deviceId', style: const TextStyle(color: textOutside, fontSize: 14, fontWeight: FontWeight.w600))]),
        const SizedBox(height: 8),
        Row(children: [const SizedBox(width: 24), Expanded(child: Text('Problem: $problemType', style: const TextStyle(color: textInside, fontSize: 14))), Text('Date: $date', style: const TextStyle(color: textInside, fontSize: 14))]),
      ]),
    );
  }

  Widget _maintenanceHistoryItem({required String deviceType, required String deviceId, required String date}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [const Icon(Icons.settings, size: 16, color: Colors.black54), const SizedBox(width: 8), Text('$deviceType - $deviceId', style: const TextStyle(color: textOutside, fontSize: 14, fontWeight: FontWeight.w600)), const Spacer(), Text('Date: $date', style: const TextStyle(color: textInside, fontSize: 14))]),
    );
  }

  Widget _textField({required String label, int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: textOutside, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      TextField(maxLines: maxLines, decoration: InputDecoration(filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))), style: const TextStyle(color: textInside)),
    ]);
  }

  Widget _linkTile(String label, String url) {
    return InkWell(onTap: () => _openWebUrl(url), child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [const Icon(Icons.link, color: Colors.black87), const SizedBox(width: 10), Expanded(child: Text(label, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.w600)))])));
  }

  void _openWebUrl(String url) {
    if (kIsWeb) html.window.open(url, '_blank');
  }
}