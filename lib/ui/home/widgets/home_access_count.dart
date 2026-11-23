import 'package:material_ui/material_ui.dart';
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
          _BadgeTabBarCount(
            tabs: const ["Hinos", "Litania", "Invocação", "Salmos"],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _AccessCountList<HymnsNumber>(
                  key: const ValueKey("hymn_count"),
                  fetch: (s) => HymnNumberService().findMostAccessedBySection(s),
                  titleFn: (item) => "${item.num} - ${item.label}",
                  sectionFn: (item) => item.hymnsGroup.name,
                  countFn: (item) => item.accessCount,
                  onTapFn: (item) => openSheet(context, HymnContentBottomSheet(hymnNumber: item)),
                ),
                _AccessCountList<LitanyTitle>(
                  key: const ValueKey("litany_count"),
                  fetch: (s) => LitanyService().findMostAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  countFn: (item) => item.accessCount,
                  onTapFn: (item) => openSheet(context, LitanyContentBottomSheet(litany: item)),
                ),
                _AccessCountList<InvocationTitle>(
                  key: const ValueKey("invocation_count"),
                  fetch: (s) => InvocationService().findMostAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  countFn: (item) => item.accessCount,
                  onTapFn: (item) => openSheet(context, InvocationContentBottomSheet(invocation: item)),
                ),
                _AccessCountList<PsalmsTitle>(
                  key: const ValueKey("psalm_count"),
                  fetch: (s) => PsalmService().findMostAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  countFn: (item) => item.accessCount,
                  onTapFn: (item) => openSheet(context, PsalmContentBottomSheet(psalm: item)),
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
  final Future<Result<List<T>>> Function(Section) fetch;
  final String Function(T) titleFn;
  final String Function(T) sectionFn;
  final int Function(T) countFn;
  final void Function(T) onTapFn;

  const _AccessCountList({
    super.key,
    required this.fetch,
    required this.titleFn,
    required this.sectionFn,
    required this.countFn,
    required this.onTapFn,
  });

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return FutureBuilder<Result<List<T>>>(
      key: ValueKey('count_${section.id}'),
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = data[index];
                final count = countFn(item);
                return _CountCard(
                  number: index + 1,
                  title: titleFn(item),
                  section: sectionFn(item),
                  count: count,
                  isFirst: index == 0,
                  onTap: () => onTapFn(item),
                );
              },
            );
          },
          error: (e) => Center(child: Text('Erro: $e')),
        ) ?? const SizedBox.shrink();
      },
    );
  }
}

class _BadgeTabBarCount extends StatelessWidget {
  final List<String> tabs;

  const _BadgeTabBarCount({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final int number;
  final String title;
  final String section;
  final int count;
  final bool isFirst;
  final VoidCallback? onTap;

  const _CountCard({
    required this.number,
    required this.title,
    required this.section,
    required this.count,
    this.isFirst = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isFirst ? AppColors.primary.withAlpha(60) : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isFirst ? AppColors.primary : AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$number",
              style: TextStyle(
                color: isFirst ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  section,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Acessos",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isFirst ? AppColors.primary : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
