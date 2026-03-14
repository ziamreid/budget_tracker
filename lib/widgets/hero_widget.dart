import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    super.key,
    required this.title,
    this.widget,
  });

  final String title;
  final Widget? widget; 
  @override
  Widget build(BuildContext context) {
    final bool isClickable = widget != null;

    return GestureDetector(
      onTap: isClickable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget!),
              );
            }
          : null, 
      child: Opacity(
        opacity: isClickable ? 1.0 : 0.7, 
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: 'h1',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://preview.redd.it/archive-with-all-mac-and-ios-wallpapers-v0-32h4nufe0gke1.jpeg?width=2732&format=pjpg&auto=webp&s=9eb7b7b7846effa54efa06ef5932db70d2ba65d7',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 240.0,
                ),
              ),
            ),
            FittedBox(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 20,
                  color: Colors.white30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
