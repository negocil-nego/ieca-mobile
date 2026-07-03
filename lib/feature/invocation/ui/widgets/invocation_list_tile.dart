import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class InvocationListTile extends StatefulWidget {
  final InvocationTitle invocation;

  const InvocationListTile({super.key, required this.invocation});

  @override
  State<InvocationListTile> createState() => _InvocationListTileState();
}

class _InvocationListTileState extends State<InvocationListTile> {
  final _content = ValueNotifier<InvocationContent>(InvocationContentMapper.empty());
  final _viewModel = InvocationContentBottomSheetViewModel();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.invocation.isFavorite;
    _init();
  }

  Future<void> _init() async {
    final result = await _viewModel.findContentFist(widget.invocation);
    if (!mounted) return;
    _content.value = result.when(
      ok: (value) => value,
      error: (_) => InvocationContentMapper.empty(),
    );
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _onPressed() {
    _viewModel.updateLastAccessed(widget.invocation.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => InvocationContentBottomSheet(invocation: widget.invocation),
    );
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.invocation.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<InvocationContent>(
      valueListenable: _content,
      builder: (context, value, _) => PageListTile(
        number: widget.invocation.position,
        title: widget.invocation.name,
        subtitle: StringUtil.short(value.content),
        isFavorite: _isFavorite,
        onPressed: _onPressed,
        onFavorite: _onFavorite,
      ),
    );
  }
}
