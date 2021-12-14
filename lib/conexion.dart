import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String valorRetorno = 'Respuesta : ';

// ignore: non_constant_identifier_names
String user_data(String email, String password) {
  String valor = "nodata";

  userLogin(email, password).then((String result) {
    asignar_respuesta(result);
  });

  return valorRetorno;
}

Future<String> userLogin(String email, String password) async {
  // Showing CircularProgressIndicator.
  /* setState(() {
  visible = true ; 
  }); */

  // SERVER LOGIN API URL
  var url = 'https://trasladex.000webhostapp.com/trasladex_bd/login_user.php';

  final Uri urlString = Uri.parse(url);

  // Store all data with Param Name.
  var data = {'email': email, 'password': password};

  // Starting Web API Call.
  var response = await http.post(urlString, body: json.encode(data));

  // Getting Server response into variable.
  var message = jsonDecode(response.body);

  // If the Response Message is Matched.

  // ignore: prefer_typing_uninitialized_variables
  var mensajeRetorno;

  if (message == 'Login Matched') {
    mensajeRetorno = 'REDIRIGIENDO...';
  } else {
    mensajeRetorno = 'DATOS INCORRECTOS';
  }

  // ignore: avoid_print
  return mensajeRetorno;
}

// ignore: non_constant_identifier_names
void asignar_respuesta(String valor) {
  valorRetorno = "";
  valorRetorno = valor;
}
