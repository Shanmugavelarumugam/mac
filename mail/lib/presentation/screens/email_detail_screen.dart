import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/data/models/email.dart';
import 'package:mail/presentation/screens/compose_email_screen.dart';

class EmailDetailScreen extends StatefulWidget {
  final Email email;

  const EmailDetailScreen({super.key, required this.email});

  @override
  State<EmailDetailScreen> createState() => _EmailDetailScreenState();
}

class _EmailDetailScreenState extends State<EmailDetailScreen> {
  bool _isStarred = false;
  bool _isImportant = false;
  bool _showFullHeader = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isCompact = screenHeight < 650;
    final isExtraCompact = screenHeight < 550;
    final isWideScreen = screenWidth > 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable email content
          CustomScrollView(
            slivers: [
              _buildAppBar(context, isCompact, isExtraCompact, theme),

              // Add padding at the bottom using SliverPadding
              SliverPadding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // leave space for bottom buttons
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildEmailHeader(
                        context,
                        isCompact,
                        isExtraCompact,
                        isWideScreen,
                        theme,
                      ),
                      _buildEmailContent(
                        context,
                        isCompact,
                        isExtraCompact,
                        theme,
                      ),
                      if (widget.email.hasAttachment)
                        _buildAttachments(
                          context,
                          isCompact,
                          isExtraCompact,
                          theme,
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Buttons always visible
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildActionButtons(
              context,
              isCompact,
              isExtraCompact,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    bool isCompact,
    bool isExtraCompact,
    ThemeData theme,
  ) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      pinned: true,
      expandedHeight: isExtraCompact
          ? 60
          : isCompact
          ? 70
          : 80,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.grey[700],
            size: isExtraCompact ? 18 : 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: AnimatedOpacity(
        opacity: 0.8,
        duration: const Duration(milliseconds: 200),
        child: Text(
          widget.email.sender,
          style: TextStyle(
            fontSize: isExtraCompact
                ? 16
                : isCompact
                ? 18
                : 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        _buildActionIcon(
          icon: _isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
          color: _isStarred ? Colors.amber[600] : Colors.grey[600],
          onPressed: () => setState(() => _isStarred = !_isStarred),
          isCompact: isExtraCompact,
        ),
        _buildActionIcon(
          icon: Icons.archive_outlined,
          color: Colors.grey[600],
          onPressed: () =>
              _showSnackBar(context, "Email archived", Colors.green[600]!),
          isCompact: isExtraCompact,
        ),
        _buildActionIcon(
          icon: Icons.delete_outline_rounded,
          color: Colors.grey[600],
          onPressed: () =>
              _showSnackBar(context, "Moved to trash", Colors.red[600]!),
          isCompact: isExtraCompact,
        ),
        _buildMoreMenu(context, isExtraCompact),
        SizedBox(width: isExtraCompact ? 8 : 12),
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required Color? color,
    required VoidCallback onPressed,
    required bool isCompact,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: isCompact ? 20 : 22),
        onPressed: onPressed,
        padding: EdgeInsets.all(isCompact ? 10 : 12),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context, bool isExtraCompact) {
    return PopupMenuButton<String>(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        padding: EdgeInsets.all(isExtraCompact ? 10 : 12),
        child: Icon(
          Icons.more_horiz_rounded,
          color: Colors.grey[600],
          size: isExtraCompact ? 20 : 22,
        ),
      ),
      onSelected: (value) => _handleMenuAction(context, value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      itemBuilder: (context) => [
        _buildMenuItem(
          Icons.mark_email_unread_outlined,
          "Mark as unread",
          'mark_unread',
        ),
        _buildMenuItem(Icons.label_outline_rounded, "Add label", 'add_label'),
        _buildMenuItem(Icons.schedule_outlined, "Snooze", 'snooze'),
        _buildMenuItem(Icons.block_outlined, "Block sender", 'block'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String text,
    String value,
  ) {
    return PopupMenuItem(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.grey[600], size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailHeader(
    BuildContext context,
    bool isCompact,
    bool isExtraCompact,
    bool isWideScreen,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.all(isExtraCompact ? 12 : 16),
      padding: EdgeInsets.all(isExtraCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject with priority indicator
          Row(
            children: [
              if (_isImportant)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    "URGENT",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  widget.email.subject,
                  style: TextStyle(
                    fontSize: isExtraCompact
                        ? 20
                        : isCompact
                        ? 22
                        : 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isExtraCompact ? 16 : 20),

          // Sender info
          Row(
            children: [
              Hero(
                tag: 'avatar_${widget.email.sender}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.email.senderColor ?? Colors.grey)
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: isExtraCompact
                        ? 22
                        : isCompact
                        ? 24
                        : 26,
                    backgroundColor:
                        (widget.email.senderColor ?? Colors.grey[400])
                            ?.withOpacity(0.15),
                    child: Text(
                      widget.email.avatarText ??
                          widget.email.sender[0].toUpperCase(),
                      style: TextStyle(
                        color: widget.email.senderColor ?? Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: isExtraCompact
                            ? 16
                            : isCompact
                            ? 18
                            : 20,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: isExtraCompact ? 12 : 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.email.sender,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isExtraCompact
                                  ? 16
                                  : isCompact
                                  ? 17
                                  : 18,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.email.time,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isExtraCompact ? 12 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: () =>
                          setState(() => _showFullHeader = !_showFullHeader),
                      child: Row(
                        children: [
                          Text(
                            _showFullHeader ? "Hide details" : "to me",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isExtraCompact ? 13 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _showFullHeader
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ],
                      ),
                    ),

                    if (_showFullHeader) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderDetail("From:", widget.email.sender),
                            const SizedBox(height: 6),
                            _buildHeaderDetail("To:", "you@example.com"),
                            const SizedBox(height: 6),
                            _buildHeaderDetail("Date:", widget.email.time),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailContent(
    BuildContext context,
    bool isCompact,
    bool isExtraCompact,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isExtraCompact ? 12 : 16),
      padding: EdgeInsets.all(isExtraCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        widget.email.preview,
        style: TextStyle(
          fontSize: isExtraCompact
              ? 15
              : isCompact
              ? 16
              : 17,
          color: Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAttachments(
    BuildContext context,
    bool isCompact,
    bool isExtraCompact,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.all(isExtraCompact ? 12 : 16),
      padding: EdgeInsets.all(isExtraCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.attach_file_rounded,
                  color: Colors.blue[600],
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Attachments (3)",
                style: TextStyle(
                  fontSize: isExtraCompact ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: isExtraCompact ? 12 : 16),

          Column(
            children: [
              _buildAttachmentTile(
                "Project_Proposal.pdf",
                "2.4 MB",
                Icons.picture_as_pdf,
                Colors.red,
              ),
              const SizedBox(height: 8),
              _buildAttachmentTile(
                "Design_Mockup.jpg",
                "1.8 MB",
                Icons.image,
                Colors.green,
              ),
              const SizedBox(height: 8),
              _buildAttachmentTile(
                "Budget_Analysis.xlsx",
                "856 KB",
                Icons.table_chart,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentTile(
    String name,
    String size,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  size,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                _showSnackBar(context, "Downloading $name", Colors.blue[600]!),
            icon: Icon(Icons.download_rounded, color: color, size: 20),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isCompact,
    bool isExtraCompact,
    ThemeData theme,
  ) {
    // Determine icon size based on compactness
    double iconSize = isExtraCompact ? 24 : (isCompact ? 22 : 28);

    return Container(
      margin: EdgeInsets.all(isExtraCompact ? 12 : 16),
      padding: EdgeInsets.all(isExtraCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.reply_rounded,
              label: "Reply",
              onPressed: () => _navigateToCompose(context),
              isPrimary: true,
              isCompact: isExtraCompact,
              iconSize: iconSize, // pass the size
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.reply_all_rounded,
              label: "Reply All",
              onPressed: () => _navigateToCompose(context),
              isPrimary: false,
              isCompact: isExtraCompact,
              iconSize: iconSize,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.forward_rounded,
              label: "Forward",
              onPressed: () => _navigateToCompose(context),
              isPrimary: false,
              isCompact: isExtraCompact,
              iconSize: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
    required bool isCompact,
    double iconSize = 20, // default size
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue[600] : Colors.grey[100],
        foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
        elevation: isPrimary ? 2 : 0,
        shadowColor: isPrimary
            ? Colors.blue.withOpacity(0.3)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.grey[300]!),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isCompact ? 8 : 12,
          horizontal: isCompact ? 6 : 10,
        ),
        minimumSize: Size(isCompact ? 50 : 70, isCompact ? 50 : 70),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          SizedBox(height: isCompact ? 2 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'mark_unread':
        _showSnackBar(context, "Marked as unread", Colors.blue[600]!);
        break;
      case 'add_label':
        _showSnackBar(context, "Label added", Colors.green[600]!);
        break;
      case 'snooze':
        _showSnackBar(context, "Email snoozed", Colors.orange[600]!);
        break;
      case 'block':
        _showSnackBar(context, "Sender blocked", Colors.red[600]!);
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCompose(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ComposeEmailScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
