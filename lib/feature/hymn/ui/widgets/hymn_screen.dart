import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class HymnScreen extends StatefulWidget {
  const HymnScreen({super.key});
  @override
  State<HymnScreen> createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  child: HymnSearch(query: query),
                );
              }
              return const Expanded(
                child: ContentTabScreen(
                  normalTab: HymnTab(),
                  additionalTab: HymnTabAdditional(),
                  favouritesTab: HymnTabFavourite(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
