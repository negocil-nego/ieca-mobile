import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class ContentTabScreen extends StatelessWidget {
  final Widget normalTab;
  final Widget favouritesTab;

  const ContentTabScreen({
    super.key,
    required this.normalTab,
    required this.favouritesTab,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: "Normal"),
              Tab(text: "Favoritos"),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                normalTab,
                favouritesTab,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
