import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class PsalmContentBottomSheet extends StatefulWidget {
  final PsalmsTitle psalm;

  const PsalmContentBottomSheet({
    super.key,
    required this.psalm,
  });

  @override
  State<PsalmContentBottomSheet> createState() => _PsalmContentBottomSheetState();
}

class _PsalmContentBottomSheetState extends State<PsalmContentBottomSheet>
    with FontSizeAdjustment {
  late final PsalmContentBottomSheetViewModel _viewModel;
  late PsalmsTitle _currentItem;
  late bool _isFavorite;
  bool _hasNext = false;
  bool _hasPrevious = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PsalmContentBottomSheetViewModel();
    _currentItem = widget.psalm;
    _isFavorite = widget.psalm.isFavorite;
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
    final result = await _viewModel.findContentByPsalmsTitle(_currentItem);
    result.when(ok: (items) {
      final buffer = StringBuffer();
      buffer.writeln(_currentItem.name);
      buffer.writeln();
      for (final item in items) {
        buffer.writeln(StringUtil.getPersonLabel(item.person));
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
            child: ContentBottomSheet<PsalmsContent>(
              key: ValueKey(_currentItem.id),
              title: _currentItem.name,
              future: _viewModel.findContentByPsalmsTitle(_currentItem),
              separateActions: true,
              actions: [
                ActionButton(icon: AppIcon.share, onPressed: _shareAll),
                ActionButton(
                  icon: AppIcon.favoriteBorder,
                  activeIcon: AppIcon.favorite,
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
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          ContentItemActions(text: item.content),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: isCongregation ? FontWeight.w800 : FontWeight.normal,
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
