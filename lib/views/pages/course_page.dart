import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/widgets/hero_widget.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var url = Uri.https('bored-api.appbrewery.com', '/random');

    var response = await http.get(url);

    if(response.statusCode == 200)
    {
      var jsonResponse = jsonDecode(response.body) as Map<String , dynamic>;
      debugPrint(jsonResponse['activity']);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HeroWidget(title: 'Course Page'),
      ),
    );
  }
}
