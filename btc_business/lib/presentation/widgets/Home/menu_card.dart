import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btc_business/blocs/menu/menu_bloc.dart';
import 'package:btc_business/blocs/menu/menu_event.dart';

class MenuCard extends StatefulWidget {
  final String title;
  final IconData icon;

  const MenuCard({super.key, required this.title, required this.icon});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.read<MenuBloc>().add(MenuItemTapped(widget.title));
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(widget.icon, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
