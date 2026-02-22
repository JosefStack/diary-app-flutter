import 'dart:math' as math;
import 'package:flutter/material.dart';

class RippleRoute extends PageRouteBuilder {
  final Widget page;
  final Offset center;

  RippleRoute({required this.page, required this.center})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ClipPath(
                clipper: CircularRevealClipper(
                  fraction: animation.value,
                  center: center,
                ),
                child: child,
              );
            },
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 800),
      );
}

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    // Calculate distance to all four corners from the tap center
    double d1 = math.sqrt(math.pow(center.dx, 2) + math.pow(center.dy, 2));
    double d2 = math.sqrt(math.pow(w - center.dx, 2) + math.pow(center.dy, 2));
    double d3 = math.sqrt(math.pow(center.dx, 2) + math.pow(h - center.dy, 2));
    double d4 = math.sqrt(
      math.pow(w - center.dx, 2) + math.pow(h - center.dy, 2),
    );

    // The maximum distance ensures the ripple covers the whole screen
    final maxRadius = [d1, d2, d3, d4].reduce(math.max);
    final radius = maxRadius * Curves.easeInOutCubic.transform(fraction);

    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}

// Keeping SlideUpRoute just in case, but renaming it or adding RippleRoute
class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveSelection(curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      );
}

class CurveSelection extends CurveTween {
  CurveSelection(Curve curve) : super(curve: curve);
}
