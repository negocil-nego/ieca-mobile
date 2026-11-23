import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class HymnTabAdditional extends StatefulWidget {
  const HymnTabAdditional({super.key});

  @override
  State<HymnTabAdditional> createState() => _HymnTabAdditionalState();
}

class _HymnTabAdditionalState extends State<HymnTabAdditional> {
  final HymGroupCategoryViewModel _viewModel = HymGroupCategoryViewModel();
  final SectionService _sectionService = SectionService();

  Future<Result<List<HymnsGroup>>> _fetch() async {
    final sectionResult = await _sectionService.findByCode("pt");
    return sectionResult.when(
      ok: (section) => _viewModel.findAdditionalBySection(section),
      error: (e) => Result.error(e),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionFutureBuilder<HymnsGroup>(
      keyValue: const ValueKey('hymn_additional_tab'),
      future: _fetch(),
      builder: (context, groups) {
        if (groups.isEmpty) return const SizedBox.shrink();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groups.map((group) {
              return HymnNumberGrid(hymnsGroup: group, showAdditionalOnly: true);
            }).toList(),
          ),
        );
      },
    );
  }
}
