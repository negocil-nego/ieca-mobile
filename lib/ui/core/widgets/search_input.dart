import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function()? onReset;
  final String? hintText;

  const SearchInput({super.key, this.onReset, this.controller, this.onChanged, this.hintText});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(SearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Procurar...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(AppIcon.search, color: Color(0xFFD81B60)),
          suffixIcon: (widget.controller?.text.isNotEmpty ?? false)
              ? IconButton(
            icon: const Icon(AppIcon.clear, color: Colors.grey),
            onPressed: widget.onReset,
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFD81B60), width: 1.5),
          ),
        ),
      ),
    );
  }
}