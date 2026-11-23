import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class InvocationScreen extends StatefulWidget {
  const InvocationScreen({super.key});
  @override
  State<InvocationScreen> createState() => _InvocationScreenState();
}

class _InvocationScreenState extends State<InvocationScreen> {
  final TextEditingController _search = TextEditingController();
  final ValueNotifier<String?> _query = ValueNotifier(null);

  void _onSearchReset() {
    _search.clear();
    _query.value = null;
  }

  void _onSearchChanged(String value) {
    _query.value = value.isEmpty ? null : value;
  }

  @override
  void dispose() {
    _search.dispose();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.container,
      child: Column(
        children: [
          SearchInput(
            controller: _search,
            onReset: _onSearchReset,
            onChanged: _onSearchChanged,
          ),
          ValueListenableBuilder<String?>(
            valueListenable: _query,
            builder: (context, query, child) {
              if (query != null) {
                return Expanded(
                  child: InvocationSearch(query: query),
                );
              }
              return const Expanded(
                child: ContentTabScreen(
                  normalTab: InvocationTab(),
                  favouritesTab: InvocationTabFavourite(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
