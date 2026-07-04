import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class PageViewApp extends StatefulWidget {
  const PageViewApp({super.key});

  @override
  State<PageViewApp> createState() => _PageViewAppState();
}

class _PageViewAppState extends State<PageViewApp> {
  final PageViewModel _pageViewModel = PageViewModel();
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  late final List<Widget> _screens = _pageViewModel.navItems.map((item) => Scaffold(
    appBar: item.appBar,
    body: item.screen,
  )).toList();

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return List.generate(_pageViewModel.navItems.length, (index) {
      final item = _pageViewModel.navItems[index];
      return PersistentBottomNavBarItem(
        icon: item.navigation.icon,
        title: item.navigation.label,
        activeColorPrimary: Colors.pinkAccent,
        inactiveColorPrimary: Colors.grey,
        activeColorSecondary: Colors.pinkAccent,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<NavTabProvider>().addListener(_onNavChanged);
  }

  void _onNavChanged() {
    final navIndex = context.read<NavTabProvider>().navIndex;
    if (_controller.index != navIndex) {
      _controller.jumpToTab(navIndex);
    }
  }

  @override
  void dispose() {
    context.read<NavTabProvider>().removeListener(_onNavChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style15,
      backgroundColor: Colors.white,
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.grey,
      ),
    );
  }
}