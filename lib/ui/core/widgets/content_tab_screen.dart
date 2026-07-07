import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class ContentTabScreen extends StatelessWidget {
  final Widget normalTab;
  final Widget favouritesTab;
  final Widget? additionalTab;

  const ContentTabScreen({
    super.key,
    required this.normalTab,
    required this.favouritesTab,
    this.additionalTab,
  });

  @override
  Widget build(BuildContext context) {
    final hasAdditional = additionalTab != null;
    return DefaultTabController(
      length: hasAdditional ? 3 : 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              const Tab(text: "Normal"),
              if (hasAdditional) const Tab(text: "Adicionais"),
              const Tab(text: "Favoritos"),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                normalTab,
                if (hasAdditional) additionalTab!,
                favouritesTab,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
