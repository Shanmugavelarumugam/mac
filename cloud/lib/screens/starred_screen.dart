import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({super.key});

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  bool _isGridView = false;
  String _sortBy = 'name'; // name, date, size, type

  // Mock starred files data
  List<Map<String, dynamic>> starredFiles = [
    {
      'name': 'Project Proposal 2024.pdf',
      'type': 'pdf',
      'size': '3.2 MB',
      'date': 'Today, 2:30 PM',
      'modified': DateTime.now().subtract(const Duration(hours: 2)),
      'starred': true,
      'shared': true,
      'color': Colors.red,
      'icon': Icons.picture_as_pdf,
    },
    {
      'name': 'Team Photos Vacation.zip',
      'type': 'archive',
      'size': '89.4 MB',
      'date': '1 week ago',
      'modified': DateTime.now().subtract(const Duration(days: 7)),
      'starred': true,
      'shared': false,
      'color': Colors.orange,
      'icon': Icons.folder_zip,
    },
    {
      'name': 'Budget Analysis Q4.xlsx',
      'type': 'spreadsheet',
      'size': '2.8 MB',
      'date': '3 days ago',
      'modified': DateTime.now().subtract(const Duration(days: 3)),
      'starred': true,
      'shared': true,
      'color': Colors.green,
      'icon': Icons.table_chart,
    },
    {
      'name': 'Design System.fig',
      'type': 'design',
      'size': '12.1 MB',
      'date': '2 weeks ago',
      'modified': DateTime.now().subtract(const Duration(days: 14)),
      'starred': true,
      'shared': false,
      'color': Colors.blue,
      'icon': Icons.design_services,
    },
    {
      'name': 'Presentation Deck.pptx',
      'type': 'presentation',
      'size': '4.7 MB',
      'date': '4 days ago',
      'modified': DateTime.now().subtract(const Duration(days: 4)),
      'starred': true,
      'shared': true,
      'color': Colors.deepOrange,
      'icon': Icons.slideshow,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _sortFiles() {
    setState(() {
      switch (_sortBy) {
        case 'name':
          starredFiles.sort((a, b) => a['name'].compareTo(b['name']));
          break;
        case 'date':
          starredFiles.sort((a, b) => b['modified'].compareTo(a['modified']));
          break;
        case 'size':
          starredFiles.sort(
            (a, b) => _parseSize(b['size']).compareTo(_parseSize(a['size'])),
          );
          break;
        case 'type':
          starredFiles.sort((a, b) => a['type'].compareTo(b['type']));
          break;
      }
    });
  }

  double _parseSize(String size) {
    final parts = size.split(' ');
    final number = double.tryParse(parts[0]) ?? 0;
    final unit = parts[1].toLowerCase();
    switch (unit) {
      case 'gb':
        return number * 1024;
      case 'mb':
        return number;
      case 'kb':
        return number / 1024;
      default:
        return number;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    final isSmallPhone = size.width < 350;

    return Scaffold(
      
      backgroundColor: colorScheme.surface,
      body:
          starredFiles.isEmpty
              ? _buildEmptyState(colorScheme, size)
              : _buildStarredContent(
                theme,
                colorScheme,
                isTablet,
                isSmallPhone,
                size,
              ),
      floatingActionButton:
          starredFiles.isNotEmpty
              ? _buildFloatingActionButton(colorScheme)
              : null,
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, Size size) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(colorScheme, true),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallPhone(size.width) ? 16 : 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.1),
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.2),
                            Colors.orange.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(size.width * 0.2),
                      ),
                      child: Icon(
                        Icons.star_outline_rounded,
                        size: size.width * 0.2,
                        color: Colors.amber.shade400,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  SlideAnimation(
                    verticalOffset: 30,
                    duration: const Duration(milliseconds: 600),
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "No starred files yet",
                       
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideAnimation(
                    verticalOffset: 20,
                    duration: const Duration(milliseconds: 600),
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallPhone(size.width) ? 8 : 24,
                        ),
                        child: Text(
                          "Star your important files and folders to find them quickly. Just tap the ⭐ icon next to any file.",
                         
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  SlideAnimation(
                    verticalOffset: 20,
                    duration: const Duration(milliseconds: 600),
                    child: FadeInAnimation(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 600),
                      child: _buildActionButtons(
                        colorScheme,
                        isSmallPhone(size.width),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isSmallPhone(double width) => width < 350;

  Widget _buildActionButtons(ColorScheme colorScheme, bool isSmallPhone) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.explore_outlined, size: 20),
          label: const Text("Browse Files"),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallPhone ? 24 : 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            // Add some demo starred files
            setState(() {
              // This would normally come from your app state
            });
          },
          icon: const Icon(Icons.star_outline, size: 20),
          label: const Text("Learn About Starring"),
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.primary),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallPhone ? 24 : 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarredContent(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
    bool isSmallPhone,
    Size size,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(colorScheme, false),
          _buildToolbar(colorScheme, isSmallPhone),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() {
                  _sortFiles();
                });
              },
              color: colorScheme.primary,
              child:
                  _isGridView
                      ? _buildGridView(colorScheme, isTablet, isSmallPhone)
                      : _buildListView(colorScheme, isSmallPhone),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme, bool isEmpty) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmallPhone(MediaQuery.of(context).size.width) ? 16 : 20,
        16,
        isSmallPhone(MediaQuery.of(context).size.width) ? 16 : 20,
        16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
          SizedBox(
            width: isSmallPhone(MediaQuery.of(context).size.width) ? 12 : 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Starred",

                ),
                if (!isEmpty)
                  Text(
                    "${starredFiles.length} ${starredFiles.length == 1 ? 'file' : 'files'}",
                  
                  ),
              ],
            ),
          ),
          if (!isEmpty) ...[
            IconButton(
              onPressed: () => _showSortOptions(),
              icon: const Icon(Icons.sort),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(
              width: isSmallPhone(MediaQuery.of(context).size.width) ? 4 : 8,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToolbar(ColorScheme colorScheme, bool isSmallPhone) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallPhone ? 16 : 20,
        vertical: 8,
      ),
      child: Row(
        children: [
          Text(
            "Sort by ${_sortBy.replaceFirst(_sortBy[0], _sortBy[0].toUpperCase())}",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: isSmallPhone ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.view_module,
              size: 20,
            ),
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
            ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(ColorScheme colorScheme, bool isSmallPhone) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallPhone ? 12 : 20,
        vertical: 8,
      ),
      itemCount: starredFiles.length,
      itemBuilder: (context, index) {
        final file = starredFiles[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 400),
          child: SlideAnimation(
            verticalOffset: 20,
            child: FadeInAnimation(
              child: _buildFileListItem(
                file,
                colorScheme,
                index == starredFiles.length - 1,
                isSmallPhone,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(
    ColorScheme colorScheme,
    bool isTablet,
    bool isSmallPhone,
  ) {
    final crossAxisCount =
        isTablet
            ? 3
            : isSmallPhone
            ? 2
            : 2;

    return GridView.builder(
      padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isSmallPhone ? 12 : 16,
        mainAxisSpacing: isSmallPhone ? 12 : 16,
        childAspectRatio: isSmallPhone ? 0.75 : 0.85,
      ),
      itemCount: starredFiles.length,
      itemBuilder: (context, index) {
        final file = starredFiles[index];
        return AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: crossAxisCount,
          duration: const Duration(milliseconds: 400),
          child: SlideAnimation(
            verticalOffset: 30,
            child: FadeInAnimation(
              child: _buildFileGridItem(file, colorScheme, isSmallPhone),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileListItem(
    Map<String, dynamic> file,
    ColorScheme colorScheme,
    bool isLast,
    bool isSmallPhone,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom:
            isLast
                ? 0
                : isSmallPhone
                ? 8
                : 12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openFile(file),
          borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
          child: Container(
            padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(isSmallPhone ? 12 : 16),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallPhone ? 40 : 48,
                  height: isSmallPhone ? 40 : 48,
                  decoration: BoxDecoration(
                    color: file['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
                  ),
                  child: Icon(
                    file['icon'],
                    color: file['color'],
                    size: isSmallPhone ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallPhone ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['name'],
                        style: TextStyle(
                          fontSize: isSmallPhone ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallPhone ? 2 : 4),
                      Row(
                        children: [
                          Text(
                            file['size'],
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: isSmallPhone ? 11 : 12,
                            ),
                          ),
                          Text(
                            " • ${file['date']}",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: isSmallPhone ? 11 : 12,
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
                      Container(
                        margin: EdgeInsets.only(right: isSmallPhone ? 4 : 8),
                        child: Icon(
                          Icons.people,
                          size: isSmallPhone ? 14 : 16,
                          color: colorScheme.primary,
                        ),
                      ),
                    IconButton(
                      onPressed: () => _toggleStar(file),
                      icon: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: isSmallPhone ? 18 : 20,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showFileOptions(file),
                      icon: Icon(Icons.more_vert, size: isSmallPhone ? 18 : 20),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
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

  Widget _buildFileGridItem(
    Map<String, dynamic> file,
    ColorScheme colorScheme,
    bool isSmallPhone,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openFile(file),
        borderRadius: BorderRadius.circular(isSmallPhone ? 16 : 20),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(isSmallPhone ? 16 : 20),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isSmallPhone ? 70 : 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      file['color'].withOpacity(0.8),
                      file['color'].withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isSmallPhone ? 16 : 20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: isSmallPhone ? 12 : 16,
                      top: isSmallPhone ? 12 : 16,
                      child: Icon(
                        file['icon'],
                        color: Colors.white,
                        size: isSmallPhone ? 28 : 32,
                      ),
                    ),
                    if (file['shared'])
                      Positioned(
                        left: isSmallPhone ? 12 : 16,
                        top: isSmallPhone ? 12 : 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallPhone ? 6 : 8,
                            vertical: isSmallPhone ? 2 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              isSmallPhone ? 10 : 12,
                            ),
                          ),
                          child: Text(
                            "Shared",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallPhone ? 9 : 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: isSmallPhone ? 12 : 16,
                      bottom: isSmallPhone ? 12 : 16,
                      child: GestureDetector(
                        onTap: () => _toggleStar(file),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber.shade200,
                          size: isSmallPhone ? 20 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['name'],
                        style: TextStyle(
                          fontSize: isSmallPhone ? 12 : 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallPhone ? 4 : 8),
                      Text(
                        file['size'],
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isSmallPhone ? 10 : 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        file['date'],
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isSmallPhone ? 10 : 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(ColorScheme colorScheme) {
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton(
        onPressed: () => _showQuickActions(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openFile(Map<String, dynamic> file) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Opening ${file['name']}"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleStar(Map<String, dynamic> file) {
    setState(() {
      starredFiles.removeWhere((f) => f['name'] == file['name']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Removed from starred"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              starredFiles.add(file);
              _sortFiles();
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort by",
                style: Theme.of(context).textTheme.headlineSmall, // ✅ fixed
              ),
              const SizedBox(height: 20),
              ...['name', 'date', 'size', 'type'].map(
                (option) => ListTile(
                  title: Text(option.toUpperCase()),
                  leading: Radio<String>(
                    value: option,
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                        _sortFiles();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _sortBy = option;
                      _sortFiles();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFileOptions(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("Share"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text("Download"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.star_border),
                title: const Text("Remove from starred"),
                onTap: () {
                  Navigator.pop(context);
                  _toggleStar(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: const Text("New folder"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text("Upload file"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Scan document"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
