import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key,required this.title, this.description});
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: KStyle.title),
              Text(description!, style: KStyle.description),
            ],
          ),
        ),
      ),
    );
  }
}
