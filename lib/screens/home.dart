import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scraper_app/helpers/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List laptops = [];
  late int savedLaptops = 0;
  bool isSaved = false;

  @override
  initState() {
    super.initState();
    try {
      http.get(Uri.parse("$api")).then((value) {
        setState(() => laptops = json.decode(value.body));
      });
    } catch (e) {
      print(e);
    }
    getSavedLaptops();
  }

  getSavedLaptops() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => savedLaptops = prefs.getKeys().length);
  }

  @override
  Widget build(BuildContext context) {
    getSavedLaptops();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundDark,
          title: Image.asset('assets/logo_small.png'),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF0F0F0),
        body: isSaved
            ? Saved()
            : Padding(
                padding: EdgeInsets.only(left: 35, right: 35, top: 28),
                child:
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    // Text(
                    //   "Filtrar por marca",
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //     color: backgroundDark,
                    //   ),
                    // ),
                    // SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       width: 65,
                    //       height: 65,
                    //       padding: EdgeInsets.fromLTRB(14, 11, 13.44, 15),
                    //       decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           gradient: LinearGradient(
                    //             begin: Alignment.topCenter,
                    //             end: Alignment(0, 0.2),
                    //             colors: [
                    //               Color(0xFFEF043F),
                    //               Color(0xFFFF7676),
                    //             ],
                    //           )),
                    //       child: Image.asset(
                    //         'assets/apple.png',
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 65,
                    //       height: 65,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Color(0xFF004F9C),
                    //       ),
                    //       child: Image.asset(
                    //         'assets/samsung.png',
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 65,
                    //       height: 65,
                    //       decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           gradient: LinearGradient(
                    //             begin: Alignment.topCenter,
                    //             end: Alignment.bottomCenter,
                    //             colors: [
                    //               Color(0xFFB4FF4E),
                    //               Color(0xFF2FC145),
                    //             ],
                    //           )),
                    //       child: Image.asset(
                    //         'assets/acer.png',
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 65,
                    //       height: 65,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Color(0xFF4987CE),
                    //       ),
                    //       child: Image.asset(
                    //         'assets/hp.png',
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 15),
                    //   Expanded(
                    // child:
                    GridView.count(
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 11,
                        crossAxisCount: 3,
                        childAspectRatio: 0.74,
                        children: List.generate(
                          laptops.length,
                          (index) => GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details(laptops[index]['id'])),
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 10, 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      laptops[index]['image'].isNotEmpty
                                          ? laptops[index]['image']
                                          : "https://www.notebookcheck.info/typo3temp/_processed_/5/4/csm_MicrosoftSurfaceLaptop3-15__1__02_a619039ed5.jpg",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    laptops[index]['title'].split(" ").sublist(3, 7).join(" "),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    r'R$' + '${laptops[index]['price']}',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                // ),
                //   ],
                // ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: mainColor,
          selectedIconTheme: IconThemeData(color: mainColor, opacity: 1.0, size: 30.0),
          unselectedItemColor: Colors.white,
          unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1.0, size: 30.0),
          backgroundColor: backgroundDark,
          type: BottomNavigationBarType.fixed,
          currentIndex: isSaved ? 1 : 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(children: [
                Icon(Icons.favorite_border),
                Positioned(
                  bottom: -4,
                  right: -0.5,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainColor,
                    ),
                    child: Text(
                      '$savedLaptops',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
              label: 'Salvos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Sair',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                setState(() => isSaved = false);
                break;
              case 1:
                setState(() => isSaved = true);
                break;
              case 2:
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                break;
            }
          },
        ),
      ),
    );
  }
}
