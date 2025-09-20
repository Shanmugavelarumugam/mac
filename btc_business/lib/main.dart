import 'package:btc_business/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/navigation/navigation_bloc.dart';
import 'blocs/navigation/navigation_event.dart';
import 'blocs/navigation/navigation_state.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/finance_screen.dart';
import 'presentation/screens/ai_screen.dart';
import 'presentation/screens/public_screen.dart';
import 'presentation/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}


