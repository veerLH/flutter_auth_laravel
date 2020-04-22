import 'dart:convert';

import 'package:authlaravel/network_utils/api.dart';
import 'package:authlaravel/screen/home.dart';
import 'package:authlaravel/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _isLoading = false;
  bool _show=false;
  final _fomkey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey= GlobalKey<ScaffoldState>();

  _showMsg(msg){
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          onPressed: (){

          },
        ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.tealAccent,
        child: Stack(
          children: <Widget>[
            Positioned(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                              key: _fomkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email,color: Colors.grey,),
                                      labelText: 'Email'
                                    ),

                                    validator: (emailValue){
                                      if(emailValue.isEmpty){
                                        return 'Please Enter email';
                                      }
                                      email=emailValue;
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    obscureText: !_show,
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email,color: Colors.grey,),
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              print(!_show);
                                              _show=!_show;
                                            });
                                          },
                                          icon: Icon(Icons.remove_red_eye,color: _show?Colors.blue:Colors.grey,),
                                        )
                                    ),

                                    validator: (passwordValue){
                                      if(passwordValue.isEmpty){
                                        return 'Please Enter Password';
                                      }
                                      password=passwordValue;
                                      return null;
                                    },
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(onPressed: (){
                                      if(_fomkey.currentState.validate()){
                                        _login();
                                      }
                                    }, child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(_isLoading? 'Proccessing...': 'Login',
                                                textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold
                                                ),
                                      ),
                                    ),
                                      color: Colors.teal,
                                      disabledColor: Colors.grey,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(16.0)
                                      ),
                                    ),
                                  )
                                ],
                              )),
                    ),
                  ),
                  InkWell(
                    onTap:() {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => Register())
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Create New Account",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        decoration: TextDecoration.none
                      ),),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
  void _login() async{
    setState(() {
      _isLoading=true;
    });

    var data={
      'email' : email,
      'password' : password
    };

    var res =await Network().authData(data,'login');
    var body= json.decode(res.body);

    if(body['statusCode']=='200'){

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['data']) );
      Navigator.push(context,
        new MaterialPageRoute(
            builder: (context) => Home()),
      );
    }else{
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false ;
    });


  }

}


