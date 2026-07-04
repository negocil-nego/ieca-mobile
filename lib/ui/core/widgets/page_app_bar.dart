import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;

  const PageAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 30,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Image.asset(AppAsset.logo),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
      actions: [
        const SectionSelector(),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ],
    );
  }
}
