import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HomeCardTotal extends StatelessWidget {
  const HomeCardTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;

    return FutureBuilder(
      future: Future.wait([
        InvocationService().countBySection(section),
        LitanyService().countBySection(section),
        HymnNumberService().countBySection(section),
        PsalmService().countBySection(section),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));

        final data = snapshot.data as List<int>;

        final items = [
          _SummaryItem(
            label: 'Hinos',
            count: data[2],
            onTap: () => context.read<NavTabProvider>().navToHymn(),
          ),
          _SummaryItem(
            label: 'Litanias',
            count: data[1],
            onTap: () => context.read<NavTabProvider>().navToLitany(),
          ),
          _SummaryItem(
            label: 'Salmos',
            count: data[3],
            onTap: () => context.read<NavTabProvider>().navToPsalm(),
          ),
          _SummaryItem(
            label: 'Invocação',
            count: data[0],
            onTap: () => context.read<NavTabProvider>().navToInvocation(),
          ),
        ];

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          children: items.map((item) => _SummaryCard(item: item)).toList(),
        );
      },
    );
  }
}

class _SummaryItem {
  final String label;
  final int count;
  final Function()? onTap;

  _SummaryItem({required this.label, required this.count, required this.onTap});
}

class _SummaryCard extends StatelessWidget {
  final _SummaryItem item;

  const _SummaryCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final icons = {
      'Hinos': Icons.music_note,
      'Litanias': Icons.description,
      'Salmos': Icons.book,
      'Invocação': Icons.mic,
    };

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                icons[item.label],
                color: Colors.pinkAccent,
                size: 20,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.count}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}