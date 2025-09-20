// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax/iconsax.dart';

// /// --- Bloc Events ---
// abstract class MailEvent {}

// class ChangeTab extends MailEvent {
//   final int index;
//   ChangeTab(this.index);
// }

// /// --- Bloc States ---
// class MailState {
//   final int currentIndex;
//   MailState(this.currentIndex);
// }

// /// --- Bloc Logic ---
// class MailBloc extends Bloc<MailEvent, MailState> {
//   MailBloc() : super(MailState(0)) {
//     on<ChangeTab>((event, emit) => emit(MailState(event.index)));
//   }
// }

// /// --- Email Model ---
// class Email {
//   final String sender;
//   final String subject;
//   final String preview;
//   final String time;
//   final bool isRead;
//   final bool isStarred;
//   final bool hasAttachment;
//   final String? avatarText;
//   final Color? senderColor;

//   Email({
//     required this.sender,
//     required this.subject,
//     required this.preview,
//     required this.time,
//     this.isRead = false,
//     this.isStarred = false,
//     this.hasAttachment = false,
//     this.avatarText,
//     this.senderColor,
//   });
// }

// /// --- Mock Data ---
// final List<Email> inboxEmails = [
//   Email(
//     sender: "Google",
//     subject: "Security alert",
//     preview:
//         "New sign-in on Windows device. We noticed a new sign-in to your Google Account.",
//     time: "10:30 AM",
//     isStarred: true,
//     avatarText: "G",
//     senderColor: Colors.blue,
//   ),
//   Email(
//     sender: "Twitter",
//     subject: "New login to your account",
//     preview: "We noticed a new login to your Twitter account.",
//     time: "9:45 AM",
//     isRead: true,
//     avatarText: "T",
//     senderColor: Colors.lightBlue,
//   ),
//   Email(
//     sender: "Amazon",
//     subject: "Your order has shipped!",
//     preview:
//         "Your recent order is on its way. Your package will be delivered tomorrow.",
//     time: "Yesterday",
//     hasAttachment: true,
//     avatarText: "A",
//     senderColor: Colors.orange,
//   ),
//   Email(
//     sender: "LinkedIn",
//     subject: "You have 5 new notifications",
//     preview: "See who's viewed your profile and more.",
//     time: "Yesterday",
//     isRead: true,
//     avatarText: "L",
//     senderColor: Colors.blue.shade800,
//   ),
//   Email(
//     sender: "Netflix",
//     subject: "New TV shows and movies added",
//     preview: "Check out the latest titles added to Netflix this week.",
//     time: "Jun 12",
//     avatarText: "N",
//     senderColor: Colors.red,
//   ),
//   Email(
//     sender: "GitHub",
//     subject: "Your daily digest",
//     preview: "See what's happening in your repositories.",
//     time: "Jun 11",
//     isRead: true,
//     hasAttachment: true,
//     avatarText: "GH",
//     senderColor: Colors.purple,
//   ),
// ];

// /// --- Custom Colors ---
// class AppColors {
//   static const Color primary = Color(0xFF2D5BFF);
//   static const Color secondary = Color(0xFF8A94A6);
//   static const Color background = Color(0xFFF8FAFD);
//   static const Color card = Color(0xFFFFFFFF);
//   static const Color accent = Color(0xFFFF6B35);
//   static const Color success = Color(0xFF27AE60);
//   static const Color warning = Color(0xFFF2C94C);
//   static const Color error = Color(0xFFEB5757);
// }

// /// --- Custom Theme ---
// final appTheme = ThemeData(
//   colorScheme:
//       ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         brightness: Brightness.light,
//       ).copyWith(
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//         background: AppColors.background,
//       ),
//   useMaterial3: true,
//   fontFamily: 'Inter',
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Colors.white,
//     foregroundColor: Colors.black,
//     elevation: 0,
//     centerTitle: false,
//   ),
//   cardTheme: CardThemeData(
//     elevation: 0,
//     color: Colors.white,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   ),
// );

// /// --- Drawer Content ---

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isSmallScreen = screenHeight < 700;

