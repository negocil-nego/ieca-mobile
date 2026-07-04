import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Sobre",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Conheça mais sobre esta aplicação.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.church_outlined, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Igreja Evangélica Congregacional de Angola",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Esta aplicação é a transcrição digital do hinário oficial da IECA (Igreja Evangélica Congregacional de Angola), "
                  "contendo uma coleção de hinos, textos bíblicos como litanias, salmos e invocatórias. "
                  "O hinário apresenta estes hinos e textos bíblicos de modo que possa favoritar, "
                  "aceder aos hinos e textos bíblicos que mais tem utilizado ou acedido.",
                  style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Desenvolvido por",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.person_outline,
            label: "Nome",
            value: "Sedrac Lucas Calupeteca",
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.phone_outlined,
            label: "Contacto",
            value: "936269780",
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.email_outlined,
            label: "Email",
            value: "slcsecrac@gmail.com",
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.place_outlined,
            label: "Pastorado",
            value: "Nova Vida",
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFE61E62)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
