import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_app/data/repository/search_repository.dart';
import 'package:web_app/logic/bloc/search/search_bloc.dart';
import 'package:web_app/logic/bloc/search/search_event.dart';
import 'package:web_app/logic/bloc/search/search_state.dart';
import 'package:web_app/presentation/screens/in_app_browser.dart';
import 'package:web_app/presentation/screens/search_results_page.dart';
import 'app_bar_widgets.dart';
import 'search_bar_widgets.dart';
import 'quick_action_widgets.dart';
import 'info_card_widgets.dart';
import 'news_card_widgets.dart';

class SearchHomePage extends StatefulWidget {
  const SearchHomePage({super.key});

  @override
  State<SearchHomePage> createState() => _SearchHomePageState();
}

class _SearchHomePageState extends State<SearchHomePage>
    with TickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _staggerController;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _searchBarAnimation;
  late Animation<double> _searchBarScaleAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _appBarAnimation;
  late Animation<double> _quickActionsAnimation;
  late Animation<double> _weatherCardAnimation;
  late Animation<double> _newsCardAnimation;
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListener();
    _startStaggerAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );

    _searchBarAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.4)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _searchBarScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _contentFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.3)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
          ),
        );

    _appBarAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _quickActionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _weatherCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _newsCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  void _setupFocusListener() {
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && !_isSearchFocused) {
        _isSearchFocused = true;
        _animationController.forward();
      } else if (!_searchFocusNode.hasFocus && _isSearchFocused) {
        _isSearchFocused = false;
        _animationController.reverse();
      }
    });
  }

  void _startStaggerAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    _searchFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _handleSearch(String value) {
    if (value.isEmpty) return;

    final urlPattern = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w]{2,}(\/\S*)?$');
    final isUrl = urlPattern.hasMatch(value);

    if (isUrl) {
      final formattedUrl = value.startsWith("http") ? value : "https://$value";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InAppBrowserPage(url: formattedUrl)),
      );
    } else {
      final repository = RepositoryProvider.of<SearchRepository>(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SearchResultsPage(query: value, repository: repository),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFFAFBFC),
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(isDark, _animationController, _appBarAnimation),
          SliverToBoxAdapter(
            child: buildBody(
              size,
              isDark,
              _animationController,
              _logoAnimation,
              _searchBarAnimation,
              _searchBarScaleAnimation,
              _contentSlideAnimation,
              _contentFadeAnimation,
              _quickActionsAnimation,
              _weatherCardAnimation,
              _newsCardAnimation,
              controller,
              _searchFocusNode,
              _handleSearch,
            ),
          ),
        ],
      ),
    );
  }
}