//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.78, // ⬅️ reduced width
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // Header Section
//           Container(
//             height: isSmallScreen ? 110 : 150,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppColors.primary,
//                   AppColors.primary.withOpacity(0.85),
//                 ],
//               ),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: isSmallScreen ? 14 : 22,
//               ),
//               child: Row(
//                 children: [
//                   // Profile Avatar
//                   Container(
//                     width: isSmallScreen ? 48 : 60,
//                     height: isSmallScreen ? 48 : 60,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                         isSmallScreen ? 24 : 30,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.person,
//                       color: AppColors.primary,
//                       size: isSmallScreen ? 26 : 34,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // User Info
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "John Doe",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: isSmallScreen ? 18 : 22, // ⬅️ bigger font
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: 0.5,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "johndoe@gmail.com",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize: isSmallScreen ? 12 : 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Navigation Items
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.symmetric(
//                 vertical: isSmallScreen ? 8 : 12, // ⬅️ tighter spacing
//                 horizontal: 8,
//               ),
//               children: [
//                 // Primary Mail Categories
//                 _buildSectionTitle("MAIL", context, isSmallScreen),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.inbox_rounded,
//                   title: "Inbox",
//                   count: "5",
//                   isSelected: true,
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.star_rounded,
//                   title: "Starred",
//                   count: "12",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.schedule_rounded,
//                   title: "Snoozed",
//                   count: "3",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.send_rounded,
//                   title: "Sent",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.drafts_rounded,
//                   title: "Drafts",
//                   count: "2",
//                   isSmallScreen: isSmallScreen,
//                 ),

//                 Divider(
//                   color: Colors.grey.shade300,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                 ),

//                 // Secondary Categories
//                 _buildSectionTitle("CATEGORIES", context, isSmallScreen),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.mail_rounded,
//                   title: "All mail",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.warning_rounded,
//                   title: "Spam",
//                   count: "24",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.delete_rounded,
//                   title: "Trash",
//                   isSmallScreen: isSmallScreen,
//                 ),

//                 Divider(
//                   color: Colors.grey.shade300,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                 ),

//                 // Labels Section
//                 _buildSectionTitle("LABELS", context, isSmallScreen),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.label_rounded,
//                   title: "Work",
//                   color: Colors.blue.shade600,
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.label_rounded,
//                   title: "Personal",
//                   color: Colors.green.shade600,
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.label_rounded,
//                   title: "Travel",
//                   color: Colors.orange.shade600,
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.label_rounded,
//                   title: "Finance",
//                   color: Colors.purple.shade600,
//                   isSmallScreen: isSmallScreen,
//                 ),

//                 // Settings Section
//                 _buildSectionTitle("SETTINGS", context, isSmallScreen),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.settings_rounded,
//                   title: "Settings",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.help_rounded,
//                   title: "Help & feedback",
//                   isSmallScreen: isSmallScreen,
//                 ),
//                 _buildDrawerItem(
//                   context,
//                   icon: Icons.exit_to_app_rounded,
//                   title: "Sign out",
//                   isSmallScreen: isSmallScreen,
//                   color: Colors.red.shade600,
//                 ),
//               ],
//             ),
//           ),

//           // Footer with App Version
//           Container(
//             padding: const EdgeInsets.all(12), // ⬅️ smaller padding
//             child: Text(
//               "MailBox v1.0.0",
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(
//     String title,
//     BuildContext context,
//     bool isSmallScreen,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 4,
//       ), // ⬅️ reduced vertical
//       child: Text(
//         title,
//         style: TextStyle(
//           color: AppColors.secondary,
//           fontSize: isSmallScreen ? 10 : 11,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 1.1,
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     String? count,
//     bool isSelected = false,
//     Color? color,
//     required bool isSmallScreen,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? AppColors.primary.withOpacity(0.12)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color:
//               color ?? (isSelected ? AppColors.primary : AppColors.secondary),
//           size: isSmallScreen ? 20 : 22,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? AppColors.primary : Colors.black87,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//             fontSize: isSmallScreen ? 13 : 14,
//           ),
//         ),
//         trailing: count != null
//             ? Text(
//                 count,
//                 style: TextStyle(
//                   color: isSelected ? AppColors.primary : Colors.black54,
//                   fontSize: isSmallScreen ? 11 : 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )
//             : null,
//         onTap: () => Navigator.pop(context),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//         dense: true, // ⬅️ makes items compact
//         visualDensity: const VisualDensity(vertical: -1), // ⬅️ reduces height
//       ),
//     );
//   }
// }

// /// --- Search Bar ---
// class SearchBarWidget extends StatelessWidget {
//   final Function(String) onSearch;
//   final TextEditingController controller;

//   const SearchBarWidget({
//     super.key,
//     required this.onSearch,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           /// Search bar
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: AppColors.secondary,
//                   size: 20,
//                 ),
//                 hintText: "Search messages...",
//                 hintStyle: TextStyle(color: AppColors.secondary),
//                 filled: true,
//                 fillColor: Colors.white, // 👈 changed to white
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide(
//                     color: const Color.fromARGB(
//                       255,
//                       43,
//                       4,
//                       4,
//                     ), // subtle border for visibility
//                     width: 1,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 0,
//                   horizontal: 16,
//                 ),
//               ),
//               onChanged: onSearch, // live search callback
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),

//           /// Filter button
//           IconButton(
//             icon: Icon(Iconsax.filter, color: AppColors.primary, size: 20),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 builder: (context) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.mark_email_unread),
//                         title: const Text("Unread"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           // onFilter?.call("unread");
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Iconsax.star),
//                         title: const Text("Starred"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           // onFilter?.call("starred");
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.attach_file),
//                         title: const Text("With attachments"),
//                         onTap: () {
//                           Navigator.pop(context);
//                           // onFilter?.call("attachments");
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// --- Screens for tabs ---
// class InboxScreen extends StatefulWidget {
//   const InboxScreen({super.key});

