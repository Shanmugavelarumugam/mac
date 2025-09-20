import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_app/data/repository/search_repository.dart';
import 'package:web_app/logic/bloc/search/search_bloc.dart';
import 'package:web_app/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SearchRepository>(
          create: (_) => SearchRepository(
            baseUrl: "https://consideration-ruling-craps-commissioners.trycloudflare.com", // ✅ your API base  https://consideration-ruling-craps-commissioners.trycloudflare.com
        //  baseUrl: "http://192.168.1.5:5001", 
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(context.read<SearchRepository>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "BTC Search",
          theme: ThemeData(
            primaryColor: Colors.blue,
            fontFamily: 'Roboto',
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              backgroundColor: Colors.grey[50]!,
            ),
          ),
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
