import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scraper_app/helpers/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens.dart';

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  late List laptops = [];

  @override
  initState() {
    super.initState();
    getSavedLaptops();
  }

  void getSavedLaptops() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() => laptops = prefs
          .getKeys()
          .map((key) => prefs.containsKey(key) ? json.decode(prefs.getString(key)!) : null)
          .toList());
    } catch (e) {
      print(e);
    }
  }

  void removeLaptop(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$id').then((bool success) => success ? getSavedLaptops() : throw Error());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 35, right: 35, top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Produtos Salvos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: backgroundDark,
            ),
          ),
          SizedBox(height: 19),
          Expanded(
            child: GridView.count(
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                crossAxisCount: 3,
                childAspectRatio: 0.74,
                children: List.generate(
                  laptops.length,
                  (index) => GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Details(laptops[index]['id']))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 6,
                            top: 5,
                            child: GestureDetector(
                              onTap: () => removeLaptop(laptops[index]['id']),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Color(0xFFC70000),
                                size: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 21, 10, 15),
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
                                  laptops[index]['title'].split(" ").sublist(3, 6).join(" "),
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  r'R$' + '${laptops[index]['price']}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
