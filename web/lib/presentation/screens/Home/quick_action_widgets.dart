import 'package:flutter/material.dart';
import 'package:web_app/presentation/screens/Home/info_card_widgets.dart';
import 'package:web_app/presentation/widgets/quick_action.dart';

Widget buildContent(
  Size size,
  bool isDark,
  AnimationController controller,
  Animation<Offset> contentSlideAnimation,
  Animation<double> contentFadeAnimation,
  Animation<double> quickActionsAnimation,
  Animation<double> weatherCardAnimation,
  Animation<double> newsCardAnimation,
) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return SlideTransition(
        position: contentSlideAnimation,
        child: FadeTransition(
          opacity: contentFadeAnimation,
          child: Column(
            children: [
              buildQuickActions(size, isDark, quickActionsAnimation),
              SizedBox(height: size.height * 0.04),
              buildInfoCards(
                size,
                isDark,
                weatherCardAnimation,
                newsCardAnimation,
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildQuickActions(
  Size size,
  bool isDark,
  Animation<double> quickActionsAnimation,
) {
  return AnimatedBuilder(
    animation: quickActionsAnimation,
    builder: (context, child) {
      return Transform.scale(
        scale: quickActionsAnimation.value,
        child: Opacity(
          opacity: quickActionsAnimation.value,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: size.width > 600 ? 600 : double.infinity,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildQuickActionCard(
                    Icons.school_rounded,
                    "Education",
                    Colors.blueAccent,
                    isDark,
                    context,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildQuickActionCard(
                    Icons.movie_rounded,
                    "Entertainment",
                    Colors.purpleAccent,
                    isDark,
                    context,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildQuickActionCard(
                    Icons.account_balance_wallet_rounded,
                    "Finance",
                    Colors.greenAccent,
                    isDark,
                    context,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildQuickActionCard(
                    Icons.sports_soccer_rounded,
                    "Sports",
                    Colors.orangeAccent,
                    isDark,
                    context,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildQuickActionCard(
  IconData icon,
  String label,
  Color color,
  bool isDark,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () => buildQuickAction(icon, label, context),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.7 : 1.0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
