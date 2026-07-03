import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HymnTabFavourite extends StatefulWidget {
  const HymnTabFavourite({super.key});

  @override
  State<HymnTabFavourite> createState() => _HymnTabFavouriteState();
}

class _HymnTabFavouriteState extends State<HymnTabFavourite> {
  final HymGroupCategoryViewModel _groupViewModel = HymGroupCategoryViewModel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          SectionFutureBuilder<HymnsGroup>(
            keyValue: ValueKey('fav_groups_${section.id}'),
            future: _groupViewModel.findFavouriteBySection(section),
            builder: (context, groups) => Column(
              children: groups.map((group) {
                return HymnNumberGrid(
                  hymnsGroup: group,
                  showFavouritesOnly: true,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
