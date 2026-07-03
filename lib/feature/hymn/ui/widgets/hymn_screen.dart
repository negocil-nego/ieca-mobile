import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HymnScreen extends StatefulWidget {
  const HymnScreen({super.key});
  @override
  State<HymnScreen> createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
  final TextEditingController _search = TextEditingController();
  final HymnScreenViewmodel _viewModel = HymnScreenViewmodel();
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);
  Future<Result<List<HymnsContent>>>? _searchResults;

  void _onSearchReset() {
    _searchResults = Future.value(Result.ok([]));
    _search.clear();
    _isSearching.value = false;
  }

  void _onSearchChanged(String value, Section section) {
    if (value.isEmpty) {
      _isSearching.value = false;
    } else {
      _isSearching.value = true;
      _searchResults = _viewModel.search(value, section);
      setState(() {});
    }
  }

  Future<void> _openHymn(HymnsNumber hymnNumber) async {
    await _viewModel.updateLastAccessed(hymnNumber.id);
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => HymnContentBottomSheet(hymnNumber: hymnNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SearchInput(
            controller: _search,
            onReset: _onSearchReset,
            onChanged: (v) => _onSearchChanged(v, section),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isSearching,
            builder: (context, searching, child) {
              if (searching) {
                return Expanded(
                  child: FutureBuilder<Result<List<HymnsContent>>>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final result = snapshot.data;
                      return result?.when(
                            ok: (data) {
                              if (data.isEmpty) {
                                return const Center(
                                  child: Text("Nenhum hino encontrado."),
                                );
                              }
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return ListTile(
                                    title: Text(
                                      "${item.hymnsNumber.num} - ${item.hymnsNumber.label}",
                                    ),
                                    subtitle: Text(
                                      StringUtil.replaceContent(item.content),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () => _openHymn(item.hymnsNumber),
                                  );
                                },
                              );
                            },
                            error: (e) => Center(child: Text('Erro: $e')),
                          ) ??
                          const SizedBox.shrink();
                    },
                  ),
                );
              }
              return const Expanded(
                child: ContentTabScreen(
                  normalTab: HymnTab(),
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
