import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class LitanyTab extends StatefulWidget {
  const LitanyTab({super.key});

  @override
  State<LitanyTab> createState() => _LitanyTabState();
}

class _LitanyTabState extends State<LitanyTab> {
  late final LitanyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LitanyViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<LitanyTitle>(
      keyValue: section,
      future: _viewModel.findBySection(section),
      builder: (context, items) => SectionListView<LitanyTitle>(
        items: items,
        itemBuilder: (context, litany, _) => LitanyListTile(litany: litany),
      ),
    );
  }
}
