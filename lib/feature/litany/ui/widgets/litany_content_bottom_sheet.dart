import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class LitanyContentBottomSheet extends StatefulWidget {
  final LitanyTitle litany;

  const LitanyContentBottomSheet({
    super.key,
    required this.litany,
  });

  @override
  State<LitanyContentBottomSheet> createState() => _LitanyContentBottomSheetState();
}

class _LitanyContentBottomSheetState extends State<LitanyContentBottomSheet>
    with FontSizeAdjustment {
  late final LitanyContentBottomSheetViewModel _viewModel;
  late LitanyTitle _currentItem;
  late bool _isFavorite;
  bool _hasNext = false;
  bool _hasPrevious = false;

  @override
  void initState() {
    super.initState();
    _viewModel = LitanyContentBottomSheetViewModel();
    _currentItem = widget.litany;
    _isFavorite = widget.litany.isFavorite;
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

  void _shareAll() async {
    final result = await _viewModel.findContentByLitanyTitle(_currentItem);
    result.when(ok: (items) {
      final buffer = StringBuffer();
      buffer.writeln(_currentItem.name);
      buffer.writeln();
      for (final item in items) {
        buffer.writeln(StringUtil.getPersonLabel(item.person));
        if (item.books != null && item.books!.isNotEmpty) {
          buffer.writeln(item.books);
        }
        buffer.writeln(item.content);
        buffer.writeln();
      }
      SharePlus.instance.share(ShareParams(text: buffer.toString(), subject: _currentItem.name));
    }, error: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ContentBottomSheet<LitanyContent>(
              key: ValueKey(_currentItem.id),
              title: _currentItem.name,
              future: _viewModel.findContentByLitanyTitle(_currentItem),
              separateActions: true,
              actions: [
                ActionButton(icon: Icons.share, onPressed: _shareAll),
                ActionButton(
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  isActive: _isFavorite,
                  onPressed: _onFavorite,
                ),
                ...fontActions,
              ],
              itemBuilder: (context, item, index) {
                final isCongregation = item.person != "DIRECTOR";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            StringUtil.getPersonLabel(item.person),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFFE61E62),
                            ),
                          ),
                          const Spacer(),
                          ContentItemActions(text: item.content),
                        ],
                      ),
                      if (item.books != null && item.books!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.books!,
                          style: TextStyle(
                            fontSize: currentFontSize * 0.8,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: currentFontSize,
                          height: 1.6,
                          fontWeight: isCongregation ? FontWeight.w600 : FontWeight.normal,
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
