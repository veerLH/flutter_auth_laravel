import 'dart:convert';

import 'package:authlaravel/network_utils/api.dart';
import 'package:authlaravel/screen/home.dart';
import 'package:authlaravel/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _show=false;
  var email;
  var password;
  var name;
  final _scaffold=GlobalKey<ScaffoldState>();

  _showMsg(msg){
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: (){

        },
      ),
    );
    _scaffold.currentState.showSnackBar(snackBar);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Container(
        color: Colors.tealAccent,
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (valuename){
                                      if(valuename.isEmpty){
                                        return 'required this filed';
                                      }
                                      name=valuename;
                                      return null;
                                      },
                                    keyboardType: TextInputType.text,
                                    cursorColor: Color(0xFF9b9b9b),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.text_fields,color: Colors.grey,),
                                      labelText: "Enter Name"
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (valueemail){
                                      if(valueemail.isEmpty){
                                        return 'required this email';
                                      }
                                      email=valueemail;
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    cursorColor: Color(0xFF9b9b9b),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email,color: Colors.grey,),
                                        labelText: "Enter email"
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (valuepassword){
                                      if(valuepassword.isEmpty){
                                        return 'required password';
                                      }
                                      password=valuepassword;
                                      return null;
                                    },
                                    obscureText: !_show,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Color(0xFF9b9b9b),
                                    decoration: InputDecoration(

                                        prefixIcon: Icon(Icons.vpn_key,color: Colors.grey,),
                                        labelText: "Enter Password",
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
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      _register();
                                    }
                                  }, child: Text(_isLoading?'Loading...':'Register',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white
                                              ),
                                  ),color: Colors.teal,shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,

                      margin: EdgeInsets.only(top: 30),
                      child: InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                      }, child: Text("Login here...",style:
                        TextStyle(
                          fontSize: 20,

                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,

                        )
                        ,textAlign: TextAlign.center,)),
                    )
                  ],
                ) 
            )
          ],
        ),
      ),
    );
  }
  void _register() async{
    setState(() {
      _isLoading=true;
    });

    var data={
      'name' : name,
      'email' : email,
      'password' : password
    };

    var res = await Network().authData(data, 'register');
    var body = json.decode(res.body);

    if(body['statusCode']=='200'){
      SharedPreferences localstorage=await SharedPreferences.getInstance();
      localstorage.setString('token', json.encode(body['token']));
      localstorage.setString('user', json.encode(body['data']) );

      Navigator.push(context,
        new MaterialPageRoute(builder: (context) => Home()),
      );
    }else{
      _showMsg(body['message']);
    }
      setState(() {

        _isLoading = false;

      });
  }
}
