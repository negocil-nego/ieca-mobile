import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class PsalmListTile extends StatefulWidget {
  final PsalmsTitle psalm;
  final String? highlightQuery;

  const PsalmListTile({super.key, required this.psalm, this.highlightQuery});

  @override
  State<PsalmListTile> createState() => _PsalmListTileState();
}

class _PsalmListTileState extends State<PsalmListTile> {
  final _content = ValueNotifier<PsalmsContent>(PsalmsContentMapper.empty());
  final _viewModel = PsalmContentBottomSheetViewModel();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.psalm.isFavorite;
    _init();
  }

  Future<void> _init() async {
    final result = await _viewModel.findContentFist(widget.psalm);
    if (!mounted) return;
    _content.value = result.when(
      ok: (value) => value,
      error: (_) => PsalmsContentMapper.empty(),
    );
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _onPressed() {
    _viewModel.updateLastAccessed(widget.psalm.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => PsalmContentBottomSheet(psalm: widget.psalm),
    );
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.psalm.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _content,
      builder: (context, value, child) {
        return PageListTile(
          number: widget.psalm.position,
          title: widget.psalm.name,
          subtitle: StringUtil.short(value.content),
          highlightQuery: widget.highlightQuery,
          isFavorite: _isFavorite,
          onPressed: _onPressed,
          onFavorite: _onFavorite,
        );
      }
    );
  }
}