//   @override
//   State<InboxScreen> createState() => _InboxScreenState();
// }

// class _InboxScreenState extends State<InboxScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   List<Email> _filteredEmails = inboxEmails;

//   void _onSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//       if (query.isEmpty) {
//         _filteredEmails = inboxEmails;
//       } else {
//         _filteredEmails = inboxEmails.where((email) {
//           return email.sender.toLowerCase().contains(query.toLowerCase()) ||
//               email.subject.toLowerCase().contains(query.toLowerCase()) ||
//               email.preview.toLowerCase().contains(query.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             floating: true,
//             backgroundColor: Colors.white,
//             title: Text(
//               "Mailbox",
//               style: TextStyle(
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 20,
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   Icons.star_border_rounded, // important button
//                   color: AppColors.primary,
//                 ),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text("Showing important messages"),
//                       backgroundColor: AppColors.primary,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           SliverToBoxAdapter(
//             child: SearchBarWidget(
//               onSearch: _onSearch,
//               controller: _searchController,
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 final email = _filteredEmails[index];
//                 return EmailListItem(email: email);
//               }, childCount: _filteredEmails.length),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: AppColors.primary,
//         child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//     );
//   }
// }

// class EmailListItem extends StatelessWidget {
//   final Email email;

//   const EmailListItem({super.key, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: email.isRead ? AppColors.background : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color:
//                 email.senderColor?.withOpacity(0.2) ??
//                 AppColors.primary.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Center(
//             child: Text(
//               email.avatarText ?? email.sender[0].toUpperCase(),
//               style: TextStyle(
//                 color: email.senderColor ?? AppColors.primary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 email.sender,
//                 style: TextStyle(
//                   fontWeight: email.isRead
//                       ? FontWeight.normal
//                       : FontWeight.w600,
//                   color: email.isRead ? AppColors.secondary : Colors.black87,
//                   fontSize: 14,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             if (email.isStarred)
//               Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
//             const SizedBox(width: 8),
//             Text(
//               email.time,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.secondary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 6),
//             Text(
//               email.subject,
//               style: TextStyle(
//                 fontWeight: email.isRead ? FontWeight.normal : FontWeight.w600,
//                 color: email.isRead ? AppColors.secondary : Colors.black87,
//                 fontSize: 14,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     email.preview,
//                     style: TextStyle(fontSize: 13, color: AppColors.secondary),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (email.hasAttachment)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Icon(
//                       Icons.attachment_rounded,
//                       size: 16,
//                       color: AppColors.secondary,
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//         onTap: () {},
//       ),
//     );
//   }
// }

