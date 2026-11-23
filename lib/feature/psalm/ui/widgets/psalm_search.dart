import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class PsalmsSearch extends StatefulWidget {
  final String query;

  const PsalmsSearch({super.key, required this.query});

  @override
  State<PsalmsSearch> createState() => _PsalmsSearchState();
}

class _PsalmsSearchState extends State<PsalmsSearch> {
  final PsalmSearchViewModel _viewModel = PsalmSearchViewModel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<PsalmsTitle>(
      keyValue: ValueKey('${widget.query}_${section.id}'),
      future: _viewModel.search(widget.query, section),
      builder: (context, items) => SectionListView<PsalmsTitle>(
        items: items,
        itemBuilder: (context, item, _) => PsalmListTile(
          psalm: item,
          highlightQuery: widget.query,
        ),
      ),
    );
  }
}
