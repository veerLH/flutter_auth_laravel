
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Network{

  final String _url= 'http://192.168.1.5:8080/api/';

  var token;

  _setHeader() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

  _getToken() async{

    SharedPreferences localStorage=await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));

  }

  authData(data, apiUrl) async {
    var fullUrl =_url+apiUrl;
    print(json.encode(data));
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeader()
    );
  }

  getData(apiUrl) async{
    var fullUrl=_url+apiUrl;
    await _getToken();

    return await http.post(
      fullUrl,
      headers: _setHeader()
    );

  }


}