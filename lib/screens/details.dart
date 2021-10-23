import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';
import 'package:scraper_app/helpers/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  const Details(
    this.id, {
    Key? key,
  }) : super(key: key);

  final int id;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Map laptop = {};
  bool saved = false;

  void checkIfIsSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => saved = prefs.containsKey('${laptop['id']}'));
  }

  @override
  initState() {
    super.initState();
    try {
      http.get(Uri.parse("$api/notebook/${widget.id}")).then((value) {
        setState(() => laptop = json.decode(value.body)[0]);
        checkIfIsSaved();
      });
    } catch (e) {
      print(e);
    }
  }

  removeLaptop() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('${laptop['id']}').then((bool success) => setState(() => saved = !success));
  }

  saveLaptop() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs
        .setString("${widget.id}", json.encode(laptop))
        .then((bool success) => setState(() => saved = success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: backgroundDark,
        title: Image.asset('assets/logo_small.png'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: laptop['id'] == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ReCase(laptop['title']).titleCase,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          laptop['image'].isNotEmpty
                              ? laptop['image']
                              : "https://www.notebookcheck.info/typo3temp/_processed_/5/4/csm_MicrosoftSurfaceLaptop3-15__1__02_a619039ed5.jpg",
                          height: 250),
                    ],
                  ),
                  Text(
                    "Preço:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    r"R$ " + laptop['price'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sobre esse item: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Text(
                    ReCase(laptop['title'] + ", " + laptop['title']).sentenceCase,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
      floatingActionButton: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFC70000)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: saved ? removeLaptop : saveLaptop,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            gradient: saved
                ? null
                : LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment(-0.8, 0),
                    colors: [
                      Color(0xFFEF043F),
                      Color(0xFFC42271),
                    ],
                  ),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(saved ? "Remover" : "Salvar", style: TextStyle(fontSize: 16)),
              SizedBox(width: 4),
              Icon(saved ? Icons.delete_outline : Icons.favorite_border, size: 23)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
