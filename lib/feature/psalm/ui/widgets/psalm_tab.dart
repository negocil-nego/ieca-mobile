import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class PsalmsTab extends StatefulWidget {
  const PsalmsTab({super.key});

  @override
  State<PsalmsTab> createState() => _PsalmsTabState();
}

class _PsalmsTabState extends State<PsalmsTab> {
  late final PsalmViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PsalmViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<PsalmsTitle>(
      keyValue: section,
      future: _viewModel.findBySection(section),
      builder: (context, items) => SectionListView<PsalmsTitle>(
        items: items,
        itemBuilder: (context, psalm, _) => PsalmListTile(psalm: psalm),
      ),
    );
  }
}
