import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

final class NavItemEnum {
  static const String home = "home";
  static const String hymn = "hymn";
  static const String litany = "litany";
  static const String psalms = "psalms";
  static const String invocation = "invocation";
}

class NavItem {
  final Widget screen;
  final PreferredSizeWidget appBar;
  final NavigationDestination navigation;
  final String nav;

  NavItem({
    required this.screen,
    required this.appBar,
    required this.navigation,
    required this.nav
  });
}

class PageViewModel {
  List<NavItem> get navItems => [
    NavItem(
      nav: NavItemEnum.home,
      screen: const HomeScreen(),
      appBar: const PageAppBar(
        title: "Hinário",
        subtitle: "Encontre o seu louvor favorito",
      ),
      navigation: NavigationDestination(
        icon: AppIcon.homeIcon(),
        label: "Início",
      ),
    ),

    NavItem(
      nav: NavItemEnum.invocation,
      screen: const InvocationScreen(),
      appBar: const PageAppBar(
        title: "Invocações",
        subtitle: "Encontre o seu invocação",
      ),
      navigation: NavigationDestination(
        icon: AppIcon.invocationIcon(),
        label: "Invocação",
      ),
    ),

    NavItem(
      nav: NavItemEnum.hymn,
      screen: const HymnScreen(),
      appBar: const PageAppBar(
        title: "Hinos",
        subtitle: "Encontre o seu louvor",
      ),
      navigation: NavigationDestination(
        icon: AppIcon.hymnIcon(color: Colors.white),
        label: "Hino",
      ),
    ),

    NavItem(
      nav: NavItemEnum.litany,
      screen: const LitanyScreen(),
      appBar: const PageAppBar(
        title: "Litania",
        subtitle: "Encontre o seu litania",
      ),
      navigation: NavigationDestination(
        icon: AppIcon.litanyIcon(),
        label: "Litania",
      ),
    ),

    NavItem(
      nav: NavItemEnum.psalms,
      screen: const PsalmsScreen(),
      appBar: const PageAppBar(
        title: "Salmos",
        subtitle: "Encontre o seu salmo",
      ),
      navigation: NavigationDestination(
        icon: AppIcon.psalmIcon(),
        label: "Salmos",
      ),
    ),
  ];
}
