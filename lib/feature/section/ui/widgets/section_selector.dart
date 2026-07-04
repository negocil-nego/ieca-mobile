import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:provider/provider.dart';

class SectionSelector extends StatefulWidget {
  final SectionViewModel? viewModel;

  const SectionSelector({
    super.key,
    this.viewModel
  });

  @override
  State<SectionSelector> createState() => _SectionSelectorState();
}

class _SectionSelectorState extends State<SectionSelector> {
  late final SectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? SectionViewModel();
  }

  void _showSectionPicker(BuildContext context, List<Section> sections) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Seção", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "Selecione a secção do hinário",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(AppIcon.close, size: 20),
                onPressed: () => Navigator.pop(ctx),
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        children: sections.map((section) => SimpleDialogOption(
          onPressed: () {
            Navigator.pop(ctx);
            this.context.read<SectionProvider>().updateDefault(section);
          },
          child: Text(section.name),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Section>>(
      future: _viewModel.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(width: 40, child: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return const SizedBox(width: 40, child: Icon(AppIcon.error, color: Colors.grey));
        }

        final sections = snapshot.data ?? [];

        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        return TextButton.icon(
          onPressed: () => _showSectionPicker(context, sections),
          icon: const Icon(AppIcon.swap, size: 18),
          label: const Text("Seção", style: TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    );
  }
}