import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class InvocationTab extends StatefulWidget {
  const InvocationTab({super.key});

  @override
  State<InvocationTab> createState() => _InvocationTabState();
}

class _InvocationTabState extends State<InvocationTab> {
  late final InvocationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InvocationViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<InvocationTitle>(
      keyValue: section,
      future: _viewModel.findBySection(section),
      builder: (context, items) => SectionListView<InvocationTitle>(
        items: items,
        itemBuilder: (context, invocation, _) => InvocationListTile(invocation: invocation),
      ),
    );
  }
}
