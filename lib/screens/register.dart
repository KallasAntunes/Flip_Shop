import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scraper_app/helpers/helpers.dart';

import './home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _nameErrorMessage = "";
  String _passwordErrorMessage = "";
  String _emailErrorMessage = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _register() async {
      String email = _emailController.text;
      String password = _passwordController.text;
      String name = _nameController.text;
      setState(() {
        _passwordErrorMessage = "";
        _emailErrorMessage = "";
        _nameErrorMessage = "";
      });

      if (password.length < 7)
        setState(() => _passwordErrorMessage = "Senha não pode ser menor do que 7 caracteres");
      if (name.length < 3)
        setState(() => _nameErrorMessage = "Nome não pode ser menor do que 3 caracteres");
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email))
        setState(() => _emailErrorMessage = "E-mail inválido");
      else if (password.length >= 7 && name.length >= 3) {
        try {
          http.Response response = await http.post(Uri.parse("$api/createUser"),
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
              },
              body: ({"name": name, "email": email, "password": password, "admin": "0"}));
          if (response.statusCode == 201) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          } else {
            setState(() => _passwordErrorMessage = "E-mail ou senha incorretos");
          }
        } catch (e) {
          print(e);
          setState(() => _passwordErrorMessage = "Problema de conexão");
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Image.asset('assets/logo_small.png'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              "Crie sua conta de acesso usando o seu e\u2011mail como usuário",
              style: TextStyle(fontSize: 19, color: Color(0xFF8B8B8B)),
            ),
            SizedBox(height: 40),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: _nameController,
              decoration: InputDecoration(
                helperText: "",
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                labelText: 'Nome',
                labelStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                errorText: _nameErrorMessage.isNotEmpty ? _nameErrorMessage : null,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                helperText: "",
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                labelText: 'E-mail',
                labelStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                hintText: 'email@exemplo.com.br',
                errorText: _emailErrorMessage.isNotEmpty ? _emailErrorMessage : null,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onFieldSubmitted: (_) => _register(),
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                helperText: "",
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                labelText: 'Senha',
                labelStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                errorText: _passwordErrorMessage.isNotEmpty ? _passwordErrorMessage : null,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => _register(),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 50, vertical: 13)),
                backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), side: BorderSide.none)),
              ),
              child: Text(
                'Cadastrar',
                style: TextStyle(
                    height: 1.3, color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
