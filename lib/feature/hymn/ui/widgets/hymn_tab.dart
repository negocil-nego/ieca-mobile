import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HymnTab extends StatefulWidget {
  const HymnTab({super.key});

  @override
  State<HymnTab> createState() => _HymnTabState();
}

class _HymnTabState extends State<HymnTab> {
  final HymGroupCategoryViewModel _viewModel = HymGroupCategoryViewModel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<HymnsGroup>(
      keyValue: ValueKey('hymn_tab_${section.id}'),
      future: _viewModel.findBySection(section),
      builder: (context, groups) {
        if (groups.isEmpty) return const SizedBox.shrink();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groups.map((group) {
              return HymnNumberGrid(hymnsGroup: group);
            }).toList(),
          ),
        );
      },
    );
  }
}
