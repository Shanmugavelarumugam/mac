import 'package:flutter/material.dart';
import 'package:web_app/presentation/screens/Home/quick_action_widgets.dart';

Widget buildBody(
  Size size,
  bool isDark,
  AnimationController animationController,
  Animation<double> logoAnimation,
  Animation<Offset> searchBarAnimation,
  Animation<double> searchBarScaleAnimation,
  Animation<Offset> contentSlideAnimation,
  Animation<double> contentFadeAnimation,
  Animation<double> quickActionsAnimation,
  Animation<double> weatherCardAnimation,
  Animation<double> newsCardAnimation,
  TextEditingController controller,
  FocusNode searchFocusNode,
  Function(String) handleSearch,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
    child: Column(
      children: [
        buildLogo(size, isDark, animationController, logoAnimation),
        buildSearchBar(
          size,
          isDark,
          animationController,
          searchBarAnimation,
          searchBarScaleAnimation,
          controller,
          searchFocusNode,
          handleSearch,
        ),
        SizedBox(height: size.height * 0.01),
        buildAskAIButton(size, isDark, handleSearch, controller),
        SizedBox(height: size.height * 0.02),
        buildContent(
          size,
          isDark,
          animationController,
          contentSlideAnimation,
          contentFadeAnimation,
          quickActionsAnimation,
          weatherCardAnimation,
          newsCardAnimation,
        ),
      ],
    ),
  );
}

Widget buildAskAIButton(
  Size size,
  bool isDark,
  Function(String) handleSearch,
  TextEditingController controller,
) {
  return Container(
    width: double.infinity,
    constraints: BoxConstraints(
      maxWidth: size.width > 500 ? 500 : double.infinity, // Reduced max width
    ),
    child: Center(
      child: ElevatedButton(
        onPressed: () => handleSearch(controller.text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.blueAccent : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ), // Reduced horizontal padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 20),
            const SizedBox(width: 6), // Slightly reduced spacing
            const Text(
              "Ask AI",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildLogo(
  Size size,
  bool isDark,
  AnimationController controller,
  Animation<double> logoAnimation,
) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(0, -30 * logoAnimation.value),
        child: Opacity(
          opacity: logoAnimation.value,
          child: Transform.scale(
            scale: 1.0 - (0.15 * (1 - logoAnimation.value)),
            child: Container(
              height: size.width * 0.25,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.purple.shade400,
                    Colors.pink.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "BTC",
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildSearchBar(
  Size size,
  bool isDark,
  AnimationController animationController,
  Animation<Offset> searchBarAnimation,
  Animation<double> searchBarScaleAnimation,
  TextEditingController textController,
  FocusNode searchFocusNode,
  Function(String) handleSearch,
) {
  return AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      return SlideTransition(
        position: searchBarAnimation,
        child: ScaleTransition(
          scale: searchBarScaleAnimation,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: size.width > 800 ? 800 : double.infinity,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(
                28,
              ), // Slightly smaller radius
              border: Border.all(
                color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                  blurRadius: 24, // Reduced blur
                  spreadRadius: 1,
                  offset: const Offset(0, 8), // Reduced offset
                ),
                if (!isDark)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 2,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ), // Reduced vertical padding
            child: Row(
              children: [
                const SizedBox(width: 16), // Reduced spacing
                Icon(
                  Icons.search_rounded,
                  color: Colors.grey[500],
                  size: 22,
                ), // Smaller icon
                const SizedBox(width: 12), // Reduced spacing
                Expanded(
                  child: Container(
                    height: 48, // Significantly reduced height
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: textController,
                      focusNode: searchFocusNode,
                      onSubmitted: handleSearch,
                      decoration: InputDecoration(
                        hintText: "Search the web...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16, // Smaller font
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, // Reduced padding
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 16, // Smaller font
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                buildSearchButton(
                  Icons.mic_rounded,
                  Colors.blueAccent,
                  22, // Smaller icon
                  handleSearch,
                  textController,
                ),
                const SizedBox(width: 8), // Reduced spacing
                buildSearchButton(
                  Icons.camera_alt_rounded,
                  Colors.greenAccent,
                  22, // Smaller icon
                  handleSearch,
                  textController,
                ),
                const SizedBox(width: 12), // Reduced spacing
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildSearchButton(
  IconData icon,
  Color color,
  double size,
  Function(String) handleSearch,
  TextEditingController controller,
) {
  return Container(
    width: 40, // Smaller button
    height: 50, // Smaller button
    child: IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: () => handleSearch(controller.text),
      splashRadius: 18, // Smaller splash radius
      padding: EdgeInsets.zero,
    ),
  );
}
