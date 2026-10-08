import 'package:flutter/material.dart';

class StarPathBuilder {
  /// Builds the outer four-pointed star with concave cubic Bézier curves and
  /// central negative-space cutout using [PathFillType.evenOdd].
  static Path buildStarPath(
    Rect rect, {
    double tipTaper = 0.05,
    double tipDepth = 0.62,
    double innerHoleRatio = 0.22,
    double innerHoleTaper = 0.15,
    double innerHoleDepth = 0.45,
  }) {
    final path = Path()..fillType = PathFillType.evenOdd;

    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final halfW = rect.width / 2;
    final halfH = rect.height / 2;

    // --- 1. Outer Star Vertices ---
    final top = Offset(cx, cy - halfH);
    final right = Offset(cx + halfW, cy);
    final bottom = Offset(cx, cy + halfH);
    final left = Offset(cx - halfW, cy);

    path.moveTo(top.dx, top.dy);

    // Top -> Right
    path.cubicTo(
      cx + halfW * tipTaper,
      cy - halfH + halfH * tipDepth,
      cx + halfW - halfW * tipDepth,
      cy - halfH * tipTaper,
      right.dx,
      right.dy,
    );

    // Right -> Bottom
    path.cubicTo(
      cx + halfW - halfW * tipDepth,
      cy + halfH * tipTaper,
      cx + halfW * tipTaper,
      cy + halfH - halfH * tipDepth,
      bottom.dx,
      bottom.dy,
    );

    // Bottom -> Left
    path.cubicTo(
      cx - halfW * tipTaper,
      cy + halfH - halfH * tipDepth,
      cx - halfW + halfW * tipDepth,
      cy + halfH * tipTaper,
      left.dx,
      left.dy,
    );

    // Left -> Top
    path.cubicTo(
      cx - halfW + halfW * tipDepth,
      cy - halfH * tipTaper,
      cx - halfW * tipTaper,
      cy - halfH + halfH * tipDepth,
      top.dx,
      top.dy,
    );

    path.close();

    // --- 2. Inner Negative Space Hole (Cutout) ---
    if (innerHoleRatio > 0.0) {
      final holeHalfW = halfW * innerHoleRatio;
      final holeHalfH = halfH * innerHoleRatio;

      final innerTop = Offset(cx, cy - holeHalfH);
      final innerRight = Offset(cx + holeHalfW, cy);
      final innerBottom = Offset(cx, cy + holeHalfH);
      final innerLeft = Offset(cx - holeHalfW, cy);

      path.moveTo(innerTop.dx, innerTop.dy);

      // Inner Top -> Inner Right
      path.cubicTo(
        cx + holeHalfW * innerHoleTaper,
        cy - holeHalfH + holeHalfH * innerHoleDepth,
        cx + holeHalfW - holeHalfW * innerHoleDepth,
        cy - holeHalfH * innerHoleTaper,
        innerRight.dx,
        innerRight.dy,
      );

      // Inner Right -> Inner Bottom
      path.cubicTo(
        cx + holeHalfW - holeHalfW * innerHoleDepth,
        cy + holeHalfH * innerHoleTaper,
        cx + holeHalfW * innerHoleTaper,
        cy + holeHalfH - holeHalfH * innerHoleDepth,
        innerBottom.dx,
        innerBottom.dy,
      );

      // Inner Bottom -> Inner Left
      path.cubicTo(
        cx - holeHalfW * innerHoleTaper,
        cy + holeHalfH - holeHalfH * innerHoleDepth,
        cx - holeHalfW + holeHalfW * innerHoleDepth,
        cy + holeHalfH * innerHoleTaper,
        innerLeft.dx,
        innerLeft.dy,
      );

      // Inner Left -> Inner Top
      path.cubicTo(
        cx - holeHalfW + holeHalfW * innerHoleDepth,
        cy - holeHalfH * innerHoleTaper,
        cx - holeHalfW * innerHoleTaper,
        cy - holeHalfH + holeHalfH * innerHoleDepth,
        innerTop.dx,
        innerTop.dy,
      );

      path.close();
    }

    return path;
  }

