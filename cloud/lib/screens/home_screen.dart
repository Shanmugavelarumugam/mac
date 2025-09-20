import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String searchText = "";
  bool _isSearchActive = false;
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Color palette
  final Color primaryColor = Color(0xFF6C63FF);
  final Color secondaryColor = Color(0xFF4FC3F7);
  final Color backgroundColor = Color(0xFFF8FAFD);
  final Color surfaceColor = Color(0xFFFFFFFF);
  final Color onSurfaceColor = Color(0xFF2D2F41);
  final Color onSurfaceVariantColor = Color(0xFF7B7E8F);
  final Color errorColor = Color(0xFFFF6B6B);
  final Color successColor = Color(0xFF4CAF50);

  // Mock data with more realistic file structure
  final List<Map<String, dynamic>> mockFolders = [
    {
      'name': 'My Drive',
      'items': 245,
      'size': '4.2 GB',
      'color': 0xFF6C63FF,
      'icon': Iconsax.folder,
      'shared': false,
    },
    {
      'name': 'Shared with me',
      'items': 18,
      'size': '892 MB',
      'color': 0xFF4FC3F7,
      'icon': Iconsax.people,
      'shared': true,
    },
    {
      'name': 'Recent',
      'items': 12,
      'size': '156 MB',
      'color': 0xFFFFA726,
      'icon': Iconsax.clock,
      'shared': false,
    },
    {
      'name': 'Photos',
      'items': 1284,
      'size': '12.4 GB',
      'color': 0xFFEF5350,
      'icon': Iconsax.gallery,
      'shared': false,
    },
    {
      'name': 'Documents',
      'items': 87,
      'size': '2.1 GB',
      'color': 0xFFAB47BC,
      'icon': Iconsax.document,
      'shared': true,
    },
    {
      'name': 'Work Projects',
      'items': 42,
      'size': '3.7 GB',
      'color': 0xFF66BB6A,
      'icon': Iconsax.briefcase,
      'shared': true,
    },
  ];

  final List<Map<String, dynamic>> mockFiles = [
    {
      'name': 'Project Proposal 2024.pdf',
      'type': 'pdf',
      'size': '3.2 MB',
      'date': 'Today, 2:30 PM',
      'modified': DateTime.now().subtract(Duration(hours: 2)),
      'starred': true,
      'shared': true,
      'thumbnail': null,
    },
    {
      'name': 'Team Meeting Recording.mp4',
      'type': 'video',
      'size': '156.7 MB',
      'date': 'Yesterday, 4:15 PM',
      'modified': DateTime.now().subtract(Duration(days: 1)),
      'starred': false,
      'shared': false,
      'thumbnail': null,
    },
    {
      'name': 'Budget Analysis Q4.xlsx',
      'type': 'spreadsheet',
      'size': '2.8 MB',
      'date': '3 days ago',
      'modified': DateTime.now().subtract(Duration(days: 3)),
      'starred': false,
      'shared': true,
      'thumbnail': null,
    },
    {
      'name': 'Vacation Photos.zip',
      'type': 'archive',
      'size': '89.4 MB',
      'date': '1 week ago',
      'modified': DateTime.now().subtract(Duration(days: 7)),
      'starred': true,
      'shared': false,
      'thumbnail': null,
    },
    {
      'name': 'Design Mockups.fig',
      'type': 'design',
      'size': '12.1 MB',
      'date': '2 weeks ago',
      'modified': DateTime.now().subtract(Duration(days: 14)),
      'starred': false,
      'shared': false,
      'thumbnail': null,
    },
    {
      'name': 'Annual Report.docx',
      'type': 'document',
      'size': '5.7 MB',
      'date': '3 weeks ago',
      'modified': DateTime.now().subtract(Duration(days: 21)),
      'starred': false,
      'shared': true,
      'thumbnail': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _scrollController.addListener(_onScroll);
    _fabAnimationController.forward();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 &&
        !_headerAnimationController.isCompleted) {
      _headerAnimationController.forward();
    } else if (_scrollController.offset <= 50 &&
        _headerAnimationController.isCompleted) {
      _headerAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.width < 350;
    final isMediumDevice = size.width >= 350 && size.width < 400;
    final isLargeDevice = size.width >= 400;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildMainContent(
        context,
        size,
        isSmallDevice,
        isMediumDevice,
        isLargeDevice,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        isSmallDevice,
        isMediumDevice,
        isLargeDevice,
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Widget _buildMainContent(
    BuildContext context,
    Size size,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final filteredFolders =
        mockFolders
            .where(
              (folder) => folder['name']!.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .toList();

    final filteredFiles =
        mockFiles
            .where(
              (file) => file['name']!.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .toList();

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar(
            innerBoxIsScrolled,
            isSmallDevice,
            isMediumDevice,
            isLargeDevice,
          ),
        ];
      },
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: primaryColor,
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: _buildSearchSection(
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
            ),

            // Quick Actions
            if (!_isSearchActive)
              SliverToBoxAdapter(
                child: _buildQuickActions(
                  isSmallDevice,
                  isMediumDevice,
                  isLargeDevice,
                ),
              ),

            // Storage Info
            if (!_isSearchActive)
              SliverToBoxAdapter(
                child: _buildStorageInfo(
                  isSmallDevice,
                  isMediumDevice,
                  isLargeDevice,
                ),
              ),

            // Folders Section
            if (filteredFolders.isNotEmpty) ...[
              _buildSectionHeader(
                "Folders",
                Iconsax.folder,
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
              _buildFoldersGrid(
                filteredFolders,
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
            ],

            // Files Section
            if (filteredFiles.isNotEmpty) ...[
              _buildSectionHeader(
                "Recent files",
                Iconsax.document,
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
              _buildFilesList(
                filteredFiles,
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
            ],

            // Empty State
            if (filteredFolders.isEmpty && filteredFiles.isEmpty)
              _buildEmptyState(isSmallDevice, isMediumDevice, isLargeDevice),

            // Bottom Padding
            SliverToBoxAdapter(
              child: SizedBox(height: isSmallDevice ? 80 : 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    bool innerBoxIsScrolled,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final double expandedHeight =
        isSmallDevice
            ? 100
            : isMediumDevice
            ? 110
            : 120;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: true,
      pinned: true,
      snap: false,
      elevation: 0,
      surfaceTintColor: surfaceColor,
      backgroundColor: surfaceColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: AnimatedBuilder(
          animation: _headerAnimationController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                isSmallDevice ? 16 : 20,
                40,
                isSmallDevice ? 16 : 20,
                16,
              ),
              child: Row(
                children: [
                  Container(
                    width:
                        isSmallDevice
                            ? 36
                            : isMediumDevice
                            ? 38
                            : 40,
                    height:
                        isSmallDevice
                            ? 36
                            : isMediumDevice
                            ? 38
                            : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Iconsax.cloud,
                      color: Colors.white,
                      size:
                          isSmallDevice
                              ? 18
                              : isMediumDevice
                              ? 20
                              : 22,
                    ),
                  ),
                  SizedBox(width: isSmallDevice ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "My Drive",
                          style: TextStyle(
                            color: onSurfaceColor,
                            fontWeight: FontWeight.w700,
                            fontSize:
                                isSmallDevice
                                    ? 18
                                    : isMediumDevice
                                    ? 20
                                    : 22,
                          ),
                        ),
                        if (!innerBoxIsScrolled)
                          Text(
                            "245 files • 4.2 GB used",
                            style: TextStyle(
                              color: onSurfaceVariantColor,
                              fontSize:
                                  isSmallDevice
                                      ? 12
                                      : isMediumDevice
                                      ? 13
                                      : 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Iconsax.notification,
                      size:
                          isSmallDevice
                              ? 18
                              : isMediumDevice
                              ? 20
                              : 22,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: surfaceColor,
                      foregroundColor: onSurfaceVariantColor,
                      padding: EdgeInsets.all(isSmallDevice ? 8 : 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchSection(
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallDevice ? 16 : 20,
        8,
        isSmallDevice ? 16 : 20,
        16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => searchText = value),
          onTap: () => setState(() => _isSearchActive = true),
          onSubmitted: (value) => setState(() => _isSearchActive = false),
          style: TextStyle(
            color: onSurfaceColor,
            fontSize:
                isSmallDevice
                    ? 14
                    : isMediumDevice
                    ? 15
                    : 16,
          ),
          decoration: InputDecoration(
            hintText: "Search files and folders...",
            hintStyle: TextStyle(
              color: onSurfaceVariantColor,
              fontSize:
                  isSmallDevice
                      ? 14
                      : isMediumDevice
                      ? 15
                      : 16,
            ),
            prefixIcon: Icon(
              Iconsax.search_normal,
              color: onSurfaceVariantColor,
              size:
                  isSmallDevice
                      ? 18
                      : isMediumDevice
                      ? 20
                      : 22,
            ),
            suffixIcon:
                searchText.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        color: onSurfaceVariantColor,
                        size:
                            isSmallDevice
                                ? 16
                                : isMediumDevice
                                ? 18
                                : 20,
                      ),
                      onPressed: () {
                        setState(() {
                          searchText = "";
                          _searchController.clear();
                          _isSearchActive = false;
                        });
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallDevice ? 16 : 20,
              vertical: isSmallDevice ? 14 : 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final actions = [
      {'icon': Iconsax.cloud_plus, 'label': 'Upload', 'color': primaryColor},
      {'icon': Iconsax.scan, 'label': 'Scan', 'color': secondaryColor},
      {
        'icon': Iconsax.folder_add,
        'label': 'Create',
        'color': Color(0xFFFFA726),
      },
      {'icon': Iconsax.image, 'label': 'Photos', 'color': Color(0xFFEF5350)},
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallDevice ? 16 : 20,
        8,
        isSmallDevice ? 16 : 20,
        16,
      ),
      child: Wrap(
        spacing: isSmallDevice ? 12 : 16,
        runSpacing: isSmallDevice ? 12 : 16,
        children:
            actions
                .map(
                  (action) => _buildQuickActionCard(
                    action['label'] as String,
                    action['icon'] as IconData,
                    action['color'] as Color,
                    () {},
                    isSmallDevice,
                    isMediumDevice,
                    isLargeDevice,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final double size =
        isSmallDevice
            ? 72
            : isMediumDevice
            ? 76
            : 80;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: size,
          padding: EdgeInsets.symmetric(vertical: isSmallDevice ? 10 : 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSmallDevice ? 36 : 40,
                height: isSmallDevice ? 36 : 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: isSmallDevice ? 18 : 20),
              ),
              SizedBox(height: isSmallDevice ? 4 : 6),
              Text(
                title,
                style: TextStyle(
                  color: onSurfaceColor,
                  fontSize: isSmallDevice ? 10 : 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorageInfo(
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        isSmallDevice ? 16 : 20,
        0,
        isSmallDevice ? 16 : 20,
        24,
      ),
      padding: EdgeInsets.all(isSmallDevice ? 16 : 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.cloud,
                color: primaryColor,
                size: isSmallDevice ? 18 : 20,
              ),
              SizedBox(width: isSmallDevice ? 8 : 12),
              Expanded(
                child: Text(
                  "Storage",
                  style: TextStyle(
                    fontSize: isSmallDevice ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: onSurfaceColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Upgrade",
                  style: TextStyle(
                    fontSize: isSmallDevice ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallDevice ? 8 : 12,
                    vertical: isSmallDevice ? 4 : 8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallDevice ? 12 : 16),
          LinearProgressIndicator(
            value: 0.28,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(primaryColor),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          SizedBox(height: isSmallDevice ? 8 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "4.2 GB of 15 GB used",
                style: TextStyle(
                  color: onSurfaceVariantColor,
                  fontSize: isSmallDevice ? 12 : 14,
                ),
              ),
              Text(
                "28%",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: isSmallDevice ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        isSmallDevice ? 16 : 20,
        16,
        isSmallDevice ? 16 : 20,
        12,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: isSmallDevice ? 16 : 18),
            SizedBox(width: isSmallDevice ? 6 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallDevice ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: onSurfaceColor,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                "View all",
                style: TextStyle(
                  fontSize: isSmallDevice ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoldersGrid(
    List<Map<String, dynamic>> folders,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final crossAxisCount =
        isLargeDevice
            ? 3
            : isMediumDevice
            ? 2
            : 2;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 16 : 20),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isSmallDevice ? 12 : 16,
          mainAxisSpacing: isSmallDevice ? 12 : 16,
          childAspectRatio: 0.85, // taller and bigger
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final folder = folders[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: crossAxisCount,
            duration: Duration(milliseconds: 400),
            child: ScaleAnimation(
              scale: 0.9,
              child: FadeInAnimation(
                child: _buildModernFolderCard(
                  folder,
                  isSmallDevice,
                  isMediumDevice,
                  isLargeDevice,
                ),
              ),
            ),
          );
        }, childCount: folders.length),
      ),
    );
  }

  Widget _buildModernFolderCard(
    Map<String, dynamic> folder,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final color = Color(folder['color']);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: isSmallDevice ? 36 : 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Icon(
                    folder['icon'],
                    color: Colors.white,
                    size: isSmallDevice ? 18 : 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmallDevice ? 10 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      folder['name'],
                      style: TextStyle(
                        fontSize: isSmallDevice ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: onSurfaceColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${folder['items']} items",
                      style: TextStyle(
                        color: onSurfaceVariantColor,
                        fontSize: isSmallDevice ? 10 : 11,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      folder['size'],
                      style: TextStyle(
                        color: onSurfaceVariantColor,
                        fontSize: isSmallDevice ? 9 : 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilesList(
    List<Map<String, dynamic>> files,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 16 : 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final file = files[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 20,
              child: FadeInAnimation(
                child: _buildModernFileCard(
                  file,
                  index == files.length - 1,
                  isSmallDevice,
                  isMediumDevice,
                  isLargeDevice,
                ),
              ),
            ),
          );
        }, childCount: files.length),
      ),
    );
  }

  Widget _buildModernFileCard(
    Map<String, dynamic> file,
    bool isLast,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildFileIcon(
                  file['type'],
                  isSmallDevice,
                  isMediumDevice,
                  isLargeDevice,
                ),
                SizedBox(width: isSmallDevice ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['name'],
                        style: TextStyle(
                          fontSize: isSmallDevice ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: onSurfaceColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            file['size'],
                            style: TextStyle(
                              color: onSurfaceVariantColor,
                              fontSize: isSmallDevice ? 11 : 12,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: onSurfaceVariantColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            file['date'],
                            style: TextStyle(
                              color: onSurfaceVariantColor,
                              fontSize: isSmallDevice ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (file['shared'])
                      Icon(
                        Iconsax.profile_2user,
                        size: isSmallDevice ? 16 : 18,
                        color: primaryColor,
                      ),
                    SizedBox(width: isSmallDevice ? 6 : 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          file['starred'] = !file['starred'];
                        });
                      },
                      icon: Icon(
                        file['starred'] ? Iconsax.star1 : Iconsax.star,
                        color:
                            file['starred']
                                ? Colors.amber
                                : onSurfaceVariantColor,
                        size: isSmallDevice ? 18 : 20,
                      ),
                      constraints: BoxConstraints(
                        minWidth: isSmallDevice ? 32 : 36,
                        minHeight: isSmallDevice ? 32 : 36,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(
    String type,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    IconData icon;
    Color color;

    switch (type) {
      case 'pdf':
        icon = Iconsax.document_text;
        color = errorColor;
        break;
      case 'video':
        icon = Iconsax.video;
        color = secondaryColor;
        break;
      case 'spreadsheet':
        icon = Iconsax.document_download;
        color = successColor;
        break;
      case 'archive':
        icon = Iconsax.archive;
        color = Color(0xFFFFA726);
        break;
      case 'design':
        icon = Iconsax.designtools;
        color = primaryColor;
        break;
      case 'document':
        icon = Iconsax.document;
        color = onSurfaceVariantColor;
        break;
      default:
        icon = Iconsax.document;
        color = primaryColor;
    }

    return Container(
      width: isSmallDevice ? 44 : 48,
      height: isSmallDevice ? 44 : 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: isSmallDevice ? 20 : 24),
    );
  }

  Widget _buildEmptyState(
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSmallDevice ? 100 : 120,
            height: isSmallDevice ? 100 : 120,
            decoration: BoxDecoration(
              color: surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Iconsax.search_status,
              size: isSmallDevice ? 40 : 48,
              color: onSurfaceVariantColor,
            ),
          ),
          SizedBox(height: isSmallDevice ? 16 : 24),
          Text(
            "No results found",
            style: TextStyle(
              fontSize: isSmallDevice ? 18 : 22,
              fontWeight: FontWeight.w600,
              color: onSurfaceColor,
            ),
          ),
          SizedBox(height: isSmallDevice ? 8 : 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 24 : 40),
            child: Text(
              "Try different search terms or check your spelling",
              style: TextStyle(
                color: onSurfaceVariantColor,
                fontSize: isSmallDevice ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        child: Icon(Iconsax.add, size: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: isSmallDevice ? 70 : 80,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallDevice ? 12 : 20,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                0,
                Iconsax.home,
                "Home",
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
              _buildNavItem(
                1,
                Iconsax.star,
                "Starred",
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
              _buildNavItem(
                2,
                Iconsax.cloud_plus,
                "Upload",
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
              _buildNavItem(
                3,
                Iconsax.profile_circle,
                "Account",
                isSmallDevice,
                isMediumDevice,
                isLargeDevice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    bool isSmallDevice,
    bool isMediumDevice,
    bool isLargeDevice,
  ) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSmallDevice ? 5 : 6),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? primaryColor.withOpacity(0.12)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? primaryColor : onSurfaceVariantColor,
                    size: isSmallDevice ? 20 : 22,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallDevice ? 9 : 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? primaryColor : onSurfaceVariantColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
