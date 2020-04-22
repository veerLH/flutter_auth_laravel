
import 'dart:convert';
import 'package:authlaravel/network_utils/api.dart';
import 'package:authlaravel/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name="";
  String email="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLogin();
  }

  void _getUserLogin() async{
    SharedPreferences localStroage=await SharedPreferences.getInstance();

    var user= json.decode(localStroage.getString('user'));

    if(user != null){
      setState(() {
        name=user['name'];
        email=user['email'];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Card(
            elevation: 2.0,
            child: Padding(

              padding: const EdgeInsets.all(20.0),
              child: Column(

                children: <Widget>[
                  Text(name,style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                  )),
                  Text(email,style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 23
                  ),),
                  FlatButton(onPressed: (){
                    _logout();
                  }, child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logout",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),),
                  ),color: Colors.amber,),
                ],
              ),
            ),
          ),

        ],
      )
    );
  }
  void _logout() async{
    var res=await Network().getData('logout');
    var body=json.decode(res.body);

    if(body['statusCode']=='200') {
      SharedPreferences localStorage=await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>Login())
      );
    }

  }
}
