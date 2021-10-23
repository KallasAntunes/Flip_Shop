import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scraper_app/helpers/helpers.dart';
import 'package:scraper_app/screens/register.dart';

import './home.dart';
import './register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _passwordErrorMessage = "";
  String _emailErrorMessage = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    setState(() {
      _passwordErrorMessage = "";
      _emailErrorMessage = "";
    });

    //Remover depois
    email = "kallas@gmail.com";
    password = "senha1234";

    if (password.isEmpty) setState(() => _passwordErrorMessage = "Senha não pode ser vazia");
    if (email.isEmpty)
      setState(() => _emailErrorMessage = "E-mail não pode ser vazio");
    else if (password.isNotEmpty) {
      try {
        http.Response response = await http.post(Uri.parse("$api/auth"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: ({"email": email, "password": password}));
        if (json.decode(response.body)['success']) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          setState(() => _passwordErrorMessage = "E-mail ou senha incorretos");
        }
      } catch (_) {
        setState(() => _passwordErrorMessage = "Problema de conexão");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 4,
              child:
                  Container(alignment: Alignment(0, 0.2), child: Image.asset('assets/logo.png'))),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      errorText: _emailErrorMessage.isNotEmpty ? _emailErrorMessage : null,
                      helperText: "",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'E-mail',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                      hintText: 'email@exemplo.com.br',
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    onFieldSubmitted: (_) => _login(),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      errorText: _passwordErrorMessage.isNotEmpty ? _passwordErrorMessage : null,
                      helperText: "",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 15),
                      labelText: 'Senha',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _login(),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 50, vertical: 13)),
                      backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), side: BorderSide.none)),
                    ),
                    child: Text(
                      'Entrar',
                      style:
                          TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment(0, -1),
              child: Text.rich(
                  TextSpan(text: 'Ainda não possui uma conta? \n', children: <InlineSpan>[
                    TextSpan(
                        text: 'Cadastre-se já!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Register()));
                          })
                  ]),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
