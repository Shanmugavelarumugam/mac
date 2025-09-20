import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_business/presentation/widgets/Home/app_drawer.dart';
import 'package:btc_business/presentation/widgets/Home/home_menu_items.dart';
import 'package:btc_business/presentation/widgets/Home/menu_card.dart';

import 'package:btc_business/blocs/menu/menu_bloc.dart';
import 'package:btc_business/blocs/menu/menu_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenuBloc(),
      child: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuNavigateTo) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => state.screen),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            title: const Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          drawer: const AppDrawer(),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.05,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return MenuCard(title: item['title'], icon: item['icon']);
            },
          ),
        ),
      ),
    );
  }
}
