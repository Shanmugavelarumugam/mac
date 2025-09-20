import 'package:flutter/material.dart';
import 'news_card_widgets.dart';

Widget buildInfoCards(
  Size size,
  bool isDark,
  Animation<double> weatherCardAnimation,
  Animation<double> newsCardAnimation,
) {
  return Container(
    width: double.infinity,
    constraints: BoxConstraints(
      maxWidth: size.width > 600 ? 600 : double.infinity,
    ),
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 16.0),
            child: Text(
              "Today",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: isDark
                    ? Colors.white.withOpacity(0.9)
                    : Colors.grey[900],
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                buildWeatherCard(isDark, weatherCardAnimation),
                const SizedBox(width: 20),
                buildGoldPriceCard(isDark, weatherCardAnimation),
                const SizedBox(width: 20),
                buildSunsetCard(isDark, weatherCardAnimation),
                const SizedBox(width: 20),
                buildAirQualityCard(isDark, weatherCardAnimation),
                const SizedBox(width: 20),
                buildFinanceCard(isDark, weatherCardAnimation),
              ],
            ),
          ),
          const SizedBox(height: 32),
          buildNewsCard(isDark, newsCardAnimation),
        ],
      ),
    ),
  );
}

Widget buildWeatherCard(bool isDark, Animation<double> weatherCardAnimation) {
  return AnimatedBuilder(
    animation: weatherCardAnimation,
    builder: (context, child) {
      double clampedValue = weatherCardAnimation.value.clamp(0.0, 1.0);

      return Transform.translate(
        offset: Offset(0, 30 * (1 - clampedValue)),
        child: Opacity(
          opacity: clampedValue,
          child: GestureDetector(
            onTap: () {}, // Add interactivity for tap effects
            child: Container(
              width: 170,
              height: 160,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weather",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: isDark
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey[900],
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0 + (clampedValue * 0.2),
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          size: 26,
                          color: isDark ? Colors.amber[300] : Colors.amber[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "New York",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    "24°C",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Humidity: 60%",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildAirQualityCard(
  bool isDark,
  Animation<double> weatherCardAnimation,
) {
  return AnimatedBuilder(
    animation: weatherCardAnimation,
    builder: (context, child) {
      double clampedValue = weatherCardAnimation.value.clamp(0.0, 1.0);

      return Transform.translate(
        offset: Offset(0, 30 * (1 - clampedValue)),
        child: Opacity(
          opacity: clampedValue,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 170,
              height: 160,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Air Quality",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: isDark
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey[900],
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0 + (clampedValue * 0.2),
                        child: Icon(
                          Icons.air_rounded,
                          size: 26,
                          color: isDark ? Colors.green[300] : Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "42",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    "Good",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.green[300] : Colors.green[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_circle_outlined,
                        size: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "PM2.5: 10 µg/m³",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildSunsetCard(bool isDark, Animation<double> weatherCardAnimation) {
  return AnimatedBuilder(
    animation: weatherCardAnimation,
    builder: (context, child) {
      double clampedValue = weatherCardAnimation.value.clamp(0.0, 1.0);

      return Transform.translate(
        offset: Offset(0, 30 * (1 - clampedValue)),
        child: Opacity(
          opacity: clampedValue,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 170,
              height: 160,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sunset",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: isDark
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey[900],
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0 + (clampedValue * 0.2),
                        child: Icon(
                          Icons.nightlight_round,
                          size: 26,
                          color: isDark
                              ? Colors.orange[300]
                              : Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "6:08 PM",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    "Dusk",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.orange[300] : Colors.orange[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Sunrise: 6:45 AM",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildGoldPriceCard(bool isDark, Animation<double> weatherCardAnimation) {
  return AnimatedBuilder(
    animation: weatherCardAnimation,
    builder: (context, child) {
      double clampedValue = weatherCardAnimation.value.clamp(0.0, 1.0);

      return Transform.translate(
        offset: Offset(0, 30 * (1 - clampedValue)),
        child: Opacity(
          opacity: clampedValue,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 170,
              height: 160,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gold",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: isDark
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey[900],
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0 + (clampedValue * 0.2),
                        child: Icon(
                          Icons.monetization_on_rounded,
                          size: 26,
                          color: isDark ? Colors.amber[300] : Colors.amber[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₹113,540",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    "+0.20%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.green[300] : Colors.green[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.scale_outlined,
                        size: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Per 10g",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildFinanceCard(bool isDark, Animation<double> weatherCardAnimation) {
  return AnimatedBuilder(
    animation: weatherCardAnimation,
    builder: (context, child) {
      double clampedValue = weatherCardAnimation.value.clamp(0.0, 1.0);

      return Transform.translate(
        offset: Offset(0, 30 * (1 - clampedValue)),
        child: Opacity(
          opacity: clampedValue,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 170,
              height: 160,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[800]!]
                      : [Colors.white, Colors.grey[100]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sensex",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: isDark
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey[900],
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0 + (clampedValue * 0.2),
                        child: Icon(
                          Icons.trending_up_rounded,
                          size: 26,
                          color: isDark
                              ? Colors.purple[300]
                              : Colors.purple[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "82,526",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  Text(
                    "-0.59%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isDark ? Colors.red[300] : Colors.red[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.show_chart_outlined,
                        size: 15,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Nifty: 25,210",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
