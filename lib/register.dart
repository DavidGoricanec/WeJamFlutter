import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './config.dart' as config;
import './session.dart';


class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'WeJam!'.toUpperCase(),
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Please sign in'.toUpperCase(),
              style: Theme.of(context).textTheme.headline5,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value == '') {
                        return 'Please insert your email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value == '') {
                        return 'Please insert your password';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style:  ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 30)),
                      onPressed: ()  {},
                      child: const Text('Sign In'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,

                    child: ElevatedButton(
                      style:  ElevatedButton.styleFrom(primary: Colors.grey ,minimumSize: Size(double.infinity, 30)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text('New User? Register here'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}