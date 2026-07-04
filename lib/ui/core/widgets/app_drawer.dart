import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _appVersion = "1.0.0+1";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAsset.logo, height: 48),
                const SizedBox(height: 8),
                const Text(
                  "IECA Hinário",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "v$_appVersion",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text("Política de privacidade"),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text("Termos de uso"),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Sobre"),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
