import 'package:flutter/foundation.dart';
import 'package:mobile/_import.dart';

class NavTabProvider  with ChangeNotifier {
  final _pageview = PageViewModel();
  int _navIndex = 0;

  int get navIndex => _navIndex;

  void _getIndexNavItem(String nav) {
    int idx = _pageview.navItems.indexWhere((item) => item.nav == nav);
    if(idx >= 0) {
      _navIndex = idx;
      notifyListeners();
    }
  }

  void navToHome() =>_getIndexNavItem(NavItemEnum.home);
  void navToHymn() =>_getIndexNavItem(NavItemEnum.hymn);
  void navToPsalm() =>_getIndexNavItem(NavItemEnum.psalms);
  void navToLitany() =>_getIndexNavItem(NavItemEnum.litany);
  void navToInvocation() =>_getIndexNavItem(NavItemEnum.invocation);
}
