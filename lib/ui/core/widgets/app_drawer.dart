import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = "${info.version}+${info.buildNumber}");
    }
  }

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
                  _appVersion.isNotEmpty ? "v$_appVersion" : "",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _SectionHeader(title: "Orações"),
                ListTile(
                  leading: const Icon(AppIcon.menuBook),
                  title: const Text("Credo Apostólico"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreedPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(AppIcon.book),
                  title: const Text("Oração do Senhor"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LordPrayerPage()),
                    );
                  },
                ),
                const _SectionHeader(title: "Aplicativo"),
                ListTile(
                  leading: const Icon(AppIcon.privacy),
                  title: const Text("Política de privacidade"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(AppIcon.fileDescription),
                  title: const Text("Termos de uso"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(AppIcon.info),
                  title: const Text("Sobre"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
