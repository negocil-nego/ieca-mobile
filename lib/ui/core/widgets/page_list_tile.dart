import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class PageListTile extends StatelessWidget {
  final int number;
  final String title;
  final String? subtitle;
  final String? highlightQuery;

  final Function()? onPressed;
  final Function()? onFavorite;
  final bool isFavorite;

  const PageListTile({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.highlightQuery,
    this.onPressed,
    this.onFavorite,
    this.isFavorite = false,
  });

  Widget _buildSubtitle(String text, String? query) {
    if (query == null || query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          fontSize: 11,
        ),
      );
    }

    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();
    final spans = <InlineSpan>[];
    int start = 0;
    int idx = lower.indexOf(qLower, start);
    while (idx != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: const TextStyle(
          color: Color(0xFFE61E62),
          fontWeight: FontWeight.bold,
        ),
      ));
      start = idx + query.length;
      idx = lower.indexOf(qLower, start);
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          fontSize: 11,
        ),
        children: spans,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE61E62);

    return ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onPressed,
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: primaryColor.withAlpha(30),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            "$number",
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: subtitle == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: _buildSubtitle(subtitle!, highlightQuery),
              ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onFavorite != null)
              IconButton(
                icon: Icon(
                  isFavorite ? AppIcon.favorite : AppIcon.favoriteBorder,
                  color: primaryColor,
                  size: 20,
                ),
                onPressed: onFavorite,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            const SizedBox(width: 4),
            AppIcon.arrowRightIcon(),
          ],
        ),
      );
  }
}
