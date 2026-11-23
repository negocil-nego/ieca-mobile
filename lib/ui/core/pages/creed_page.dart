import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class CreedPage extends StatelessWidget {
  const CreedPage({super.key});

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
            "Credo Apostólico",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "O Credo dos Apóstolos é uma das declarações de fé mais antigas e amplamente aceites do cristianismo.",
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
              "CREDO APOSTÓLICO\n\n"
              "Creio em Deus Pai, Todo-Poderoso, Criador do Céu e da Terra;\n\n"
              "Em Jesus Cristo seu Único Filho, nosso Senhor; o qual foi concebido por "
              "obra do Espírito Santo; nasceu da Virgem Maria; Padeceu sob o poder de "
              "Pôncio Pilatos; foi crucificado, morto e sepultado; no terceiro dia ressurgiu "
              "dos mortos, subiu aos céus, e está sentado à mão direita de Deus Pai, "
              "Todo-Poderoso, donde há-de vir julgar os vivos e os mortos.\n\n"
              "Creio no Espírito Santo; na Santa Igreja Universal; na comunhão dos "
              "santos; na remissão dos pecados; na ressurreição do corpo; e na vida eterna.\n\n"
              "Ámen.",
              style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
