import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class LordPrayerPage extends StatelessWidget {
  const LordPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcon.arrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Oração do Senhor",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "O Pai-Nosso é a oração que o Senhor Jesus Cristo ensinou aos seus discípulos.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              "ORAÇÃO DO SENHOR\n\n"
              "Pai nosso que estás nos céus,\n"
              "Santificado seja o teu nome,\n"
              "Venha o teu reino,\n"
              "Seja feita a tua vontade,\n"
              "Assim na terra como no céu,\n"
              "O pão nosso de cada dia nos dá hoje,\n"
              "Perdoa-nos as nossas dívidas,\n"
              "Assim como nós perdoamos aos nossos devedores;\n"
              "E não nos deixes cair em tentação;\n"
              "Mas livra-nos do mal;\n"
              "Pois Teu é o reino, e o poder, e a glória, para sempre.\n\n"
              "Ámen.",
              style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
