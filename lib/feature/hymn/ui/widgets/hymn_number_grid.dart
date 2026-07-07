import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class HymnNumberGrid extends StatefulWidget {
  final HymnsGroup hymnsGroup;
  final bool showFavouritesOnly;
  final bool showAdditionalOnly;

  const HymnNumberGrid({
    super.key,
    required this.hymnsGroup,
    this.showFavouritesOnly = false,
    this.showAdditionalOnly = false,
  });

  @override
  State<HymnNumberGrid> createState() => _HymnNumberGridState();
}

class _HymnNumberGridState extends State<HymnNumberGrid> {
  final HymNumberGridViewModel _viewModel = HymNumberGridViewModel();

  Future<Result<List<HymnsNumber>>> _fetch() {
    if (widget.showAdditionalOnly) {
      return _viewModel.findAdditionalByGroup(widget.hymnsGroup);
    }
    if (widget.showFavouritesOnly) {
      return _viewModel.findFavouritesByGroup(widget.hymnsGroup);
    }
    return _viewModel.findByHymnsGroup(widget.hymnsGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionFutureBuilder<HymnsNumber>(
            keyValue: ValueKey('${widget.hymnsGroup.id}_${widget.showFavouritesOnly}'),
            future: _fetch(),
            builder: (context, items) {
              if (items.isEmpty && (widget.showFavouritesOnly || widget.showAdditionalOnly)) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hymnsGroup.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final hymnNumber = items[index];
                      return _HymnNumberCard(hymnNumber: hymnNumber);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HymnNumberCard extends StatefulWidget {
  final HymnsNumber hymnNumber;

  const _HymnNumberCard({required this.hymnNumber});

  @override
  State<_HymnNumberCard> createState() => _HymnNumberCardState();
}

class _HymnNumberCardState extends State<_HymnNumberCard> {
  final _viewModel = HymNumberGridViewModel();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.hymnNumber.isFavorite;
  }

  void _onTap() {
    _viewModel.updateLastAccessed(widget.hymnNumber.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (context) => HymnContentBottomSheet(hymnNumber: widget.hymnNumber),
    );
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.hymnNumber.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.hymnNumber.num.toString(),
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _onFavorite,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(230),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isFavorite ? AppIcon.favorite : AppIcon.favoriteBorder,
                size: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
