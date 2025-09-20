// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:web_app/data/repository/search_repository.dart';
// import 'package:web_app/logic/bloc/search/search_bloc.dart';
// import 'package:web_app/logic/bloc/search/search_event.dart';
// import 'package:web_app/logic/bloc/search/search_state.dart';
// import 'package:web_app/presentation/screens/in_app_browser.dart';
// import 'package:web_app/presentation/screens/search_results_page.dart';
// import '../widgets/quick_action.dart';
// import '../widgets/info_card.dart';
// import '../widgets/account_menu.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SearchHomePage extends StatefulWidget {
//   const SearchHomePage({super.key});

//   @override
//   State<SearchHomePage> createState() => _SearchHomePageState();
// }

// class _SearchHomePageState extends State<SearchHomePage>
//     with TickerProviderStateMixin {
//   final TextEditingController controller = TextEditingController();
//   late AnimationController _animationController;
//   late AnimationController _staggerController;

//   // Search bar animations
//   late Animation<double> _logoAnimation;
//   late Animation<Offset> _searchBarAnimation;
//   late Animation<double> _searchBarScaleAnimation;

//   // Content animations
//   late Animation<double> _contentFadeAnimation;
//   late Animation<Offset> _contentSlideAnimation;
//   late Animation<double> _appBarAnimation;

//   // Stagger animations for cards
//   late Animation<double> _quickActionsAnimation;
//   late Animation<double> _weatherCardAnimation;
//   late Animation<double> _newsCardAnimation;

//   FocusNode _searchFocusNode = FocusNode();
//   bool _isSearchFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _setupFocusListener();
//     _startStaggerAnimation();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _staggerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     // Search focus animations
//     _logoAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
//       ),
//     );

//     _searchBarAnimation =
//         Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.4)).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
//           ),
//         );

//     _searchBarScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
//       ),
//     );

//     _contentFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
//       ),
//     );

//     _contentSlideAnimation =
//         Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.3)).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
//           ),
//         );

//     _appBarAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
//       ),
//     );

//     // Stagger animations for initial load
//     _quickActionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _staggerController,
//         curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
//       ),
//     );

//     _weatherCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _staggerController,
//         curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack),
//       ),
//     );

//     _newsCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _staggerController,
//         curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
//       ),
//     );
//   }

//   void _setupFocusListener() {
//     _searchFocusNode.addListener(() {
//       if (_searchFocusNode.hasFocus && !_isSearchFocused) {
//         _isSearchFocused = true;
//         _animationController.forward();
//       } else if (!_searchFocusNode.hasFocus && _isSearchFocused) {
//         _isSearchFocused = false;
//         _animationController.reverse();
//       }
//     });
//   }

//   void _startStaggerAnimation() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _staggerController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _staggerController.dispose();
//     _searchFocusNode.dispose();
//     controller.dispose();
//     super.dispose();
//   }

//   void _handleSearch(String value) {
//     if (value.isEmpty) return;

//     final urlPattern = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w]{2,}(\/\S*)?$');
//     final isUrl = urlPattern.hasMatch(value);

//     if (isUrl) {
//       final formattedUrl = value.startsWith("http") ? value : "https://$value";
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => InAppBrowserPage(url: formattedUrl)),
//       );
//     } else {
//       final repository = RepositoryProvider.of<SearchRepository>(context);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               SearchResultsPage(query: value, repository: repository),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       extendBody: true,
//       backgroundColor: isDark
//           ? const Color(0xFF0A0A0A)
//           : const Color(0xFFFAFBFC),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(isDark),
//           SliverToBoxAdapter(child: _buildBody(size, isDark)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSliverAppBar(bool isDark) {
//     return SliverAppBar(
//       expandedHeight: 0,
//       floating: true,
//       pinned: false,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       flexibleSpace: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Opacity(
//             opacity: _appBarAnimation.value,
//             child: Transform.translate(
//               offset: Offset(0, -20 * (1 - _appBarAnimation.value)),
//               child: _buildAppBarContent(isDark),
//             ),
//           );
//         },
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(4),
//         child: BlocBuilder<SearchBloc, SearchState>(
//           builder: (context, state) {
//             if (state is SearchLoading) {
//               return AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _appBarAnimation.value,
//                     child: Container(
//                       height: 2,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.shade400,
//                             Colors.purple.shade400,
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBarContent(bool isDark) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _buildNotificationButton(isDark),
//           const SizedBox(width: 12),
//           _buildProfileButton(isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationButton(bool isDark) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(
//           Icons.notifications_outlined,
//           color: isDark ? Colors.white70 : Colors.grey[600],
//           size: 22,
//         ),
//         onPressed: () {},
//       ),
//     );
//   }

