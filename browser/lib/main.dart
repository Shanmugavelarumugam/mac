import 'package:browser/bloc/browser_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider<BrowserBloc>(create: (_) => BrowserBloc())],
      child: const MyApp(),
    ),
  );
}