  /// Builds ONLY the inner negative-space diamond hole path for clipping the active highlighted text.
  static Path buildInnerHolePath(
    Rect rect, {
    double innerHoleRatio = 0.22,
    double innerHoleTaper = 0.15,
    double innerHoleDepth = 0.45,
  }) {
    final path = Path();
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final halfW = rect.width / 2;
    final halfH = rect.height / 2;

    final holeHalfW = halfW * innerHoleRatio;
    final holeHalfH = halfH * innerHoleRatio;

    final innerTop = Offset(cx, cy - holeHalfH);
    final innerRight = Offset(cx + holeHalfW, cy);
    final innerBottom = Offset(cx, cy + holeHalfH);
    final innerLeft = Offset(cx - holeHalfW, cy);

    path.moveTo(innerTop.dx, innerTop.dy);

    // Inner Top -> Inner Right
    path.cubicTo(
      cx + holeHalfW * innerHoleTaper,
      cy - holeHalfH + holeHalfH * innerHoleDepth,
      cx + holeHalfW - holeHalfW * innerHoleDepth,
      cy - holeHalfH * innerHoleTaper,
      innerRight.dx,
      innerRight.dy,
    );

    // Inner Right -> Inner Bottom
    path.cubicTo(
      cx + holeHalfW - holeHalfW * innerHoleDepth,
      cy + holeHalfH * innerHoleTaper,
      cx + holeHalfW * innerHoleTaper,
      cy + holeHalfH - holeHalfH * innerHoleDepth,
      innerBottom.dx,
      innerBottom.dy,
    );

    // Inner Bottom -> Inner Left
    path.cubicTo(
      cx - holeHalfW * innerHoleTaper,
      cy + holeHalfH - holeHalfH * innerHoleDepth,
      cx - holeHalfW + holeHalfW * innerHoleDepth,
      cy + holeHalfH * innerHoleTaper,
      innerLeft.dx,
      innerLeft.dy,
    );

    // Inner Left -> Inner Top
    path.cubicTo(
      cx - holeHalfW + holeHalfW * innerHoleDepth,
      cy - holeHalfH * innerHoleTaper,
      cx - holeHalfW * innerHoleTaper,
      cy - holeHalfH + holeHalfH * innerHoleDepth,
      innerTop.dx,
      innerTop.dy,
    );

    path.close();
    return path;
  }
}

class StarClipper extends CustomClipper<Path> {
  final Rect starRect;
  final double angle;
  final double tipTaper;
  final double tipDepth;
  final double innerHoleRatio;

  const StarClipper({
    required this.starRect,
    this.angle = 0.0,
    this.tipTaper = 0.05,
    this.tipDepth = 0.62,
    this.innerHoleRatio = 0.22,
  });

  @override
  Path getClip(Size size) {
    final path = StarPathBuilder.buildStarPath(
      starRect,
      tipTaper: tipTaper,
      tipDepth: tipDepth,
      innerHoleRatio: innerHoleRatio,
    );

    if (angle != 0.0) {
      final matrix =
          Matrix4.translationValues(starRect.center.dx, starRect.center.dy, 0.0)
            ..rotateZ(angle)
            ..multiply(
              Matrix4.translationValues(
                -starRect.center.dx,
                -starRect.center.dy,
                0.0,
              ),
            );
      return path.transform(matrix.storage);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant StarClipper oldClipper) {
    return oldClipper.starRect != starRect ||
        oldClipper.angle != angle ||
        oldClipper.tipTaper != tipTaper ||
        oldClipper.tipDepth != tipDepth ||
        oldClipper.innerHoleRatio != innerHoleRatio;
  }
}

class StarHoleClipper extends CustomClipper<Path> {
  final Rect starRect;
  final double angle;
  final double innerHoleRatio;
  final double innerHoleTaper;
  final double innerHoleDepth;

