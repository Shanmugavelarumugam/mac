import 'package:flutter/material.dart';
import 'dart:math' as math;

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _uploadAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatus = "";
  List<Map<String, dynamic>> _uploadQueue = [];

  // Color palette
  final Color _primaryColor = const Color(0xFF6C63FF);
  final Color _secondaryColor = const Color(0xFF4FC3F7);
  final Color _accentColor = const Color(0xFFF50057);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _surfaceColor = Colors.white;
  final Color _textPrimary = const Color(0xFF2D3748);
  final Color _textSecondary = const Color(0xFF718096);

  // Mock recent uploads
  final List<Map<String, dynamic>> _recentUploads = [
    {
      'name': 'Document_scan_2024.pdf',
      'size': '2.4 MB',
      'type': 'pdf',
      'date': '2 minutes ago',
      'status': 'completed',
      'icon': Icons.picture_as_pdf,
      'color': Color(0xFFFF5252),
    },
    {
      'name': 'Team_photo.jpg',
      'size': '5.7 MB',
      'type': 'image',
      'date': '1 hour ago',
      'status': 'completed',
      'icon': Icons.image,
      'color': Color(0xFF448AFF),
    },
    {
      'name': 'Budget_analysis.xlsx',
      'size': '1.8 MB',
      'type': 'spreadsheet',
      'date': 'Yesterday',
      'status': 'completed',
      'icon': Icons.table_chart,
      'color': Color(0xFF4CAF50),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _uploadAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _uploadAnimationController.dispose();
    super.dispose();
  }

  void _simulateUpload(String fileName, String fileType) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadStatus = "Preparing upload...";
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 100.0;
          if (i < 30) {
            _uploadStatus = "Uploading $fileName...";
          } else if (i < 70) {
            _uploadStatus = "Processing file...";
          } else if (i < 95) {
            _uploadStatus = "Finalizing upload...";
          } else {
            _uploadStatus = "Upload complete!";
          }
        });
      }
    }

    await Future.delayed(Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
        _uploadStatus = "";

        // Add to recent uploads
        _recentUploads.insert(0, {
          'name': fileName,
          'size':
              '${(math.Random().nextDouble() * 10 + 0.1).toStringAsFixed(1)} MB',
          'type': fileType,
          'date': 'Just now',
          'status': 'completed',
          'icon': _getFileIcon(fileType),
          'color': _getFileColor(fileType),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text("$fileName uploaded successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      case 'video':
        return Icons.video_file;
      case 'audio':
        return Icons.audio_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Color(0xFFFF5252);
      case 'image':
        return Color(0xFF448AFF);
      case 'document':
        return Color(0xFF7C4DFF);
      case 'video':
        return Color(0xFFE040FB);
      case 'audio':
        return Color(0xFFFFAB00);
      default:
        return _textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.width < 350;
    final iconSize = isSmallDevice ? 18.0 : 22.0;
    final titleFontSize = isSmallDevice ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(iconSize, titleFontSize),
            Expanded(
              child:
                  _isUploading
                      ? _buildUploadingState(size)
                      : _buildMainContent(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(double iconSize, double titleFontSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.cloud_upload,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload Files",
                  style: TextStyle(
                    fontSize: titleFontSize + 2,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Add files to your cloud storage",
                  style: TextStyle(
                    fontSize: titleFontSize - 2,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline, size: iconSize),
            style: IconButton.styleFrom(
              backgroundColor: _backgroundColor,
              foregroundColor: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState(Size size) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _primaryColor.withOpacity(0.1),
                        _secondaryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: CircularProgressIndicator(
                    value: _uploadProgress,
                    strokeWidth: 8,
                    backgroundColor: _backgroundColor,
                    valueColor: AlwaysStoppedAnimation(_primaryColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: size.width * 0.12,
                      color: _primaryColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${(_uploadProgress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              _uploadStatus,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              width: size.width * 0.7,
              child: LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: _backgroundColor,
                valueColor: AlwaysStoppedAnimation(_primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _isUploading = false;
                  _uploadProgress = 0.0;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _accentColor,
                side: BorderSide(color: _accentColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: Text("Cancel Upload"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUploadDropZone(size),
          _buildUploadOptions(size),
          if (_recentUploads.isNotEmpty) _buildRecentUploads(size),
        ],
      ),
    );
  }

  Widget _buildUploadDropZone(Size size) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _simulateUpload("selected_file.pdf", "pdf"),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.28,
                    decoration: BoxDecoration(
                      color: _surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.2),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.18,
                          height: size.width * 0.18,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primaryColor, _secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            size: size.width * 0.08,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Drag & Drop Files",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "or tap to browse your device",
                          style: TextStyle(fontSize: 14, color: _textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Max file size: 100 MB",
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOptions(Size size) {
    final isSmallDevice = size.width < 350;
    final crossAxisCount = size.width > 600 ? 4 : (size.width > 400 ? 3 : 2);
    final childAspectRatio = isSmallDevice ? 0.9 : 1.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
            children: [
              _buildQuickActionCard(
                "Files",
                Icons.folder_open,
                _primaryColor,
                () => _simulateUpload("document.docx", "document"),
                size,
              ),
              _buildQuickActionCard(
                "Camera",
                Icons.camera_alt,
                _secondaryColor,
                () => _simulateUpload("camera_photo.jpg", "image"),
                size,
              ),
              _buildQuickActionCard(
                "Scan",
                Icons.document_scanner,
                Color(0xFFFF9800),
                () => _simulateUpload("scanned_doc.pdf", "pdf"),
                size,
              ),
              _buildQuickActionCard(
                "Audio",
                Icons.mic,
                _accentColor,
                () => _simulateUpload("recording.mp3", "audio"),
                size,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    Size size,
  ) {
    final isSmallDevice = size.width < 350;
    final iconSize = isSmallDevice ? 22.0 : 26.0;
    final fontSize = isSmallDevice ? 12.0 : 14.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isSmallDevice ? 44 : 50,
                height: isSmallDevice ? 44 : 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              SizedBox(height: isSmallDevice ? 8 : 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentUploads(Size size) {
    final isSmallDevice = size.width < 350;

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Recent Uploads",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: math.min(_recentUploads.length, 3),
            itemBuilder: (context, index) {
              final file = _recentUploads[index];
              return _buildRecentUploadItem(
                file,
                index == _recentUploads.length - 1,
                isSmallDevice,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUploadItem(
    Map<String, dynamic> file,
    bool isLast,
    bool isSmallDevice,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(14),
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
                Container(
                  width: isSmallDevice ? 42 : 48,
                  height: isSmallDevice ? 42 : 48,
                  decoration: BoxDecoration(
                    color: file['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    file['icon'],
                    color: file['color'],
                    size: isSmallDevice ? 20 : 24,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['name'],
                        style: TextStyle(
                          fontSize: isSmallDevice ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
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
                              color: _textSecondary,
                              fontSize: isSmallDevice ? 11 : 12,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _textSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            file['date'],
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: isSmallDevice ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        "Done",
                        style: TextStyle(
                          fontSize: isSmallDevice ? 10 : 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
