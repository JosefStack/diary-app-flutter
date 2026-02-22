import 'package:flutter/material.dart';

class RipplePageRoute extends PageRouteBuilder {
  final Widget widget;
  final Offset center;

  RipplePageRoute({required this.widget, required this.center})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RippleTransition(
            animation: animation,
            center: center,
            child: child,
          );
        },
      );
}

class RippleTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Offset center;
  final Widget child;

  const RippleTransition({
    super.key,
    required this.animation,
    required this.center,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Calculate distance to furthest corner to ensure full coverage
    final double maxRadius = _getDistanceToFurthestCorner(center, size);

    return ClipPath(
      clipper: RippleClipper(
        radius: animation.value * maxRadius,
        center: center,
      ),
      child: child,
    );
  }

  double _getDistanceToFurthestCorner(Offset point, Size size) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    double maxDistance = 0;
    for (final corner in corners) {
      final distance = (point - corner).distance;
      if (distance > maxDistance) maxDistance = distance;
    }
    return maxDistance;
  }
}

class RippleClipper extends CustomClipper<Path> {
  final double radius;
  final Offset center;

  RippleClipper({required this.radius, required this.center});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
