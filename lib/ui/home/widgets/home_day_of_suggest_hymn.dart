import 'dart:async';
import 'dart:math';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class HomeDayOfSuggestHymn extends StatefulWidget {
  const HomeDayOfSuggestHymn({super.key});

  @override
  State<HomeDayOfSuggestHymn> createState() => _HomeDayOfSuggestHymnState();
}

class _HomeDayOfSuggestHymnState extends State<HomeDayOfSuggestHymn> {
  final _pageController = PageController(viewportFraction: 0.9);
  final _itemsNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _advance());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _itemsNotifier.dispose();
    super.dispose();
  }

  void _advance() {
    final items = _itemsNotifier.value;
    if (items.length < 2) return;
    final current = _pageController.page!.round();
    if (current >= items.length - 1) {
      _pageController.jumpToPage(0);
    } else {
      _pageController.animateToPage(current + 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  Future<void> _load() async {
    final section = context.read<SectionProvider>().section;
    final now = DateTime.now();
    final seed = now.difference(DateTime(now.year, 1, 1)).inDays;

    final results = await Future.wait([
      _pickHymn(section, seed),
      _pickLitany(section, seed),
      _pickInvocation(section, seed),
      _pickPsalm(section, seed),
    ]);

    if (!mounted) return;
    final items = results.where((r) => r != null).cast<Map<String, dynamic>>().toList();
    if (items.isEmpty) return;
    _itemsNotifier.value = items;
  }

  Future<Map<String, dynamic>?> _pickHymn(Section section, int seed) async {
    final groups = await HymnGroupService().findBySection(section);
    final groupList = groups.when(ok: (d) => d, error: (_) => <HymnsGroup>[]);
    if (groupList.isEmpty) return null;
    final group = groupList[_seeded(seed, 0, groupList.length)];
    final numbers = await HymnNumberService().findByHymnsGroup(group);
    final numList = numbers.when(ok: (d) => d, error: (_) => <HymnsNumber>[]);
    if (numList.isEmpty) return null;
    final number = numList[_seeded(seed, 1, numList.length)];
    final content = await HymnContentService().findByHymnNumber(number);
    final desc = content.when(
      ok: (d) => d.isNotEmpty ? d.first.content : '',
      error: (_) => '',
    );
    return {
      "label": "HINO DO MÊS",
      "title": "${number.num} - ${number.label}",
      "desc": desc.length > 60 ? '${desc.substring(0, 60)}…' : desc,
      "icon": AppIcon.musicNote,
    };
  }

  Future<Map<String, dynamic>?> _pickLitany(Section section, int seed) async {
    final items = await LitanyService().findBySection(section);
    final list = items.when(ok: (d) => d, error: (_) => <LitanyTitle>[]);
    if (list.isEmpty) return null;
    final item = list[_seeded(seed, 2, list.length)];
    final content = await LitanyService().findContentFist(item);
    final desc = content.when(ok: (d) => d.content, error: (_) => '');
    return {
      "label": "LITANIA",
      "title": item.name,
      "desc": desc.length > 60 ? '${desc.substring(0, 60)}…' : desc,
      "icon": AppIcon.menuBook,
    };
  }

  Future<Map<String, dynamic>?> _pickInvocation(Section section, int seed) async {
    final items = await InvocationService().findBySection(section);
    final list = items.when(ok: (d) => d, error: (_) => <InvocationTitle>[]);
    if (list.isEmpty) return null;
    final item = list[_seeded(seed, 3, list.length)];
    final content = await InvocationService().findContentFist(item);
    final desc = content.when(ok: (d) => d.content, error: (_) => '');
    return {
      "label": "INVOCAÇÃO",
      "title": item.name,
      "desc": desc.length > 60 ? '${desc.substring(0, 60)}…' : desc,
      "icon": AppIcon.mic,
    };
  }

  Future<Map<String, dynamic>?> _pickPsalm(Section section, int seed) async {
    final items = await PsalmService().findBySection(section);
    final list = items.when(ok: (d) => d, error: (_) => <PsalmsTitle>[]);
    if (list.isEmpty) return null;
    final item = list[_seeded(seed, 4, list.length)];
    final content = await PsalmService().findContentFist(item);
    final desc = content.when(ok: (d) => d.content, error: (_) => '');
    return {
      "label": "SALMO",
      "title": item.name,
      "desc": desc.length > 60 ? '${desc.substring(0, 60)}…' : desc,
      "icon": AppIcon.book,
    };
  }

  int _seeded(int daySeed, int offset, int max) {
    return Random(daySeed * 31 + offset * 7).nextInt(max);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _itemsNotifier,
        builder: (context, items, _) {
        if (items.isEmpty) {
          return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
        }
        final realCount = items.length;
        return SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: realCount,
            pageSnapping: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: index == 0 ? 0 : 16),
                child: _buildCard(items[index]),
              );
            },
          ),
        );
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data["label"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(data["title"], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(data["desc"], style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(data["icon"], size: 70, color: Colors.white.withAlpha(50)),
          ),
        ],
      ),
    );
  }
}
