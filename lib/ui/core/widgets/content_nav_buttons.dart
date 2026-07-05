import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class ContentNavButtons extends StatelessWidget {
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ContentNavButtons({
    super.key,
    this.hasPrevious = false,
    this.hasNext = false,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            backgroundColor: hasPrevious ? AppColors.primary : Colors.grey.shade300,
            onPressed: hasPrevious ? onPrevious : null,
            child: Icon(
              AppIcon.chevronLeft,
              color: hasPrevious ? Colors.white : Colors.grey.shade500,
            ),
          ),
          FloatingActionButton.small(
            heroTag: null,
            backgroundColor: hasNext ? AppColors.primary : Colors.grey.shade300,
            onPressed: hasNext ? onNext : null,
            child: Icon(
              AppIcon.chevronRight,
              color: hasNext ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
