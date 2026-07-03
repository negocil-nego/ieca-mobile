import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class PageListTile extends StatelessWidget {
  final int number;
  final String title;
  final String? subtitle;

  final Function()? onPressed;
  final Function()? onFavorite;
  final bool isFavorite;

  const PageListTile({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.onPressed,
    this.onFavorite,
    this.isFavorite = false,
  });

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
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.8,
                    fontSize: 11,
                  ),
                ),
              ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onFavorite != null)
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: primaryColor,
                  size: 20,
                ),
                onPressed: onFavorite,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            const SizedBox(width: 4),
            AppIcon.arrowRight,
          ],
        ),
      );
  }
}
