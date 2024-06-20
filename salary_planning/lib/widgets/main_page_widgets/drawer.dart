import 'package:flutter/material.dart';
import 'package:salary_planning/screens/income_screen.dart';
import 'package:salary_planning/screens/main_page.dart';

class AppBarDrawer extends StatelessWidget {
  const AppBarDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Drawer(
      width: width * 0.6,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              const UserAccountsDrawerHeader(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 37, 134, 141)),
                  currentAccountPicture: CircleAvatar(
                    foregroundImage: AssetImage("assets/images/İmage.jpeg"),
                  ),
                  accountName: Text("Akif Emre Küçük"),
                  accountEmail: Text("akifemrekucuk@gmail.com")),
              _drawerItem(
                  height, width, "Profil", Icons.account_circle_outlined, () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => MainPage()));
              }),
              // _drawerItem(
              //     height, width, "Yıllk Grafik", Icons.equalizer, () {}),
              _drawerItem(
                  height, width, "Gelir & Gider Ekle", Icons.add_circle_outline,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => IncomeScreen()));
              }),
              // _drawerItem(height, width, "Ayarlar", Icons.settings, () {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (ctx) => SettingsScreen()));
              // }),
              // ListTile(
              //   title: const Text(
              //     "Profil",
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   leading: const Icon(Icons.account_circle),
              //   onTap: () {},
              // ),
              // ListTile(
              //   title: const Text(
              //     "Salaries",
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   leading: const Icon(Icons.assessment),
              //   onTap: () {
              //     Navigator.of(context).pushNamed(WageScreen.routeName);
              //   },
              // ),
              // ListTile(
              //   title: const Text(
              //     "Expenses",
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   leading: const Icon(Icons.event_note_rounded),
              //   onTap: () {
              //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WageDetailScreen(0)));
              //   },
              // ),
              // const ListTile(
              //   title: Text(
              //     "Settings",
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   leading: Icon(Icons.settings),
              // ),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector _drawerItem(double height, double width, String text,
      IconData iconData, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8, left: 10),
        alignment: Alignment.topCenter,
        height: height * 0.05,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(
              width: width * 0.05,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
