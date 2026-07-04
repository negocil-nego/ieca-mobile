import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class InvocationSearch extends StatefulWidget {
  final String query;

  const InvocationSearch({super.key, required this.query});

  @override
  State<InvocationSearch> createState() => _InvocationSearchState();
}

class _InvocationSearchState extends State<InvocationSearch> {
  final InvocationSearchViewModel _viewModel = InvocationSearchViewModel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<InvocationTitle>(
      keyValue: ValueKey('${widget.query}_${section.id}'),
      future: _viewModel.search(widget.query, section),
      builder: (context, items) => SectionListView<InvocationTitle>(
        items: items,
        itemBuilder: (context, item, _) => InvocationListTile(
          invocation: item,
          highlightQuery: widget.query,
        ),
      ),
    );
  }
}
