import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class LitanyTabFavourite extends StatefulWidget {
  const LitanyTabFavourite({super.key});

  @override
  State<LitanyTabFavourite> createState() => _LitanyTabFavouriteState();
}

class _LitanyTabFavouriteState extends State<LitanyTabFavourite> {
  late final LitanyFavouritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LitanyFavouritesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<LitanyTitle>(
      keyValue: section,
      future: _viewModel.findFavouritesBySection(section),
      builder: (context, items) => SectionListView<LitanyTitle>(
        items: items,
        itemBuilder: (context, litany, _) => LitanyListTile(litany: litany),
      ),
    );
  }
}
