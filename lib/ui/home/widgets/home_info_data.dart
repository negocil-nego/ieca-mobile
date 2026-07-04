import 'package:flutter/material.dart';
import 'package:mobile/_import.dart';

class HomeInfoData extends StatelessWidget {
  const HomeInfoData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: const Color(0xFFE61E62),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFE61E62),
              tabs: const [
                Tab(text: "Últimos Acessos"),
                Tab(text: "Mais Acessados"),
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
