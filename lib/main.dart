import 'package:authlaravel/screen/home.dart';
import 'package:authlaravel/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){

  runApp(
    MaterialApp(
      title: 'Laravel Auth',
      debugShowCheckedModeBanner: false,
      home: Auth(),
    )
  );
}

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    _checkLogin();
    super.initState();

  }


  void _checkLogin() async{
    SharedPreferences localStorage=await SharedPreferences.getInstance();
    var token= localStorage.getString('token');

    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    Widget child;

    if(isAuth){
      child=Home();
    }else{
      child=Login();
    }

    return Scaffold(
      body: child,
    );
  }
}
