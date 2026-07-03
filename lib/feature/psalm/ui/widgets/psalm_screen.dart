import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class PsalmsScreen extends StatelessWidget {
  const PsalmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPadding.container,
      child: ContentTabScreen(
        normalTab: PsalmsTab(),
        favouritesTab: PsalmsTabFavourite(),
      ),
    );
  }
}
