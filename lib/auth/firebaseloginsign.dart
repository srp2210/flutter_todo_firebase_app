// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_todo/screens/home.dart';

import '../functions/authfunctions.dart';

class Flogin extends StatefulWidget {
  const Flogin({super.key});

  @override
  State<Flogin> createState() => _FloginState();
}

class _FloginState extends State<Flogin> {
  final _formkey = GlobalKey<FormState>();
  bool isLogIn = false;
  String email = '';
  String password = '';
  String username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email/Password Auth"),
      ),
      body: Form(
        key: _formkey,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !isLogIn
                  ? TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(hintText: 'Enter Username'),
                      validator: (value) {
                        if (value.toString().length < 3) {
                          return 'Usernamer is too small';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          username = value!;
                        });
                      },
                    )
                  : Container(),
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(hintText: 'Enter Email'),
                validator: (value) {
                  if (!(value.toString().contains('@'))) {
                    return 'Invalid Email Format';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              TextFormField(
                obscureText: true,
                key: ValueKey('password'),
                decoration: InputDecoration(hintText: 'Enter Password'),
                validator: (value) {
                  if (value.toString().length < 5) {
                    return 'Password is too small';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      isLogIn
                          ? signin(email, password)
                          : signup(email, password);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => Home())));
                    }
                  },
                  child: isLogIn ? Text('LogIn') : Text('SignUp'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogIn = !isLogIn;
                  });
                },
                child: isLogIn
                    ? Text("Don't have an account? Signup ")
                    : Text('Already Signed Up? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
