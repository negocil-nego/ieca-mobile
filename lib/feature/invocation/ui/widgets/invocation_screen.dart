import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class InvocationScreen extends StatelessWidget {
  const InvocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPadding.container,
      child: ContentTabScreen(
        normalTab: InvocationTab(),
        favouritesTab: InvocationTabFavourite(),
      ),
    );
  }
}
