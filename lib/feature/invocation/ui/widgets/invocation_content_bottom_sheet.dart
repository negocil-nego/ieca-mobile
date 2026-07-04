import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class InvocationContentBottomSheet extends StatefulWidget {
  final InvocationTitle invocation;

  const InvocationContentBottomSheet({
    super.key,
    required this.invocation,
  });

  @override
  State<InvocationContentBottomSheet> createState() => _InvocationContentBottomSheetState();
}

class _InvocationContentBottomSheetState extends State<InvocationContentBottomSheet> with FontSizeAdjustment {
  late final InvocationContentBottomSheetViewModel _viewModel;
  late InvocationTitle _currentItem;
  late bool _isFavorite;
  bool _hasNext = false;
  bool _hasPrevious = false;

  @override
  void initState() {
    super.initState();
    _viewModel = InvocationContentBottomSheetViewModel();
    _currentItem = widget.invocation;
    _isFavorite = widget.invocation.isFavorite;
    _checkNav();
  }

  void _checkNav() async {
    final next = await _viewModel.findNext(_currentItem);
    final prev = await _viewModel.findPrevious(_currentItem);
    if (!mounted) return;
    setState(() {
      _hasNext = next.when(ok: (v) => v != null, error: (_) => false);
      _hasPrevious = prev.when(ok: (v) => v != null, error: (_) => false);
    });
  }

  void _goNext() async {
    final result = await _viewModel.findNext(_currentItem);
    result.when(ok: (item) {
      if (item != null && mounted) {
        setState(() {
          _currentItem = item;
          _isFavorite = item.isFavorite;
        });
        _checkNav();
      }
    }, error: (_) {});
  }

  void _goPrevious() async {
    final result = await _viewModel.findPrevious(_currentItem);
    result.when(ok: (item) {
      if (item != null && mounted) {
        setState(() {
          _currentItem = item;
          _isFavorite = item.isFavorite;
        });
        _checkNav();
      }
    }, error: (_) {});
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(_currentItem.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ContentBottomSheet<InvocationContent>(
              key: ValueKey(_currentItem.id),
              title: _currentItem.name,
              future: _viewModel.findContentByInvocation(_currentItem),
              actions: [
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFE61E62),
                  ),
                  onPressed: _onFavorite,
                ),
                ...fontActions,
              ],
              itemBuilder: (context, item, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.books != null && item.books!.isNotEmpty)
                        Text(
                          item.books!,
                          style: TextStyle(
                            fontSize: currentFontSize * 0.8,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: currentFontSize,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ContentNavButtons(
            hasPrevious: _hasPrevious,
            hasNext: _hasNext,
            onPrevious: _goPrevious,
            onNext: _goNext,
          ),
        ],
      ),
    );
  }
}
