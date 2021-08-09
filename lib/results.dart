import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './config.dart' as config;
import './session.dart';
import 'Person.dart';

class Results extends StatelessWidget {
  final List<Person> items;
  final Session session;

  const Results({Key? key, required this.session, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView.builder(
                itemCount: items.length,
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    title: item.buildTitle(context),
                    subtitle: item.buildSubtitle(context),
                  );
                },
              ),
            ]));
  }
}
