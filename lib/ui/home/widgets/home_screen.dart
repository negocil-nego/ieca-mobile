import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            const HomeDayOfSuggestHymn(),
            const HomeCardTotal(),
            const HomeInfoData(),
          ],
        ),
      ),
    );
  }
}