import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/programme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import '../widgets/icon_badge.dart';
import '../widgets/notification_badge.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';
import '../widgets/world_clock_widget.dart';
import 'about_screen.dart';
import 'analytics_screen.dart';
import 'faculty_screen.dart';
import 'programmes_screen.dart';
import 'registration_screen.dart';
import 'students_screen.dart';
import 'users_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  // Week 2: one shared API request used by the Home status cards,
  // the Recent Activity card and the Analytics tab.
  late Future<List<dynamic>> usersFuture;

  // Week 3: students saved with SharedPreferences (added to the counts).
  List<Map<String, String>> registered = [];
    String deviceName = 'Detecting device...';

  // Model code -> real phone name
  final Map<String, String> deviceNames = {
    'CPH2159': 'OPPO Reno 5',   // replace CPH2159 with YOUR code from the header
  };

  final List<String> pageTitles = [
    'LPU Dashboard',
    'Analytics',
    'Device Information',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    usersFuture = getUsers();
    loadRegistered();
    loadDevice();
  }

    Future<void> loadDevice() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      if (mounted) {
        setState(() => deviceName = deviceNames[info.model] ?? '${info.manufacturer} ${info.model}');
      }
    } catch (_) {
      if (mounted) setState(() => deviceName = 'Unknown device');
    }
  }

  void reloadData() {
    setState(() {
      usersFuture = getUsers();
    });
  }

  // Exercise 5: read the stored data again (also runs after an app restart).
  Future<void> loadRegistered() async {
    final students = await loadStudents();
    if (mounted) setState(() => registered = students);
  }

  // Pull down on the Home page to refresh everything.
  Future<void> refreshAll() async {
    reloadData();
    loadRegistered();
    try {
      await usersFuture;
    } catch (_) {}
  }

  // Opens a page, then refreshes the student counts when we come back.
  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => loadRegistered());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // Top-left: menu button + quick "Register" button (like a login button).
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            IconButton(
              tooltip: 'Register New Student',
              icon: const Icon(Icons.person_add),
              onPressed: () => openPage(const RegistrationScreen()),
            ),
          ],
        ),
        title: Text(pageTitles[selectedIndex]),
        actions: [
          // Exercise 2: About LPU is opened from an AppBar button.
          IconButton(
            tooltip: 'About LPU',
            icon: const Icon(Icons.info_outline),
            onPressed: () => openPage(const AboutScreen()),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: NotificationBadge(count: 8),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHomePage(),
          AnalyticsScreen(
            future: usersFuture,
            onRetry: reloadData,
            registered: registered,
          ),
          buildPlaceholderPage('Device Information', Icons.phone_android),
          buildPlaceholderPage('Settings', Icons.settings),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_android_outlined),
            selectedIcon: Icon(Icons.phone_android),
            label: 'Device',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // ---------- Left-side menu (the only place that opens these pages) ----------

  Widget drawerLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget drawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close the drawer
        openPage(page);
      },
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: lpuRed),
            currentAccountPicture: CircleAvatar(
              backgroundColor: lpuWhite,
              child: Icon(Icons.person, size: 40, color: lpuRed),
            ),
            accountName: Text('Clyde Ivan Lucido'),
            accountEmail: Text('Bachelor of Science in Information Technology'),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              setState(() => selectedIndex = 0);
            },
          ),
          drawerLabel('STUDENTS'),
          drawerItem(
            Icons.how_to_reg,
            'Register New Student',
            const RegistrationScreen(),
          ),
          drawerItem(
            Icons.groups,
            'View Registered Students',
            const StudentsScreen(),
          ),
          drawerLabel('CAMPUS'),
          drawerItem(Icons.badge, 'Faculty Directory', const FacultyScreen()),
          drawerItem(Icons.school, 'CCS Programmes', const ProgrammesScreen()),
          drawerItem(
            Icons.cloud_download,
            'Live User Directory (API)',
            const UsersScreen(),
          ),
          drawerLabel('INFORMATION'),
          drawerItem(Icons.info_outline, 'About LPU', const AboutScreen()),
        ],
      ),
    );
  }

  // ---------- Home page: overview only ----------

  Widget buildHomePage() {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    // Week 3 - Part 1: computed from the programmes list + registered students.
    final int totalStudents =
        programmes.fold<int>(0, (sum, p) => sum + p.totalWith(registered));

    final List<Widget> statCards = [
      StatCard(
        icon: Icons.people,
        value: '$totalStudents',
        label: 'Total Students',
      ),
      StatCard(
        icon: Icons.school,
        value: '${programmes.length}',
        label: 'Active Programs',
      ),
      const StatCard(
        icon: Icons.location_city,
        value: '1st Sem',
        label: 'Current Semester',
      ),
    ];

    return RefreshIndicator(
      onRefresh: refreshAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),

            const SizedBox(height: 16),

            // Exercise 7 - phone: vertical (Column), tablet: horizontal (Row).
            isTablet
                ? Row(children: [for (final c in statCards) Expanded(child: c)])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: statCards,
                  ),

            const SizedBox(height: 20),

            const SectionTitle('System Status'),

            // Week 2: Network and API status now reflect the real API request.
            FutureBuilder<List<dynamic>>(
              future: usersFuture,
              builder: (context, snapshot) {
                final bool loading =
                    snapshot.connectionState == ConnectionState.waiting;
                final bool failed = snapshot.hasError;

                final String networkStatus =
                    loading ? 'Checking...' : (failed ? 'Offline' : 'Online');
                final String apiStatus = loading
                    ? 'Connecting...'
                    : (failed ? 'Not Connected' : 'Connected');
                final Color statusColor = loading
                    ? Colors.orange
                    : (failed ? lpuRed : Colors.green.shade700);

                return GridView.count(
                  crossAxisCount: isTablet ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.3,
                  children: [
                    StatusCard(
                      title: 'Network',
                      status: networkStatus,
                      icon: Icons.wifi,
                      statusColor: statusColor,
                    ),
                    const StatusCard(
                      title: 'GPS',
                      status: 'Inactive',
                      icon: Icons.location_on,
                    ),
                    StatusCard(
                      title: 'API',
                      status: apiStatus,
                      icon: Icons.cloud,
                      statusColor: statusColor,
                    ),
                    StatusCard(
                      title: 'Storage',
                      status: 'Available',
                      icon: Icons.storage,
                      statusColor: Colors.green.shade700,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            const SectionTitle('World Clock'),

            const WorldClockWidget(),

            const SizedBox(height: 20),

            const SectionTitle('Recent Activity'),

            FutureBuilder<List<dynamic>>(
              future: usersFuture,
              builder: (context, snapshot) {
                String message = 'No Activity Available';
                if (snapshot.connectionState == ConnectionState.waiting) {
                  message = 'Fetching data from the API...';
                } else if (snapshot.hasData) {
                  message =
                      'Synced ${snapshot.data!.length} user records from the API';
                } else if (snapshot.hasError) {
                  message = 'Last API request failed';
                }

                return Card(
                  child: ListTile(
                    leading: const IconBadge(Icons.history),
                    title: Text(message),
                  ),
                );
              },
            ),

            Card(
              child: ListTile(
                leading: const IconBadge(Icons.how_to_reg),
                title: Text('${registered.length} student(s) registered on this phone'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Welcome banner: logo on top, then profile, name, course and device.
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [lpuRed, lpuDarkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo at the top center
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: lpuWhite,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/LPU_CAVITE.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.school, size: 36, color: lpuRed),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lyceum of the Philippines University - Cavite',
            textAlign: TextAlign.center,
            style: TextStyle(color: lpuWhite, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.white24, height: 28),

          // Profile icon + welcome + name
          const Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: lpuWhite,
                child: Icon(Icons.person, size: 34, color: lpuRed),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Clyde Ivan Lucido',
                      style: TextStyle(
                        color: lpuWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Course
          const Text(
            'Bachelor of Science in Information Technology - Web and Mobile Development',
            style: TextStyle(color: lpuWhite),
          ),
          const SizedBox(height: 8),

          // Device name (detected automatically)
          Row(
            children: [
              const Icon(Icons.phone_android, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  deviceName,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPlaceholderPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: lpuRed),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('No information available yet.'),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;
  final Color? statusColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.icon,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBadge(icon),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: statusColor,
              fontWeight: statusColor == null ? null : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
