import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

void openSheet(BuildContext context, Widget sheet) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxWidth: double.infinity,
      maxHeight: MediaQuery.of(context).size.height,
    ),
    builder: (_) => sheet,
  );
}

class HomeLastAccessedWidget extends StatelessWidget {
  const HomeLastAccessedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          _BadgeTabBar(
            tabs: const ["Hinos", "Litania", "Invocação", "Salmos"],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _LastAccessedList<HymnsNumber>(
                  key: const ValueKey("hymn_last"),
                  fetch: (s) => HymnNumberService().findLastAccessedBySection(s),
                  titleFn: (item) => "${item.num} - ${item.label}",
                  sectionFn: (item) => item.hymnsGroup.name,
                  dateFn: (item) => item.lastAccessedAt,
                  onTapFn: (item) => openSheet(context, HymnContentBottomSheet(hymnNumber: item)),
                ),
                _LastAccessedList<LitanyTitle>(
                  key: const ValueKey("litany_last"),
                  fetch: (s) => LitanyService().findLastAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  dateFn: (item) => item.lastAccessedAt,
                  onTapFn: (item) => openSheet(context, LitanyContentBottomSheet(litany: item)),
                ),
                _LastAccessedList<InvocationTitle>(
                  key: const ValueKey("invocation_last"),
                  fetch: (s) => InvocationService().findLastAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  dateFn: (item) => item.lastAccessedAt,
                  onTapFn: (item) => openSheet(context, InvocationContentBottomSheet(invocation: item)),
                ),
                _LastAccessedList<PsalmsTitle>(
                  key: const ValueKey("psalm_last"),
                  fetch: (s) => PsalmService().findLastAccessedBySection(s),
                  titleFn: (item) => "${item.position} - ${item.name}",
                  sectionFn: (item) => item.section.name,
                  dateFn: (item) => item.lastAccessedAt,
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

class _LastAccessedList<T> extends StatelessWidget {
  final Future<Result<List<T>>> Function(Section) fetch;
  final String Function(T) titleFn;
  final String Function(T) sectionFn;
  final DateTime? Function(T) dateFn;
  final void Function(T) onTapFn;

  const _LastAccessedList({
    super.key,
    required this.fetch,
    required this.titleFn,
    required this.sectionFn,
    required this.dateFn,
    required this.onTapFn,
  });

  String _fmt(DateTime? dt) {
    if (dt == null) return "";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final section = context.watch<SectionProvider>().section;
    return FutureBuilder<Result<List<T>>>(
      key: ValueKey('last_${section.id}'),
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: data.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = data[index];
                return _InfoCard(
                  number: index + 1,
                  title: titleFn(item),
                  section: sectionFn(item),
                  trailing: _fmt(dateFn(item)),
                  trailingLabel: "Último acesso",
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

class _BadgeTabBar extends StatelessWidget {
  final List<String> tabs;

  const _BadgeTabBar({required this.tabs});

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

class _InfoCard extends StatelessWidget {
  final int number;
  final String title;
  final String section;
  final String trailing;
  final String trailingLabel;
  final bool isFirst;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.number,
    required this.title,
    required this.section,
    required this.trailing,
    required this.trailingLabel,
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
                trailingLabel,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trailing,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
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
