import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class LitanySearch extends StatefulWidget {
  final String query;

  const LitanySearch({super.key, required this.query});

  @override
  State<LitanySearch> createState() => _LitanySearchState();
}

class _LitanySearchState extends State<LitanySearch> {
  final LitanySearchViewModel _viewModel = LitanySearchViewModel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<LitanyTitle>(
      keyValue: ValueKey('${widget.query}_${section.id}'),
      future: _viewModel.search(widget.query, section),
      builder: (context, items) => SectionListView<LitanyTitle>(
        items: items,
        itemBuilder: (context, item, _) => LitanyListTile(
          litany: item,
          highlightQuery: widget.query,
        ),
      ),
    );
  }
}
