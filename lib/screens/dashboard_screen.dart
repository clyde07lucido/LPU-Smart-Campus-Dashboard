
import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';
import '../widgets/dashboard_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int columns = width > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Dashboard"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),

            const SizedBox(height: 20),

            const Text(
              "System Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: const [
                StatusCard(
                  title: "Network",
                  status: "Offline",
                  icon: Icons.wifi,
                ),
                StatusCard(
                  title: "GPS",
                  status: "Inactive",
                  icon: Icons.location_on,
                ),
                StatusCard(
                  title: "API",
                  status: "Not Connected",
                  icon: Icons.cloud,
                ),
                StatusCard(
                  title: "Storage",
                  status: "Available",
                  icon: Icons.storage,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DashboardTile(
                  title: "Device",
                  icon: Icons.phone_android,
                ),
                DashboardTile(
                  title: "API",
                  icon: Icons.cloud,
                ),
                DashboardTile(
                  title: "GPS",
                  icon: Icons.location_on,
                ),
                DashboardTile(
                  title: "Network",
                  icon: Icons.wifi,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text("No Activity Available"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../widgets/profile_card.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   void showStatus(BuildContext context, String title, String status) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text('Current status: $status'),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildKpiCard({
//     required BuildContext context,
//     required String title,
//     required String status,
//     required IconData icon,
//     required Color color,
//     required String description,
//   }) {
//     return Expanded(
//       child: Card(
//         elevation: 6,
//         shadowColor: color.withValues(alpha: 0.3),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(22),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           onTap: () => showStatus(context, title, status),
//           child: Container(
//             height: 165,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   color.withValues(alpha: 0.18),
//                   Theme.of(context).colorScheme.surface,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: 0.15),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Icon(icon, size: 30, color: color),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       status,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: color,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       description,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodySmall
//                             ?.color,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: const Text(
//           'Smart Dashboard',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const ProfileCard(),

//             const SizedBox(height: 28),

//             const Text(
//               'System Overview',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 6),

//             Text(
//               'Tap a card to view its status.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Theme.of(context).textTheme.bodySmall?.color,
//               ),
//             ),

//             const SizedBox(height: 18),

//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildKpiCard(
//                   context: context,
//                   title: 'Network',
//                   status: 'Offline',
//                   icon: Icons.wifi_rounded,
//                   color: Colors.orange,
//                   description: 'Internet connection',
//                 ),
//                 const SizedBox(width: 12),
//                 buildKpiCard(
//                   context: context,
//                   title: 'GPS',
//                   status: 'Inactive',
//                   icon: Icons.location_on_rounded,
//                   color: Colors.blue,
//                   description: 'Location services',
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildKpiCard(
//                   context: context,
//                   title: 'API Status',
//                   status: 'Disconnected',
//                   icon: Icons.cloud_rounded,
//                   color: Colors.purple,
//                   description: 'Server connection',
//                 ),
//                 const SizedBox(width: 12),
//                 buildKpiCard(
//                   context: context,
//                   title: 'Storage',
//                   status: 'Available',
//                   icon: Icons.storage_rounded,
//                   color: Colors.green,
//                   description: 'Device storage',
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.all(18),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.dashboard_customize_rounded,
//                       size: 32,
//                       color: Colors.indigo,
//                     ),
//                     SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Smart Dashboard',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Your device status at a glance.',
//                             style: TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 