// class AllMailScreen extends StatelessWidget {
//   const AllMailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         title: const Text("All Mail"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search_rounded, color: AppColors.primary),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.mail_outline_rounded,
//               size: 64,
//               color: AppColors.secondary.withOpacity(0.5),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "All Mail",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "All your emails in one place",
//               style: TextStyle(color: AppColors.secondary, fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LabelCategoriesScreen extends StatelessWidget {
//   const LabelCategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(title: const Text("Labels")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildLabelCard(
//               context,
//               "Work",
//               Icons.work_rounded,
//               AppColors.primary,
//             ),
//             _buildLabelCard(
//               context,
//               "Personal",
//               Icons.person_rounded,
//               Colors.green,
//             ),
//             _buildLabelCard(
//               context,
//               "Travel",
//               Icons.flight_rounded,
//               Colors.orange,
//             ),
//             _buildLabelCard(
//               context,
//               "Finance",
//               Icons.attach_money_rounded,
//               Colors.teal,
//             ),
//             _buildLabelCard(
//               context,
//               "Shopping",
//               Icons.shopping_cart_rounded,
//               Colors.purple,
//             ),
//             _buildLabelCard(
//               context,
//               "Social",
//               Icons.people_rounded,
//               Colors.pink,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLabelCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 0,
//       color: color.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {},
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 32, color: color),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.w600, color: color),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "12 emails",
//                 style: TextStyle(color: AppColors.secondary, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(title: const Text("Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               color: AppColors.primary.withOpacity(0.1),
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         borderRadius: BorderRadius.circular(40),
//                         image: const DecorationImage(
//                           image: NetworkImage(
//                             "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1160&q=80",
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "John Doe",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "johndoe@gmail.com",
//                       style: TextStyle(
//                         color: AppColors.secondary,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildProfileStat("2.1K", "Emails"),
//                         _buildProfileStat("12", "Labels"),
//                         _buildProfileStat("24", "Starred"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Column(
//                   children: [
//                     _buildProfileButton(
//                       context,
//                       icon: Icons.person_rounded,
//                       text: "Manage Account",
//                     ),
//                     _buildProfileButton(
//                       context,
//                       icon: Icons.security_rounded,
//                       text: "Security",
//                     ),
//                     _buildProfileButton(
//                       context,
//                       icon: Icons.notifications_rounded,
//                       text: "Notifications",
//                     ),
//                     _buildProfileButton(
//                       context,
//                       icon: Icons.storage_rounded,
//                       text: "Storage",
//                     ),
//                     _buildProfileButton(
//                       context,
//                       icon: Icons.help_rounded,
//                       text: "Help & Feedback",
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

//   Widget _buildProfileStat(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: TextStyle(color: AppColors.secondary, fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildProfileButton(
//     BuildContext context, {
//     required IconData icon,
//     required String text,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: AppColors.primary, size: 22),
//       title: Text(text, style: TextStyle(color: Colors.black87, fontSize: 14)),
//       trailing: Icon(Icons.chevron_right_rounded, color: AppColors.secondary),
//       onTap: () {},
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//     );
//   }
// }

// /// --- Main App ---
// void main() {
//   runApp(BlocProvider(create: (_) => MailBloc(), child: const MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'MailBox',
//       theme: appTheme,
//       home: const MailHome(),
//     );
//   }
// }

// class MailHome extends StatelessWidget {
//   const MailHome({super.key});

//   static final List<Widget> _screens = [
//     const InboxScreen(),
//     const AllMailScreen(),
//     const LabelCategoriesScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MailBloc, MailState>(
//       builder: (context, state) {
//         return Scaffold(
//           body: _screens[state.currentIndex],
//           bottomNavigationBar: _buildBottomNavigationBar(
//             context,
//             state.currentIndex,
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: NavigationBar(
//         selectedIndex: currentIndex,
//         onDestinationSelected: (index) =>
//             context.read<MailBloc>().add(ChangeTab(index)),
//         height: 70,
//         labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//         backgroundColor: Colors.white,
//         indicatorColor: AppColors.primary.withOpacity(0.2),
//         destinations: [
//           NavigationDestination(
//             icon: Icon(Icons.inbox_outlined, color: AppColors.secondary),
//             selectedIcon: Icon(Icons.inbox, color: AppColors.primary),
//             label: "Inbox",
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.mail_outlined, color: AppColors.secondary),
//             selectedIcon: Icon(Icons.mail, color: AppColors.primary),
//             label: "All Mail",
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.label_outlined, color: AppColors.secondary),
//             selectedIcon: Icon(Icons.label, color: AppColors.primary),
//             label: "Labels",
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outlined, color: AppColors.secondary),
//             selectedIcon: Icon(Icons.person, color: AppColors.primary),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail/logic/bloc/mail/mail_bloc.dart';
import 'app.dart';

void main() {
  runApp(BlocProvider(create: (_) => MailBloc(), child: const MyApp()));
}
