import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class InvocationTabFavourite extends StatefulWidget {
  const InvocationTabFavourite({super.key});

  @override
  State<InvocationTabFavourite> createState() => _InvocationTabFavouriteState();
}

class _InvocationTabFavouriteState extends State<InvocationTabFavourite> {
  late final InvocationFavouritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InvocationFavouritesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return SectionFutureBuilder<InvocationTitle>(
      keyValue: section,
      future: _viewModel.findFavouritesBySection(section),
      builder: (context, items) => SectionListView<InvocationTitle>(
        items: items,
        itemBuilder: (context, invocation, _) => InvocationListTile(invocation: invocation),
      ),
    );
  }
}
