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

  // Role helpers
  bool get isFeddi => widget.loggedInEmail == 'feddi@gmail.com';
  bool get isDepartementUser => widget.loggedInEmail == 'departement@gmail.com';
  bool get isNormalUser => !isFeddi && !isDepartementUser;

  // For the demo, map the department user email to a department name
  String get currentUserDepartment {
    if (isDepartementUser) return 'IT'; // demo mapping: departement@gmail.com => IT
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
    // Pour les matériels, on ne peut pas déterminer le département directement
    // Il faudrait utiliser une relation via localisation ou appartenance
    if (isDepartementUser) return false; // Temporairement désactivé
    return false;
  }

  bool canRemoveMaterial(Materiel m) {
    return canEditMaterial(m);
  }

  bool canManageDepartments() {
    return isFeddi; // only feddi
  }

  bool canCreateReport() {
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
                    IconButton(onPressed: () { /* TODO: Implement logout */ }, icon: const Icon(Icons.logout, color: Colors.white)),
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
          for (var m in materials.where((x) => x.id.toString() == sampleUserId)) 
            _materialItem(deviceType: m.type, deviceId: m.id?.toString() ?? '', marque: m.modele ?? '', os: m.etat.name),
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

  // ---------------- Database view ----------------
  Widget _databaseView() {
    // For Feddi: show all materials and employees
    if (isFeddi) {
      return _cardWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Data Base (Feddi — full access)'),
            const SizedBox(height: 12),
            _sectionTitle('Materials'),
            const SizedBox(height: 8),
            for (var m in materials) _materialRowAdmin(m),
            const SizedBox(height: 12),
            _sectionTitle('Employees'),
            const SizedBox(height: 8),
            for (var e in employees) _employeeRowAdmin(e),
          ],
        ),
      );
    }

    // Department user: show materials and employees
    if (isDepartementUser) {
      final dept = currentUserDepartment;
      return _cardWrapper(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Data Base (Department: $dept)'),
          const SizedBox(height: 12),
          _sectionTitle('Materials'),
          const SizedBox(height: 8),
          for (var m in materials) _materialRowAdmin(m),
          const SizedBox(height: 12),
          _sectionTitle('Employees'),
          const SizedBox(height: 8),
          for (var e in employees) _employeeRowAdmin(e),
        ]),
      );
    }

    // Normal user: show departments overview
    return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Departments Overview'),
        const SizedBox(height: 8),
        _departmentOverview(),
      ]),
    );
  }

  Widget _materialRowAdmin(Materiel m) {
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
            Text('Model: ${m.modele ?? "N/A"}'),
            Text('State: ${m.etat.name}'),
            if (m.os != null) Text('OS: ${m.os}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable ? () {} : null,
            child: const Text('Edit'),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: removable ? () {} : null,
            child: const Text('Remove'),
          ),
        ])
      ]),
    );
  }

  Widget _employeeRowAdmin(User e) {
    final editable = canEditEmployee(e);
    final removable = canRemoveEmployee(e);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e.id} — ${e.nom} ${e.prenom}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Email: ${e.email}'),
            Text('Role: ${e.role.name}'),
            Text('Active: ${e.actif ? "Yes" : "No"}'),
          ]),
        ),
        Column(children: [
          ElevatedButton(
            onPressed: editable ? () {} : null,
            child: const Text('Edit'),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: removable ? () {} : null,
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
            const SizedBox(height: 8),
            _sectionTitle('Employees'),
            for (var e in employees) Padding(padding: const EdgeInsets.only(top: 6), child: Text('${e.id} — ${e.nom} ${e.prenom}')),
            const SizedBox(height: 8),
            _sectionTitle('Materials'),
            for (var m in materials) Padding(padding: const EdgeInsets.only(top: 6), child: Text('${m.id} — ${m.type} (${m.etat.name})')),
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
        const Text('This feature is not implemented in this demo version.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature not implemented')));
          },
          child: const Text('Add Employee (Demo)'),
        ),
      ]),
    );
  }

  // ---------------- Create Material view ----------------
  Widget _createMaterialView() {
    return _cardWrapper(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Create New Material'),
        const SizedBox(height: 12),
        const Text('This feature is not implemented in this demo version.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature not implemented')));
          },
          child: const Text('Create Material (Demo)'),
        ),
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
        const Text('This feature is not implemented in this demo version.'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature not implemented')));
          },
          child: const Text('Manage Departments (Demo)'),
        ),
      ]),
    );
  }

  // ---------------- Personal info depending on role ----------------
  Widget _personalInfoForRole() {
    if (isFeddi) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle('Feddi Info'),
        const SizedBox(height: 8),
        const Text('Role: Feddi — maintenance & coordination'),
        const SizedBox(height: 12),
        _sectionTitle('Available materials'),
        const SizedBox(height: 8),
        for (var m in materials) _materialItem(deviceType: m.type, deviceId: m.id?.toString() ?? '', marque: m.modele ?? '', os: m.etat.name),
      ]);
    } else if (isDepartementUser) {
      final deptName = currentUserDepartment;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxDepartment(name: deptName),
        const SizedBox(height: 12),
        _sectionTitle('Materials'),
        const SizedBox(height: 8),
        for (var m in materials) _materialItem(deviceType: m.type, deviceId: m.id?.toString() ?? '', marque: m.modele ?? '', os: m.etat.name),
      ]);
    } else {
      final sampleUserId = _emailToSampleUserId(widget.loggedInEmail);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _personalInfoBoxForEmployee(userId: sampleUserId),
        const SizedBox(height: 12),
        _sectionTitle('Assigned Materials'),
        const SizedBox(height: 8),
        for (var m in materials.where((x) => x.id.toString() == sampleUserId)) 
          _materialItem(deviceType: m.type, deviceId: m.id?.toString() ?? '', marque: m.modele ?? '', os: m.etat.name),
      ]);
    }
  }

  Widget _personalInfoBoxDepartment({required String name}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: profileBoxBg, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Department: $name', style: const TextStyle(fontWeight: FontWeight.w700)), 
        const SizedBox(height: 6), 
        Text('This view lists materials and employees assigned to the department ($name).')
      ]),
    );
  }

  Widget _personalInfoBoxForEmployee({required String userId}) {
    final emp = employees.firstWhere((e) => e.id.toString() == userId, orElse: () => employees.first);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: profileBoxBg, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nom: ${emp.nom}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('Prenom: ${emp.prenom}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Email: ${emp.email}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
          Text('ID: ${emp.id}', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)),
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Device Type: $deviceType', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)), 
          Text('ID: $deviceId', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500))
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Model: $marque', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500)), 
          Text('State: $os', style: const TextStyle(color: textInside, fontSize: 14, fontWeight: FontWeight.w500))
        ]),
      ]),
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