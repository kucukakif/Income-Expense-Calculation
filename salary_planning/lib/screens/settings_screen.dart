import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkModeSwitch = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Container(
              height: height * 0.20,
              width: width * 1,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 134, 141),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
            )),
        Positioned(
            top: 40,
            child: Container(
                height: height > 700 ? height * 0.56 : height * 0.64,
                width: width * 0.92,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200),
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: titleWidget("Hesap"),
                      ),
                      Container(
                        height: height > 750 ? height * 0.07 : height * 0.085,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: itemWidget(
                                  width,
                                  Icons.account_circle_outlined,
                                  "Hesap Ayarları"),
                            )
                          ],
                        ),
                      ),
                      titleWidget("Ayarlar"),
                      Container(
                        height: height > 750 ? height * 0.14 : height * 0.165,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.005,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // String income = "";
                                // final pastYearData =
                                //     await PastYearsDb.instance.queryDatabase;
                                // for (int i = 0;
                                //     i < pastYearData.toString().length;
                                //     i++) {
                                //   income = pastYearData.toString()[i];
                                //   print(income);
                                // }
                              },
                              child: itemWidget(
                                  width,
                                  Icons.notifications_active,
                                  "Bildirim Ayarları"),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: itemWidget(width, Icons.trip_origin,
                                  "Veri Kullanım Ayarları"),
                            )
                          ],
                        ),
                      ),
                      titleWidget("Tema"),
                      Container(
                        height: height > 700 ? height * 0.15 : height * 0.17,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.005,
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: itemWidget(
                                    width, Icons.title, "Görüntü Ayarları")),
                            SizedBox(
                              height: height * 0.00,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: itemWidget(
                                  width, Icons.language, "Dil Ayarları"),
                            )
                          ],
                        ),
                      ),
                    ])))
      ],
    );
  }

  Container titleWidget(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade300,
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Row itemWidget(double width, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 26,
            ),
            SizedBox(
              width: width * 0.07,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_right))
      ],
    );
  }

  Row containerChild(double width, IconData icon, String text, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 26,
            ),
            SizedBox(
              width: width * 0.07,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        widget
      ],
    );
  }
}
