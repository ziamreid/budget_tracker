import 'package:flutter/material.dart';

class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  FadeSlideTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: Curves.fastOutSlowIn,
           );

           return FadeTransition(
             opacity: curvedAnimation,
             child: SlideTransition(
               position: Tween<Offset>(
                 begin: const Offset(0.0, 0.05),
                 end: Offset.zero,
               ).animate(curvedAnimation),
               child: child,
             ),
           );
         },
       );
}

class ScaleTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  ScaleTransitionRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutBack,
           );

           return FadeTransition(
             opacity: curvedAnimation,
             child: Transform.scale(
               scale: Tween<double>(
                 begin: 0.9,
                 end: 1.0,
               ).animate(curvedAnimation).value,
               child: child,
             ),
           );
         },
       );
}

class SlideUpTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  SlideUpTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: Curves.fastOutSlowIn,
           );

           return SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(0.0, 0.3),
               end: Offset.zero,
             ).animate(curvedAnimation),
             child: FadeTransition(opacity: curvedAnimation, child: child),
           );
         },
       );
}
