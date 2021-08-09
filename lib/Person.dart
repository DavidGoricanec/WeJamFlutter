import 'dart:convert';
import 'register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './config.dart' as config;
import './session.dart';
import 'results.dart';

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

class Person implements ListItem {
  final String firstname;
  final String lastname;
  final String birthday;
  final String phonenumber;
  final String distance;
  final String instruments;
  final String base64_img;
  final String content_type;

  Person(
      {required this.firstname,
      required this.lastname,
      required this.birthday,
      required this.phonenumber,
      required this.distance,
      required this.instruments,
      required this.base64_img,
      required this.content_type});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstname: json["firstname"],
      lastname: json["lastname"],
      birthday: json["birthday"].toString(),
      phonenumber: json["phonenumber"].toString(),
      distance: json["distance"].toString(),
      instruments: json["playing_instruments"].toString(),
      base64_img: 'x',
      //json["base64_img"],
      content_type: json["content_type"].toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext context) => Text('$firstname $lastname');

  @override
  Widget buildSubtitle(BuildContext context) =>
      Text('$distance km, $birthday, $instruments');
}
