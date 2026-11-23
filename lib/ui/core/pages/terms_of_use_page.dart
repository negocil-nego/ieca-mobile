import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

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
            "Termos de uso",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Ao utilizar esta aplicação, aceita os seguintes termos.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          BulletItem(
            title: "Uso gratuito",
            description: "A aplicação é totalmente gratuita e pode ser utilizada livremente.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Proibida a venda",
            description: "É proibida a venda ou comercialização desta aplicação ou do seu conteúdo.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Direitos autorais",
            description: "Os textos e hinos aqui presentes pertencem aos seus respectivos autores e não podem ser alterados ou reproduzidos sem autorização.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Uso pessoal",
            description: "O conteúdo destina-se exclusivamente para uso pessoal e espiritual.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Alterações",
            description: "Reservamo-nos o direito de atualizar estes termos a qualquer momento.",
          ),
        ],
      ),
    );
  }
}
