import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HomeAccessCountWidget extends StatelessWidget {
  const HomeAccessCountWidget({super.key});

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
                _AccessCountList<HymnsNumber>(
                  label: "Hinos",
                  fetch: (s) => HymnNumberService().findMostAccessedBySection(s),
                  titleBuilder: (item) => "${item.num} - ${item.label}",
                  countBuilder: (item) => "${item.accessCount}",
                ),
                _AccessCountList<LitanyTitle>(
                  label: "Litania",
                  fetch: (s) => LitanyService().findMostAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                  countBuilder: (item) => "${item.accessCount}",
                ),
                _AccessCountList<InvocationTitle>(
                  label: "Invocação",
                  fetch: (s) => InvocationService().findMostAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                  countBuilder: (item) => "${item.accessCount}",
                ),
                _AccessCountList<PsalmsTitle>(
                  label: "Salmos",
                  fetch: (s) => PsalmService().findMostAccessedBySection(s),
                  titleBuilder: (item) => "${item.position} - ${item.name}",
                  countBuilder: (item) => "${item.accessCount}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessCountList<T> extends StatelessWidget {
  final String label;
  final Future<Result<List<T>>> Function(Section) fetch;
  final String Function(T) titleBuilder;
  final String Function(T) countBuilder;

  const _AccessCountList({
    required this.label,
    required this.fetch,
    required this.titleBuilder,
    required this.countBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return FutureBuilder<Result<List<T>>>(
      key: ValueKey('${label}_most_${section.id}'),
      future: fetch(section),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = snapshot.data;
        return result?.when(
              ok: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text("Nenhum acesso."));
                }
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      dense: true,
                      title: Text(titleBuilder(item), style: const TextStyle(fontSize: 13)),
                      trailing: Text(
                        countBuilder(item),
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