//   Widget _buildProfileButton(bool isDark) {
//     return GestureDetector(
//       onTap: () => showAccountMenu(context, isDark),
//       child: Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade400, Colors.purple.shade400],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.3),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const CircleAvatar(
//           backgroundColor: Colors.transparent,
//           radius: 18,
//           child: Text(
//             "H",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(Size size, bool isDark) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: size.width * 0.05,
//         vertical: 20,
//       ),
//       child: Column(
//         children: [
//           _buildLogo(size, isDark),
//           _buildSearchBar(size, isDark),
//           SizedBox(height: size.height * 0.03),
//           _buildContent(size, isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildLogo(Size size, bool isDark) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, -30 * _logoAnimation.value),
//           child: Opacity(
//             opacity: _logoAnimation.value,
//             child: Transform.scale(
//               scale: 1.0 - (0.15 * (1 - _logoAnimation.value)),
//               child: Container(
//                 height: size.width * 0.25,
//                 child: ShaderMask(
//                   shaderCallback: (bounds) => LinearGradient(
//                     colors: [
//                       Colors.blue.shade400,
//                       Colors.purple.shade400,
//                       Colors.pink.shade300,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ).createShader(bounds),
//                   child: const Text(
//                     "BTC",
//                     style: TextStyle(
//                       fontSize: 80,
//                       fontWeight: FontWeight.w900,
//                       color: Colors.white,
//                       letterSpacing: -2,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchBar(Size size, bool isDark) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return SlideTransition(
//           position: _searchBarAnimation,
//           child: ScaleTransition(
//             scale: _searchBarScaleAnimation,
//             child: Container(
//               width: double.infinity,
//               constraints: BoxConstraints(
//                 maxWidth: size.width > 800 ? 800 : double.infinity,
//               ),
//               decoration: BoxDecoration(
//                 color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
//                 borderRadius: BorderRadius.circular(
//                   32,
//                 ), // Increased border radius
//                 border: Border.all(
//                   color: isDark
//                       ? const Color(0xFF2C2C2E)
//                       : Colors
//                             .grey
//                             .shade300, // Slightly darker border for light mode
//                   width: 1.5, // Slightly thicker border
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
//                     blurRadius: 32, // Increased blur
//                     spreadRadius: 1, // Added spread
//                     offset: const Offset(0, 12), // Increased offset
//                   ),
//                   if (!isDark)
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.9),
//                       blurRadius: 2,
//                       offset: const Offset(0, -2), // Increased offset
//                     ),
//                 ],
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ), // Added vertical padding
//               child: Row(
//                 children: [
//                   const SizedBox(width: 24), // Increased spacing
//                   Icon(
//                     Icons.search_rounded,
//                     color: Colors.grey[500],
//                     size: 28,
//                   ), // Larger icon
//                   const SizedBox(width: 20), // Increased spacing
//                   Expanded(
//                     child: Container(
//                       height: 72, // Fixed height for the text field area
//                       alignment: Alignment.centerLeft,
//                       child: TextField(
//                         controller: controller,
//                         focusNode: _searchFocusNode,
//                         onSubmitted: _handleSearch,
//                         decoration: InputDecoration(
//                           hintText:
//                               "Search the web...", // More descriptive hint
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(
//                             color: Colors.grey[500],
//                             fontSize: 18, // Larger font size
//                             fontWeight: FontWeight.w400,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             vertical: 20, // Increased padding
//                           ),
//                         ),
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 18, // Larger font size
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   _buildSearchButton(
//                     Icons.mic_rounded,
//                     Colors.blueAccent,
//                     28,
//                   ), // Larger icon
//                   const SizedBox(width: 12), // Increased spacing
//                   _buildSearchButton(
//                     Icons.camera_alt_rounded,
//                     Colors.greenAccent,
//                     28,
//                   ), // Larger icon
//                   const SizedBox(width: 20), // Increased spacing
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchButton(IconData icon, Color color, double size) {
//     return Container(
//       width: 48, // Larger tap target
//       height: 48,
//       child: IconButton(
//         icon: Icon(icon, color: color, size: size),
//         onPressed: () => _handleSearch(controller.text),
//         splashRadius: 24, // Larger splash radius
//         padding: EdgeInsets.zero, // Remove default padding
//       ),
//     );
//   }

//   Widget _buildContent(Size size, bool isDark) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return SlideTransition(
//           position: _contentSlideAnimation,
//           child: FadeTransition(
//             opacity: _contentFadeAnimation,
//             child: Column(
//               children: [
//                 _buildQuickActions(size, isDark),
//                 SizedBox(height: size.height * 0.04),
//                 _buildInfoCards(size, isDark),
//                 SizedBox(height: size.height * 0.1),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuickActions(Size size, bool isDark) {
//     return AnimatedBuilder(
//       animation: _quickActionsAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _quickActionsAnimation.value,
//           child: Opacity(
//             opacity: _quickActionsAnimation.value,
//             child: Container(
//               width: double.infinity,
//               constraints: BoxConstraints(
//                 maxWidth: size.width > 600 ? 600 : double.infinity,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: _buildQuickActionCard(
//                       Icons.school_rounded,
//                       "Education",
//                       Colors.blueAccent,
//                       isDark,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: _buildQuickActionCard(
//                       Icons.movie_rounded,
//                       "Entertainment",
//                       Colors.purpleAccent,
//                       isDark,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: _buildQuickActionCard(
//                       Icons.account_balance_wallet_rounded,
//                       "Finance",
//                       Colors.greenAccent,
//                       isDark,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuickActionCard(
//     IconData icon,
//     String label,
//     Color color,
//     bool isDark,
//   ) {
//     return GestureDetector(
//       onTap: () => buildQuickAction(icon, label, context),
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(isDark ? 0.7 : 1.0),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: Colors.white, size: 26),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCards(Size size, bool isDark) {
//     return Container(
//       width: double.infinity,
//       constraints: BoxConstraints(
//         maxWidth: size.width > 600 ? 600 : double.infinity,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
//             child: Text(
//               "Today",
//               style: TextStyle(
//                 color: isDark ? Colors.white70 : Colors.black54,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 90, // Increased from 120 to accommodate larger card
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 const SizedBox(width: 8),
//                 _buildWeatherCard(isDark),
//                 const SizedBox(width: 12),
//                 _buildAirQualityCard(isDark),
//                 const SizedBox(width: 12),
//                 _buildSunsetCard(isDark),
//                 const SizedBox(width: 12),
//                 _buildGoldPriceCard(isDark),
//                 const SizedBox(width: 8),
//                 _buildFinanceCard(isDark),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildNewsCard(isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeatherCard(bool isDark) {
//     return AnimatedBuilder(
//       animation: _weatherCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - _weatherCardAnimation.value)),
//           child: Opacity(
//             opacity: _weatherCardAnimation.value,
//             child: Container(
//               width: 160,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDark
//                       ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//                       : [Colors.white, const Color(0xFFF5F5F7)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First row: City name
//                   Text(
//                     "Chennai",
//                     style: TextStyle(
//                       color: isDark ? Colors.white : Colors.black87,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                   const SizedBox(height: 6),

//                   // Second row: Temperature + icon + 65% + cloud icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Temperature
//                       Text(
//                         "85°",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       const SizedBox(width: 4),

//                       // Cloud/Rainy icon
//                       Icon(
//                         Icons.cloud_rounded,
//                         color: isDark
//                             ? Colors.blue.shade200
//                             : Colors.blue.shade600,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 4),

//                       // Percentage
//                       Text(
//                         "65%",
//                         style: TextStyle(
//                           color: isDark ? Colors.white70 : Colors.black54,
//                           fontSize: 14,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       const SizedBox(width: 4),

//                       // End cloud icon
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAirQualityCard(bool isDark) {
//     return AnimatedBuilder(
//       animation: _weatherCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - _weatherCardAnimation.value)),
//           child: Opacity(
//             opacity: _weatherCardAnimation.value,
//             child: Container(
//               width: 180,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDark
//                       ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//                       : [Colors.white, const Color(0xFFF5F5F7)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First row: "Air Quality" + Value "59"
//                   Row(
//                     children: [
//                       Text(
//                         "Air Quality",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "59",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   // Second row: Status + End air icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Satisfactory",
//                         style: TextStyle(
//                           color: isDark ? Colors.white70 : Colors.black54,
//                           fontSize: 16,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       Icon(
//                         Icons.air_rounded,
//                         color: isDark
//                             ? Colors.green.shade400
//                             : Colors.green.shade600,
//                         size: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSunsetCard(bool isDark) {
//     return AnimatedBuilder(
//       animation: _weatherCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - _weatherCardAnimation.value)),
//           child: Opacity(
//             opacity: _weatherCardAnimation.value,
//             child: Container(
//               width: 160, // matching weather card width
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDark
//                       ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//                       : [Colors.white, const Color(0xFFF5F5F7)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First row: "Sunset Today"
//                   Text(
//                     "Sunset Today",
//                     style: TextStyle(
//                       color: isDark ? Colors.white : Colors.black87,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Second row: Time + end icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "6:08 PM",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       Icon(
//                         Icons.nightlight_round,
//                         color: isDark
//                             ? Colors.orange.shade300
//                             : Colors.orange.shade400,
//                         size: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildGoldPriceCard(bool isDark) {
//     return AnimatedBuilder(
//       animation: _weatherCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - _weatherCardAnimation.value)),
//           child: Opacity(
//             opacity: _weatherCardAnimation.value,
//             child: Container(
//               width: 160, // same width as other cards
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDark
//                       ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//                       : [Colors.white, const Color(0xFFF5F5F7)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First row: GOLD +0.20%
//                   Row(
//                     children: [
//                       Text(
//                         "GOLD",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "+0.20%",
//                         style: TextStyle(
//                           color: Colors.green.shade400,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   // Second row: Rupee + price + end arrow
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.currency_rupee,
//                             size: 20,
//                             color: isDark ? Colors.white : Colors.black87,
//                           ),
//                           Text(
//                             "113,540",
//                             style: TextStyle(
//                               color: isDark ? Colors.white : Colors.black87,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w700,
//                               fontFamily: 'Roboto',
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         Icons.arrow_upward_rounded,
//                         color: Colors.green.shade400,
//                         size: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFinanceCard(bool isDark) {
//     return AnimatedBuilder(
//       animation: _weatherCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 20 * (1 - _weatherCardAnimation.value)),
//           child: Opacity(
//             opacity: _weatherCardAnimation.value,
//             child: Container(
//               width: 200, // Increased from 160 to 200
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: isDark
//                       ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
//                       : [Colors.white, const Color(0xFFF5F5F7)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.4)
//                         : Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // First row: BSE SENSEX -0.59%
//                   Row(
//                     children: [
//                       Text(
//                         "BSE SENSEX",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "-0.59%",
//                         style: TextStyle(
//                           color: Colors.red.shade400,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),

//                   // Second row: Value + end down arrow
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "82,526.16",
//                         style: TextStyle(
//                           color: isDark ? Colors.white : Colors.black87,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_downward_rounded,
//                         color: Colors.red.shade400,
//                         size: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNewsCard(bool isDark) {
//     final List<NewsItem> newsItems = [
//       NewsItem(
//         title: "Tech Breakthrough in AI Development",
//         description:
//             "New advancements in AI promise to revolutionize multiple industries.",
//         fullContent:
//             "Recent breakthroughs in artificial intelligence are set to transform industries ranging from healthcare to finance. Leading tech companies have announced new models with unprecedented capabilities in natural language processing and computer vision.",
//         imageUrl:
//             "https://images.unsplash.com/photo-1516321318423-ffd4db76e2e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
//         source: "Tech News Daily",
//         timeAgo: "2 hours ago",
//       ),
//       NewsItem(
//         title: "Championship Finals Recap",
//         description:
//             "A thrilling conclusion to the season with unexpected results.",
//         fullContent:
//             "The championship finals concluded with a dramatic finish, as underdog teams outperformed expectations. Key highlights include standout performances and critical moments that defined the season's outcome.",
//         imageUrl:
//             "https://images.unsplash.com/photo-1516321318423-ffd4db76e2e6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
//         source: "Sports Weekly",
//         timeAgo: "5 hours ago",
//       ),
//       NewsItem(
//         title: "Market Trends Show Positive Growth",
//         description:
//             "Stock markets rally as investor confidence grows in tech sector.",
//         fullContent:
//             "Global stock markets have shown positive growth, driven by strong performances in the technology sector. Analysts attribute this to increased investor confidence and favorable economic policies boosting market sentiment.",
//         imageUrl:
//             "https://images.unsplash.com/photo-1590283603385-17ffb3a7ab73?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
//         source: "Finance Times",
//         timeAgo: "1 day ago",
//       ),
//     ];

//     return AnimatedBuilder(
//       animation: _newsCardAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - _newsCardAnimation.value)),
//           child: Opacity(
//             opacity: _newsCardAnimation.value,
//             child: Container(
//               width: double.infinity,
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width > 600
//                     ? 600
//                     : double.infinity,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 0.0,
//                     ), // 👈 outer padding for card

//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Top Stories',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white : Colors.grey[800],
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             'See All',
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               color: Colors.blue.shade400,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics:
//                         const NeverScrollableScrollPhysics(), // Disable inner scrolling to use parent CustomScrollView
//                     itemCount: newsItems.length,
//                     itemBuilder: (context, index) {
//                       final news = newsItems[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16.0),
//                         child: _buildNewsItemCard(context, news, isDark),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNewsItemCard(BuildContext context, NewsItem news, bool isDark) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
//       child: InkWell(
//         onTap: () => showNewsDetail(context, news),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: news.imageUrl,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Container(
//                       height: 200,
//                       color: isDark ? Colors.grey[800] : Colors.grey[200],
//                       child: const Center(child: CircularProgressIndicator()),
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       height: 200,
//                       color: isDark ? Colors.grey[800] : Colors.grey[200],
//                       child: const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 8, // Reduced from 10 to 8 for a tighter look
//                   left: 10,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           news.source,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Container(
//                           width: 3,
//                           height: 3,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           news.timeAgo,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 16,
//                 8,
//                 16,
//                 16,
//               ), // Reduced top padding from 16 to 8
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     news.title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? Colors.white : Colors.grey[800],
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4), // Reduced from 8 to 4
//                   Text(
//                     news.description,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: isDark ? Colors.white70 : Colors.grey[600],
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8), // Reduced from 12 to 8
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton.icon(
//                         icon: Icon(
//                           Icons.bookmark_border,
//                           size: 18,
//                           color: isDark ? Colors.white70 : Colors.grey[600],
//                         ),
//                         label: Text(
//                           'Save',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         onPressed: () {},
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: const Size(50, 30),
//                         ),
//                       ),
//                       TextButton.icon(
//                         icon: Icon(
//                           Icons.share,
//                           size: 18,
//                           color: isDark ? Colors.white70 : Colors.grey[600],
//                         ),
//                         label: Text(
//                           'Share',
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             color: isDark ? Colors.white70 : Colors.grey[600],
//                           ),
//                         ),
//                         onPressed: () {},
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: const Size(50, 30),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showNewsDetail(BuildContext context, NewsItem news) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: CachedNetworkImage(
//                     imageUrl: news.imageUrl,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Container(
//                       height: 200,
//                       color: Colors.grey[200],
//                       child: const Center(child: CircularProgressIndicator()),
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       height: 200,
//                       color: Colors.grey[200],
//                       child: const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Text(
//                       news.source,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       width: 4,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       news.timeAgo,
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   news.title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   news.fullContent,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     color: Colors.grey[700],
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       final Uri url = Uri.parse(
//                         'https://example.com/news/${news.title.toLowerCase().replaceAll(' ', '-')}/',
//                       );
//                       if (await canLaunchUrl(url)) {
//                         await launchUrl(
//                           url,
//                           mode: LaunchMode.externalApplication,
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue.shade400,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'Read Full Article',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NewsItem {
//   final String title;
//   final String description;
//   final String fullContent;
//   final String imageUrl;
//   final String source;
//   final String timeAgo;

//   NewsItem({
//     required this.title,
//     required this.description,
//     required this.fullContent,
//     required this.imageUrl,
//     required this.source,
//     required this.timeAgo,
//   });
// }
