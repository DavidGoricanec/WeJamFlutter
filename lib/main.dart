import 'dart:convert';
import 'register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './config.dart' as config;
import './session.dart';
import 'results.dart';
import 'Person.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeJam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'WeJam Mobile'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  String _output_msg = '';

  void login() {
    setState(() {
      _output_msg = "Sending data... Please wait";
    });
    getSession().then((session) {
      if (session.session_key != null && session.session_expire_date != null) {
        getPersonResults(session).then((person_items) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        session: session,
                        items: person_items,
                      )));
        });
      } else {
        setState(() {});
      }
    });
  }

  Future<List<Person>> getPersonResults(Session session) async {
    Map<String, String> requestHeaders = {
      'session_key': session.session_key,
      'distance_radius': '50',
    };

    final response = await http.get(
        Uri.parse(config.db_url + '/search_results'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      //print(json.decode(response.body)['items']);

      return List<Person>.from(json
          .decode(response.body)['items']
          .map((data) => Person.fromJson(data)));
    } else {
      throw Exception('Ups something went wrong. Please try again');
    }
  }

  Future<Session> getSession() async {
    Map<String, String> requestHeaders = {
      'email': _emailController.text,
      'password': _passwordController.text
    };

    final response = await http.post(Uri.parse(config.db_url + '/auth'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      //Got JSON; convert json
      Map<String, dynamic> json = jsonDecode(response.body);

      if (json["status"] == "200") {
        //JSON OK create Session
        _output_msg = 'Login OK';
        return Session.fromJson(jsonDecode(response.body));
      } else {
        //JSON not ok, exception
        _output_msg = json["err_msg"];
        return Session(session_key: "", session_expire_date: "");
      }
    } else {
      throw Exception(
          'Ups something went wrong. Please try a different email/password combination');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value == '') {
                        return 'Please insert your email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
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
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 30)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          minimumSize: Size(double.infinity, 30)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text('New User? Register here'),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center, child: Text(_output_msg))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
