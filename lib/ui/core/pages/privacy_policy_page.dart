import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
            "Política de privacidade",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "A sua privacidade é importante para nós.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          BulletItem(
            title: "Uso livre",
            description: "A aplicação pode ser utilizada livremente por qualquer pessoa sem necessidade de registo ou autenticação.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Sem recolha de dados",
            description: "Não recolhemos, armazenamos ou processamos qualquer informação pessoal dos utilizadores.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Sem cookies",
            description: "Esta aplicação não utiliza cookies, sessões ou qualquer mecanismo de rastreio.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Sem partilha com terceiros",
            description: "Como não recolhemos dados, não partilhamos qualquer informação com terceiros.",
          ),
          const SizedBox(height: 16),
          BulletItem(
            title: "Dados locais",
            description: "Os seus favoritos e histórico de acesso são armazenados apenas localmente no seu dispositivo.",
          ),
        ],
      ),
    );
  }
}
