import 'package:flutter/material.dart';

class Email {
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final bool isRead;
  final bool isStarred;
  final bool hasAttachment;
  final String? avatarText;
  final Color? senderColor;

  Email({
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    this.isRead = false,
    this.isStarred = false,
    this.hasAttachment = false,
    this.avatarText,
    this.senderColor,
  });
}

final List<Email> inboxEmails = [
  Email(
    sender: "Google",
    subject: "Security alert",
    preview:
        "New sign-in on Windows device. We noticed a new sign-in to your Google Account.",
    time: "10:30 AM",
    isStarred: true,
    avatarText: "G",
    senderColor: Colors.blue,
  ),
  Email(
    sender: "Twitter",
    subject: "New login to your account",
    preview: "We noticed a new login to your Twitter account.",
    time: "9:45 AM",
    isRead: true,
    avatarText: "T",
    senderColor: Colors.lightBlue,
  ),
  Email(
    sender: "Amazon",
    subject: "Your order has shipped!",
    preview:
        "Your recent order is on its way. Your package will be delivered tomorrow.",
    time: "Yesterday",
    hasAttachment: true,
    avatarText: "A",
    senderColor: Colors.orange,
  ),
  Email(
    sender: "LinkedIn",
    subject: "You have 5 new notifications",
    preview: "See who's viewed your profile and more.",
    time: "Yesterday",
    isRead: true,
    avatarText: "L",
    senderColor: Colors.blue.shade800,
  ),
  Email(
    sender: "Netflix",
    subject: "New TV shows and movies added",
    preview: "Check out the latest titles added to Netflix this week.",
    time: "Jun 12",
    avatarText: "N",
    senderColor: Colors.red,
  ),
  Email(
    sender: "GitHub",
    subject: "Your daily digest",
    preview: "See what's happening in your repositories.",
    time: "Jun 11",
    isRead: true,
    hasAttachment: true,
    avatarText: "GH",
    senderColor: Colors.purple,
  ),
];
