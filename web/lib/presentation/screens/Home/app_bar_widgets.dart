import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_app/logic/bloc/search/search_bloc.dart';
import 'package:web_app/logic/bloc/search/search_state.dart';
import 'package:web_app/presentation/widgets/account_menu.dart';

Widget buildSliverAppBar(
  bool isDark,
  AnimationController controller,
  Animation<double> appBarAnimation,
) {
  return SliverAppBar(
    expandedHeight: 0,
    floating: true,
    pinned: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: appBarAnimation.value,
          child: Transform.translate(
            offset: Offset(0, -20 * (1 - appBarAnimation.value)),
            child: buildAppBarContent(isDark, context),
          ),
        );
      },
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(
                  opacity: appBarAnimation.value,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

Widget buildAppBarContent(bool isDark, BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildNotificationButton(isDark),
        const SizedBox(width: 12),
        buildProfileButton(isDark, context),
      ],
    ),
  );
}

Widget buildNotificationButton(bool isDark) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(
        Icons.notifications_outlined,
        color: isDark ? Colors.white70 : Colors.grey[600],
        size: 22,
      ),
      onPressed: () {},
    ),
  );
}

Widget buildProfileButton(bool isDark, BuildContext context) {
  return GestureDetector(
    onTap: () => showAccountMenu(context, isDark),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 18,
        child: Text(
          "H",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