  const StarHoleClipper({
    required this.starRect,
    this.angle = 0.0,
    this.innerHoleRatio = 0.22,
    this.innerHoleTaper = 0.15,
    this.innerHoleDepth = 0.45,
  });

  @override
  Path getClip(Size size) {
    final path = StarPathBuilder.buildInnerHolePath(
      starRect,
      innerHoleRatio: innerHoleRatio,
      innerHoleTaper: innerHoleTaper,
      innerHoleDepth: innerHoleDepth,
    );

    if (angle != 0.0) {
      final matrix =
          Matrix4.translationValues(starRect.center.dx, starRect.center.dy, 0.0)
            ..rotateZ(angle)
            ..multiply(
              Matrix4.translationValues(
                -starRect.center.dx,
                -starRect.center.dy,
                0.0,
              ),
            );
      return path.transform(matrix.storage);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant StarHoleClipper oldClipper) {
    return oldClipper.starRect != starRect ||
        oldClipper.angle != angle ||
        oldClipper.innerHoleRatio != innerHoleRatio ||
        oldClipper.innerHoleTaper != innerHoleTaper ||
        oldClipper.innerHoleDepth != innerHoleDepth;
  }
}

class StarPainter extends CustomPainter {
  final Rect starRect;
  final double angle;
  final Color fillColor;
  final double tipTaper;
  final double tipDepth;
  final double innerHoleRatio;
  final bool drawSpineLines;

  const StarPainter({
    required this.starRect,
    this.angle = 0.0,
    required this.fillColor,
    this.tipTaper = 0.05,
    this.tipDepth = 0.62,
    this.innerHoleRatio = 0.22,
    this.drawSpineLines = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    if (angle != 0.0) {
      canvas.translate(starRect.center.dx, starRect.center.dy);
      canvas.rotate(angle);
      canvas.translate(-starRect.center.dx, -starRect.center.dy);
    }

    final cx = starRect.center.dx;
    final cy = starRect.center.dy;
    final halfW = starRect.width / 2;
    final halfH = starRect.height / 2;

    final top = Offset(cx, cy - halfH);
    final right = Offset(cx + halfW, cy);
    final bottom = Offset(cx, cy + halfH);
    final left = Offset(cx - halfW, cy);

    final holeHalfW = halfW * innerHoleRatio;
    final holeHalfH = halfH * innerHoleRatio;
    final innerTop = Offset(cx, cy - holeHalfH);
    final innerRight = Offset(cx + holeHalfW, cy);
    final innerBottom = Offset(cx, cy + holeHalfH);
    final innerLeft = Offset(cx - holeHalfW, cy);

    // 1. Draw solid filled star body with central cutout
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = StarPathBuilder.buildStarPath(
      starRect,
      tipTaper: tipTaper,
      tipDepth: tipDepth,
      innerHoleRatio: innerHoleRatio,
    );
    canvas.drawPath(path, fillPaint);

    // 2. Draw 4 subtle crease/spine lines from each outer tip to the inner hole vertex
    if (drawSpineLines) {
      final spinePaint = Paint()
        ..color = const Color(0xFF2C2214).withValues(alpha: 0.16)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      canvas.drawLine(top, innerTop, spinePaint);
      canvas.drawLine(right, innerRight, spinePaint);
      canvas.drawLine(bottom, innerBottom, spinePaint);
      canvas.drawLine(left, innerLeft, spinePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return oldDelegate.starRect != starRect ||
        oldDelegate.angle != angle ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.tipTaper != tipTaper ||
        oldDelegate.tipDepth != tipDepth ||
        oldDelegate.innerHoleRatio != innerHoleRatio ||
        oldDelegate.drawSpineLines != drawSpineLines;
  }
}
