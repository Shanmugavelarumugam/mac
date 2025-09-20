import 'dart:ui';
import 'package:flutter/material.dart';

void showAccountMenu(BuildContext context, bool isDark) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF2A2D3A), const Color(0xFF1F1F23)],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                "Account Center",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  size: 20,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white.withOpacity(0.7),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.15)
                                : Colors.grey.withOpacity(0.3),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF667EEA),
                                    const Color(0xFF764BA2),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "H",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hari Vel",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isDark
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.green.withOpacity(0.1),
                                    ),
                                    child: Text(
                                      "hari111a1@gmail.com",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.green.shade300
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: isDark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    Colors.blue.withOpacity(0.2),
                                    Colors.purple.withOpacity(0.2),
                                  ]
                                : [
                                    Colors.blue.withOpacity(0.1),
                                    Colors.purple.withOpacity(0.1),
                                  ],
                          ),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  "Manage your Account",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.blue.shade300
                                        : Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(3, (sectionIndex) {
                        final sections = [
                          [
                            {
                              'icon': Icons.visibility_off_rounded,
                              'text': 'New Incognito Tab',
                            },
                            {
                              'icon': Icons.history_rounded,
                              'text': 'Search history',
                            },
                            {
                              'icon': Icons.delete_outline_rounded,
                              'text': 'Delete last 15 mins',
                            },
                            {
                              'icon': Icons.person_outline_rounded,
                              'text': 'Search personalisation',
                            },
                          ],
                          [
                            {
                              'icon': Icons.shield_rounded,
                              'text': 'SafeSearch',
                            },
                            {
                              'icon': Icons.info_outline_rounded,
                              'text': 'Results about you',
                            },
                            {
                              'icon': Icons.bookmark_border_rounded,
                              'text': 'Saves & Collections',
                            },
                            {
                              'icon': Icons.account_circle_outlined,
                              'text': 'Your Profile',
                            },
                          ],
                          [
                            {
                              'icon': Icons.timeline_rounded,
                              'text': 'Your Activity',
                            },
                            {
                              'icon': Icons.settings_rounded,
                              'text': 'Settings',
                            },
                            {
                              'icon': Icons.help_outline_rounded,
                              'text': 'Help & Feedback',
                            },
                          ],
                        ];

                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.white.withOpacity(0.5),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                children: sections[sectionIndex]
                                    .map(
                                      (item) => buildEnhancedMenuItem(
                                        item['icon'] as IconData,
                                        item['text'] as String,
                                        isDark,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark
                              ? Colors.red.withOpacity(0.1)
                              : Colors.red.withOpacity(0.05),
                          border: Border.all(
                            color: isDark
                                ? Colors.red.withOpacity(0.3)
                                : Colors.red.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            buildEnhancedMenuItem(
                              Icons.swap_horiz_rounded,
                              "Switch account",
                              isDark,
                            ),
                            buildEnhancedMenuItem(
                              Icons.add_circle_outline_rounded,
                              "Add another account",
                              isDark,
                            ),
                            buildEnhancedMenuItem(
                              Icons.logout_rounded,
                              "Sign out",
                              isDark,
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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

Widget buildEnhancedMenuItem(
  IconData icon,
  String text,
  bool isDark, {
  bool isDestructive = false,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark
                      ? (isDestructive
                            ? Colors.red.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1))
                      : (isDestructive
                            ? Colors.red.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05)),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDestructive
                      ? (isDark ? Colors.red.shade300 : Colors.red.shade600)
                      : (isDark ? Colors.white70 : Colors.grey.shade700),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? (isDark ? Colors.red.shade300 : Colors.red.shade600)
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
