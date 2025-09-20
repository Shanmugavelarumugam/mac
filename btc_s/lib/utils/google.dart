// import 'dart:convert';
// import 'package:btc_s/screens/home_screen.dart';
// import 'package:btc_s/utils/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignInService {
//   // ✅ Proper initialization with scopes
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//   Future<void> handleGoogleSignIn(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? account = await _googleSignIn.signIn();
//       if (account == null) {
//         print('Google sign-in cancelled');
//         return;
//       }

//       final GoogleSignInAuthentication auth = await account.authentication;
//       final String? idToken = auth.idToken;

//       if (idToken == null) {
//         print('No ID Token found');
//         return;
//       }

//       final response = await http.post(
//         Uri.parse('http://192.168.1.4:5000/api/users/google'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'token': idToken}),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         final String token = responseData['token'];
//         final String name = responseData['user']['name'];
//         final String email = responseData['user']['email'];

//         await UserPreferences.saveToken(token);
//         await UserPreferences.saveUserName(name);
//         await UserPreferences.saveUserEmail(email);

//         print('Login success: $responseData');

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//           (route) => false,
//         );
//       } else {
//         print('Login failed: ${response.body}');
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Google Sign-In failed')));
//       }
//     } catch (error) {
//       print('Google sign-in error: $error');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $error')));
//     }
//   }
// }
