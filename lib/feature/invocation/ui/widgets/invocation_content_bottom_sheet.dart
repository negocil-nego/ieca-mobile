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
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _viewModel = InvocationContentBottomSheetViewModel();
    _isFavorite = widget.invocation.isFavorite;
  }

  void _onFavorite() {
    _viewModel.toggleFavorite(widget.invocation.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentBottomSheet<InvocationContent>(
      title: widget.invocation.name,
      future: _viewModel.findContentByInvocation(widget.invocation),
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
    );
  }
}