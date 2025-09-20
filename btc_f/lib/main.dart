import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/bloc_observer.dart';
import 'data/repositories/food_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/food/food_bloc.dart';
import 'logic/food/food_event.dart';
import 'logic/auth/auth_bloc.dart';
import 'utils/auth_storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  // ✅ Check for token
  String? token = await AuthStorage.getToken();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FoodBloc(FoodRepository())..add(LoadFoods()),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
      ],
      child: MyApp(isLoggedIn: token != null),
    ),
  );
}
