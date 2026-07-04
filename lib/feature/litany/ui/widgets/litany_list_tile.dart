import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class LitanyListTile extends StatefulWidget {
  final LitanyTitle litany;
  final String? highlightQuery;

  const LitanyListTile({super.key, required this.litany, this.highlightQuery});

  @override
  State<LitanyListTile> createState() => _LitanyListTileState();
}

class _LitanyListTileState extends State<LitanyListTile> {
  final _content = ValueNotifier<LitanyContent>(LitanyContentMapper.empty());
  final _viewModel = LitanyContentBottomSheetViewModel();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.litany.isFavorite;
    _init();
  }

  Future<void> _init() async {
    final result = await _viewModel.findContentFist(widget.litany);
    if (!mounted) return;
    _content.value = result.when(
      ok: (value) => value,
      error: (_) => LitanyContentMapper.empty(),
    );
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _onPressed() {
    _viewModel.updateLastAccessed(widget.litany.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => LitanyContentBottomSheet(litany: widget.litany),
    );
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.litany.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _content,
      builder: (context, value, _) {
        return PageListTile(
          number: widget.litany.position,
          title: widget.litany.name,
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
