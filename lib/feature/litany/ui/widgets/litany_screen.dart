import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class LitanyScreen extends StatelessWidget {
  const LitanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPadding.container,
      child: ContentTabScreen(
        normalTab: LitanyTab(),
        favouritesTab: LitanyTabFavourite(),
      ),
    );
  }
}
