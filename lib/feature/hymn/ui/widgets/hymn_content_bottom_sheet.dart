import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class HymnContentBottomSheet extends StatefulWidget {
  final HymnsNumber hymnNumber;

  const HymnContentBottomSheet({super.key, required this.hymnNumber});

  @override
  State<HymnContentBottomSheet> createState() => _HymnContentBottomSheetState();
}

class _HymnContentBottomSheetState extends State<HymnContentBottomSheet> {
  final HymContentBottomSheetViewModel _viewModel = HymContentBottomSheetViewModel();
  static const Color pink = Color(0xFFE91E63);
  late HymnsNumber _currentHymn;
  late bool _isFavorite;
  bool _hasNext = false;
  bool _hasPrevious = false;

  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _currentHymn = widget.hymnNumber;
    _isFavorite = widget.hymnNumber.isFavorite;
    _checkNav();
  }

  void _checkNav() async {
    final next = await _viewModel.findNext(_currentHymn);
    final prev = await _viewModel.findPrevious(_currentHymn);
    if (!mounted) return;
    setState(() {
      _hasNext = next.when(ok: (v) => v != null, error: (_) => false);
      _hasPrevious = prev.when(ok: (v) => v != null, error: (_) => false);
    });
  }

  void _goNext() async {
    final result = await _viewModel.findNext(_currentHymn);
    result.when(ok: (hymn) {
      if (hymn != null && mounted) {
        setState(() {
          _currentHymn = hymn;
          _isFavorite = hymn.isFavorite;
        });
        _checkNav();
      }
    }, error: (_) {});
  }

  void _goPrevious() async {
    final result = await _viewModel.findPrevious(_currentHymn);
    result.when(ok: (hymn) {
      if (hymn != null && mounted) {
        setState(() {
          _currentHymn = hymn;
          _isFavorite = hymn.isFavorite;
        });
        _checkNav();
      }
    }, error: (_) {});
  }

  void _adjustFontSize(bool increase) {
    setState(() {
      if (increase) {
        _fontSize += 2.0;
      } else if (_fontSize > 10.0) {
        _fontSize -= 2.0;
      }
    });
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(_currentHymn.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _shareAll() async {
    final result = await _viewModel.findByHymnNumber(_currentHymn);
    result.when(ok: (items) {
      final buffer = StringBuffer();
      buffer.writeln('${_currentHymn.num} - ${_currentHymn.label}');
      buffer.writeln();
      int count = 0;
      for (final item in items) {
        if (item.typeStanza == HymnContentTypeStanza.CHOIR) {
          buffer.writeln('REFRÃO');
        } else {
          count++;
          buffer.writeln('VERSO $count');
        }
        buffer.writeln(StringUtil.replaceContent(item.content));
        buffer.writeln();
      }
      SharePlus.instance.share(ShareParams(text: buffer.toString(), subject: '${_currentHymn.num} - ${_currentHymn.label}'));
    }, error: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  _currentHymn.num.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareAll,
                ),
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: pink,
                  ),
                  onPressed: _onFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.text_decrease),
                  onPressed: () => _adjustFontSize(false),
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase),
                  onPressed: () => _adjustFontSize(true),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SectionFutureBuilder<HymnsContent>(
              keyValue: _currentHymn,
              future: _viewModel.findByHymnNumber(_currentHymn),
              builder: (context, items) {
                int count = 0;
                final List<String> labels = items.map((item) {
                  if (item.typeStanza != HymnContentTypeStanza.CHOIR) count++;
                  return item.typeStanza == HymnContentTypeStanza.CHOIR
                      ? 'REFRÃO'
                      : 'VERSO $count';
                }).toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 32),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isChoir = item.typeStanza == HymnContentTypeStanza.CHOIR;
                    final content = StringUtil.replaceContent(item.content);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              labels[index],
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: pink,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            ContentItemActions(text: item.content),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          width: double.infinity,
                          decoration: isChoir
                              ? BoxDecoration(
                            color: const Color(0xFFFFF3F8),
                            borderRadius: BorderRadius.circular(12),
                          )
                              : null,
                          child: Text(
                            content,
                            style: TextStyle(
                              fontSize: _fontSize,
                              height: 1.6,
                              color: isChoir ? pink : Colors.black87,
                              fontWeight: isChoir ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
