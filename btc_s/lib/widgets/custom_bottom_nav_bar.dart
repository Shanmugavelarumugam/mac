import 'package:btc_s/utils/assets.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(AppImages.homeInactive, width: 30, height: 30),
            activeIcon: Image.asset(AppImages.home, width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppImages.searchInactive, width: 30, height: 30),
            activeIcon: Image.asset(AppImages.search, width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppImages.orderInactive, width: 30, height: 30),
            activeIcon: Image.asset(AppImages.order, width: 30, height: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppImages.profileInactive, width: 30, height: 30),
            activeIcon: Image.asset(AppImages.profile, width: 30, height: 30),
            label: '',
          ),
        ],
      ),
    );
  }
}
