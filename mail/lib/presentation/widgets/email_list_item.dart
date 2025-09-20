import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/data/models/email.dart';
import 'package:mail/presentation/screens/email_detail_screen.dart';
class EmailListItem extends StatelessWidget {
  final Email email;

  const EmailListItem({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: email.isRead ? AppColors.background : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                email.senderColor?.withOpacity(0.2) ??
                AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              email.avatarText ?? email.sender[0].toUpperCase(),
              style: TextStyle(
                color: email.senderColor ?? AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                email.sender,
                style: TextStyle(
                  fontWeight: email.isRead
                      ? FontWeight.normal
                      : FontWeight.w600,
                  color: email.isRead ? AppColors.secondary : Colors.black87,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (email.isStarred)
              Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
            const SizedBox(width: 8),
            Text(
              email.time,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              email.subject,
              style: TextStyle(
                fontWeight: email.isRead ? FontWeight.normal : FontWeight.w600,
                color: email.isRead ? AppColors.secondary : Colors.black87,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    email.preview,
                    style: TextStyle(fontSize: 13, color: AppColors.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (email.hasAttachment)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.attachment_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailDetailScreen(email: email),
            ),
          );
        },      ),
    );
  }
}
