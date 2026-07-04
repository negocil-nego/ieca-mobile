import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

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
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _viewModel = PsalmContentBottomSheetViewModel();
    _isFavorite = widget.psalm.isFavorite;
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.psalm.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentBottomSheet<PsalmsContent>(
      title: widget.psalm.name,
      future: _viewModel.findContentByPsalmsTitle(widget.psalm),
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
        final isCongregation = item.person != "DIRECTOR";
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringUtil.getPersonLabel(item.person),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFFE61E62),
                ),
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
    );
  }
}