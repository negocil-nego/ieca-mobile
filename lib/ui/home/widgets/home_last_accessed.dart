import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HomeLastAccessedWidget extends StatelessWidget {
  const HomeLastAccessedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: const Color(0xFFE61E62),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFE61E62),
            isScrollable: true,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Hinos"),
              Tab(text: "Litania"),
              Tab(text: "Invocação"),
              Tab(text: "Salmos"),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                _LastAccessedList<HymnsNumber>(
                  label: "Hinos",
                  fetch: (s) => HymnNumberService().findLastAccessedBySection(s),
                  titleBuilder: (item) => "${item.num} - ${item.label}",
                ),
                _LastAccessedList<LitanyTitle>(
                  label: "Litania",
                  fetch: (s) => LitanyService().findLastAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                ),
                _LastAccessedList<InvocationTitle>(
                  label: "Invocação",
                  fetch: (s) => InvocationService().findLastAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                ),
                _LastAccessedList<PsalmsTitle>(
                  label: "Salmos",
                  fetch: (s) => PsalmService().findLastAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LastAccessedList<T> extends StatelessWidget {
  final String label;
  final Future<Result<List<T>>> Function(Section) fetch;
  final String Function(T) titleBuilder;

  const _LastAccessedList({
    required this.label,
    required this.fetch,
    required this.titleBuilder,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return "";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  DateTime? _extractDate(T item) {
    if (item is HymnsNumber) return item.lastAccessedAt;
    if (item is InvocationTitle) return item.lastAccessedAt;
    if (item is LitanyTitle) return item.lastAccessedAt;
    if (item is PsalmsTitle) return item.lastAccessedAt;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return FutureBuilder<Result<List<T>>>(
      key: ValueKey('${label}_last_${section.id}'),
      future: fetch(section),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = snapshot.data;
        return result?.when(
              ok: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text("Nenhum acesso recente."));
                }
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final date = _extractDate(item);
                    return ListTile(
                      dense: true,
                      title: Text(titleBuilder(item), style: const TextStyle(fontSize: 13)),
                      trailing: Text(
                        _formatDate(date),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
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
}
