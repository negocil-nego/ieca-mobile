import 'package:material_ui/material_ui.dart';
import 'package:hugeicons/hugeicons.dart';

final class AppIcon {
  AppIcon._();

  // -- IconData constants (Material Icons) --
  static const close = Icons.close;
  static const error = Icons.error_outline;
  static const swap = Icons.swap_horiz;
  static const search = Icons.search;
  static const clear = Icons.clear;
  static const menu = Icons.menu;
  static const privacy = Icons.privacy_tip_outlined;
  static const fileDescription = Icons.description_outlined;
  static const info = Icons.info_outline;
  static const arrowBack = Icons.arrow_back;
  static const church = Icons.church_outlined;
  static const musicNote = Icons.music_note;
  static const star = Icons.star;
  static const menuBook = Icons.menu_book;
  static const description = Icons.description;
  static const book = Icons.book;
  static const mic = Icons.mic;
  static const favorite = Icons.favorite;
  static const favoriteBorder = Icons.favorite_border;
  static const chevronLeft = Icons.chevron_left;
  static const chevronRight = Icons.chevron_right;
  static const share = Icons.share;
  static const copy = Icons.copy;
  static const textDecrease = Icons.text_decrease;
  static const textIncrease = Icons.text_increase;
  static const person = Icons.person_outline;
  static const phone = Icons.phone_outlined;
  static const email = Icons.email_outlined;
  static const place = Icons.place_outlined;
  static const report = Icons.flag_outlined;

  // -- HugeIcon widget factories (for navigation tabs) --
  static HugeIcon homeIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedMenuSquare,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon invocationIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedVolumeHigh,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon litanyIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedFile02,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon hymnIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedMusic3,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon psalmIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedBook04,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon heartIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedHeartAdd,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon arrowRightIcon({double size = 16, Color? color, double strokeWidth = 1}) => HugeIcon(
    icon: HugeIcons.strokeRoundedArrowRight01,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
  );

  static HugeIcon noResultsIcon({double size = 90, Color? color}) => HugeIcon(
    icon: HugeIcons.strokeRoundedSearchRemove,
    size: size,
    strokeWidth: 1,
    color: color ?? const Color(0xFFE91E63),
  );
}
