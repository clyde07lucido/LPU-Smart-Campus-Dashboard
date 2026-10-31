import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import '../widgets/dashboard_tile.dart';
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
import 'users_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  // Week 2: one shared API request used by the Home status cards,
  // the Recent Activity card and the Analytics tab.
  late Future<List<dynamic>> usersFuture;

  // Week 3: student data read back from SharedPreferences.
  Map<String, String> savedStudent = {};

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
    loadSaved();
  }

  void reloadData() {
    setState(() {
      usersFuture = getUsers();
    });
  }

  // Week 3 - Exercise 5: retrieve the stored data (also runs after a restart).
  Future<void> loadSaved() async {
    final data = await loadStudent();
    if (mounted) setState(() => savedStudent = data);
  }

  // Opens a page, then refreshes the saved student card when we come back.
  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => loadSaved());
  }

  void showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name is not available yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'About LPU',
            icon: const Icon(Icons.info_outline),
            onPressed: () => openPage(const AboutScreen()),
          ),
          IconButton(
            tooltip: 'Reload API data',
            icon: const Icon(Icons.refresh),
            onPressed: reloadData,
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
          AnalyticsScreen(future: usersFuture, onRetry: reloadData),
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

  // ---------- Left-side drawer (profile + quick links) ----------

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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() => selectedIndex = 0);
            },
          ),
          drawerItem(
            Icons.how_to_reg,
            'Student Registration',
            const RegistrationScreen(),
          ),
          drawerItem(Icons.badge, 'Faculty Directory', const FacultyScreen()),
          drawerItem(Icons.school, 'CCS Programmes', const ProgrammesScreen()),
          drawerItem(
            Icons.cloud_download,
            'User Directory (API)',
            const UsersScreen(),
          ),
          const Divider(),
          drawerItem(Icons.info_outline, 'About LPU', const AboutScreen()),
        ],
      ),
    );
  }

  // ---------- Home page ----------

  Widget buildHomePage() {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;
    final int columns = isTablet ? 4 : 2;

    // Week 3 - Part 1: values are computed from the programmes list.
    final int totalStudents =
        programmes.fold<int>(0, (sum, p) => sum + p.students);

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

    return SingleChildScrollView(
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

          const SectionTitle('Saved Student (Local Storage)'),

          buildSavedStudent(),

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
                crossAxisCount: columns,
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

          const SectionTitle('Campus Services'),

          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DashboardTile(
                title: 'Student Registration',
                icon: Icons.how_to_reg,
                onTap: () => openPage(const RegistrationScreen()),
              ),
              DashboardTile(
                title: 'Academics',
                icon: Icons.school,
                onTap: () => openPage(const ProgrammesScreen()),
              ),
              DashboardTile(
                title: 'Student Services',
                icon: Icons.people,
                onTap: () => showComingSoon('Student Services'),
              ),
              DashboardTile(
                title: 'Announcements',
                icon: Icons.campaign,
                onTap: () => showComingSoon('Announcements'),
              ),
              DashboardTile(
                title: 'Facilities',
                icon: Icons.business,
                onTap: () => showComingSoon('Facilities'),
              ),
              DashboardTile(
                title: 'Faculty Directory',
                icon: Icons.badge,
                onTap: () => openPage(const FacultyScreen()),
              ),
              DashboardTile(
                title: 'User Directory (API)',
                icon: Icons.cloud_download,
                onTap: () => openPage(const UsersScreen()),
              ),
            ],
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
        ],
      ),
    );
  }

  // Welcome banner: profile icon + name on the left, campus logo on the right.
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
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: lpuWhite,
            child: Icon(Icons.person, size: 36, color: lpuRed),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: TextStyle(color: Colors.white70)),
                Text(
                  'Clyde Ivan Lucido',
                  style: TextStyle(
                    color: lpuWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'BSIT - LPU Cavite',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: lpuWhite,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                'assets/images/LPU_CAVITE.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.school, color: lpuRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shows the data that was saved with SharedPreferences.
  Widget buildSavedStudent() {
    if (savedStudent.isEmpty) {
      return Card(
        child: ListTile(
          leading: const IconBadge(Icons.person_add),
          title: const Text('No student saved yet'),
          subtitle: const Text('Tap here to open Student Registration.'),
          onTap: () => openPage(const RegistrationScreen()),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          for (final e in savedStudent.entries)
            ListTile(
              title: Text(
                e.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(e.key),
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
