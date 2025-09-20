import 'package:btc_s/screens/accessories.dart';
import 'package:btc_s/screens/beauty.dart';
import 'package:btc_s/screens/kids.dart';
import 'package:btc_s/screens/men.dart';
import 'package:btc_s/widgets/banner.dart';
import 'package:btc_s/widgets/feature_product_grid.dart';
import 'package:btc_s/widgets/feature_products.dart';
import 'package:btc_s/widgets/section_title.dart';
import 'package:btc_s/widgets/tabbar.dart';
import 'package:flutter/material.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const SizedBox(height: 17),
          const CategoryTabBar(),
          const SizedBox(height: 13),
          Expanded(
            child: TabBarView(
              children: [
                _buildWomenContent(),
                const MenProductsScreen(),
                const AccessoriesScreen(),
                const BeautyScreen(),
                const KidsProductsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildWomenContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 14),
          BannerWidget(),
          SizedBox(height: 13),
          FeatureProductsTitle(),
          FeatureProductGrid(),
          Banner1Widget(),
          SectionTitle(title: 'Recommended'),
          FeatureProductGrid(),
          SectionTitle(title: 'Top Collection'),
          FeatureProductGrid(),
          Banner2Widget(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
