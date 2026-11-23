import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class ReportErrorSheet extends StatefulWidget {
  const ReportErrorSheet({super.key});

  @override
  State<ReportErrorSheet> createState() => _ReportErrorSheetState();
}

class _ReportErrorSheetState extends State<ReportErrorSheet> {
  final _options = [
    'Texto com erro ortográfico',
    'Texto diferente do hinário',
    'Estrofe em falta',
    'Coro em falta',
    'Outro',
  ];

  final _selected = <String>{};
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Reportar erro',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._options.map((option) {
            final isOther = option == 'Outro';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: Text(option, style: const TextStyle(fontSize: 14)),
                  value: _selected.contains(option),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selected.add(option);
                        if (isOther) _otherController.text = '';
                      } else {
                        _selected.remove(option);
                      }
                    });
                  },
                ),
                if (isOther && _selected.contains(option))
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 8),
                    child: TextField(
                      controller: _otherController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Descreva o erro...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _selected.isEmpty
                  ? null
                  : () {
                      final otherText = _otherController.text.trim();
                      if (_selected.contains('Outro') && otherText.isEmpty) return;
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text(
                            otherText.isNotEmpty
                                ? 'Relatado: ${_selected.where((o) => o != 'Outro').join(', ')} — $otherText'
                                : 'Relatado: ${_selected.join(', ')}',
                          ),
                          duration: const Duration(seconds: 3),
                        ));
                    },
              child: const Text('Enviar reporte'),
            ),
          ),
        ],
      ),
    );
  }
}
