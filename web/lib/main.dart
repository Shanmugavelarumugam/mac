import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Android platform
import 'dart:io';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Android-specific WebView implementation
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform(); // Corrected class name
  }

  runApp(const MyApp());
}
