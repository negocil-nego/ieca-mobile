import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/_import.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams;

class ContentItemActions extends StatelessWidget {
  final String text;
  final double iconSize;

  const ContentItemActions({
    super.key,
    required this.text,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: AppIcon.copy,
          size: iconSize,
          tooltip: 'Copiar',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Texto copiado'),
                duration: Duration(seconds: 2),
              ));
          },
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: AppIcon.share,
          size: iconSize,
          tooltip: 'Partilhar',
          onPressed: () => SharePlus.instance.share(ShareParams(text: text)),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final String tooltip;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.size,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE61E62).withAlpha(25),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: size, color: const Color(0xFFE61E62)),
        ),
      ),
    );
  }
}
