// import 'package:flutter/material.dart';

// class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
//   final int tabLength;
//   final List<String> tabTitles;

//   const TopNavigationBar({
//     super.key,
//     required this.tabLength,
//     required this.tabTitles,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabLength,
//       child: AppBar(
//         elevation: 4,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         bottom: TabBar(
//           isScrollable: true,
//           indicator: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: Colors.white.withOpacity(0.2),
//           ),
//           indicatorWeight: 0,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//           tabs: tabTitles.map((title) => Tab(text: title)).toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
// }
