import 'package:flutter/material.dart';
import 'package:web_app/data/model/download_status.dart';
import '../utils/time_formatter.dart';

Widget buildDownloadItem(
  String filename,
  String size,
  IconData icon,
  Color iconColor,
  DownloadStatus status,
  bool isDark,
  DateTime downloadTime, {
  double? progress,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2D2D30) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF3C3C3C) : const Color(0xFFE8EAED),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filename,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF202124),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    size,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : const Color(0xFF5F6368),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "• ${formatTime(downloadTime)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : const Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
              if (status != DownloadStatus.completed) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress ?? 0,
                          minHeight: 3,
                          backgroundColor: isDark
                              ? const Color(0xFF3C3C3C)
                              : const Color(0xFFE8EAED),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            status == DownloadStatus.paused
                                ? Colors.orange
                                : const Color(0xFF4285F4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${((progress ?? 0) * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF5F6368),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildStatusIcon(status, isDark),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: isDark ? Colors.white60 : const Color(0xFF5F6368),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'open', child: Text('Open')),
                const PopupMenuItem(
                  value: 'show',
                  child: Text('Show in folder'),
                ),
                if (status != DownloadStatus.completed) ...[
                  PopupMenuItem(
                    value: status == DownloadStatus.downloading
                        ? 'pause'
                        : 'resume',
                    child: Text(
                      status == DownloadStatus.downloading ? 'Pause' : 'Resume',
                    ),
                  ),
                  const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                ],
              ],
              onSelected: (value) {
                // Handle actions here: open, show, pause, resume, cancel
              },
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildStatusIcon(DownloadStatus status, bool isDark) {
  switch (status) {
    case DownloadStatus.downloading:
      return Icon(
        Icons.download,
        color: isDark ? Colors.white : Colors.blue,
        size: 18,
      );
    case DownloadStatus.paused:
      return Icon(
        Icons.pause_circle_outline,
        color: isDark ? Colors.orange : Colors.orange,
        size: 18,
      );
    case DownloadStatus.completed:
      return Icon(Icons.check_circle, color: Colors.green, size: 18);
    case DownloadStatus.failed:
      return Icon(Icons.error, color: Colors.red, size: 18);
    default:
      return Icon(
        Icons.download,
        color: isDark ? Colors.white : Colors.blue,
        size: 18,
      );
  }
}
