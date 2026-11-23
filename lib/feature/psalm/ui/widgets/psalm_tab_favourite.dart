import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class PsalmsTabFavourite extends StatefulWidget {
  const PsalmsTabFavourite({super.key});

  @override
  State<PsalmsTabFavourite> createState() => _PsalmsTabFavouriteState();
}

class _PsalmsTabFavouriteState extends State<PsalmsTabFavourite> {
  late final PsalmFavouritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PsalmFavouritesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<PsalmsTitle>(
      keyValue: section,
      future: _viewModel.findFavouritesBySection(section),
      builder: (context, items) => SectionListView<PsalmsTitle>(
        items: items,
        itemBuilder: (context, psalm, _) => PsalmListTile(psalm: psalm),
      ),
    );
  }
}
