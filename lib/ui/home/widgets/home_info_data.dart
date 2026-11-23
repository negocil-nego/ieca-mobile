import 'package:material_ui/material_ui.dart';
import 'package:mobile/_import.dart';

class HomeInfoData extends StatelessWidget {
  const HomeInfoData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: "Histórico"),
                Tab(text: "Acessos"),
              ],
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: TabBarView(
                children: [
                  HomeLastAccessedWidget(),
                  HomeAccessCountWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
