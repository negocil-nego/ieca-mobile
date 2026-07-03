import 'package:flutter/material.dart';

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
            labelColor: const Color(0xFFE61E62),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFE61E62),
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
