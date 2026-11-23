import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HymnSearch extends StatefulWidget {
  final String query;

  const HymnSearch({super.key, required this.query});

  @override
  State<HymnSearch> createState() => _HymnSearchState();
}

class _HymnSearchState extends State<HymnSearch> {
  final HymnScreenViewmodel _viewModel = HymnScreenViewmodel();

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return FutureBuilder<Result<List<HymnsContent>>>(
      key: ValueKey('${widget.query}_${section.id}'),
      future: _viewModel.search(widget.query, section),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = snapshot.data;
        return result?.when(
              ok: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text("Nenhum hino encontrado."));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(
                        "${item.hymnsNumber.num} - ${item.hymnsNumber.label}",
                      ),
                      subtitle: _buildHighlightedText(
                        StringUtil.replaceContent(item.content),
                        widget.query,
                      ),
                      onTap: () {
                        _viewModel.updateLastAccessed(item.hymnsNumber.id);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          constraints: BoxConstraints(
                            maxWidth: double.infinity,
                            maxHeight: MediaQuery.of(context).size.height,
                          ),
                          builder: (context) => HymnContentBottomSheet(
                            hymnNumber: item.hymnsNumber,
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (e) => Center(child: Text('Erro: $e')),
            ) ??
            const SizedBox.shrink();
      },
    );
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(text, maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();
    final spans = <InlineSpan>[];
    int start = 0;
    int idx = lower.indexOf(qLower, start);
    while (idx != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = idx + query.length;
      idx = lower.indexOf(qLower, start);
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black54, fontSize: 12),
        children: spans,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
