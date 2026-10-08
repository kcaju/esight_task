import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import '../utils/app_assets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFFEFF1EA);
  static const Color coralColor = Color(0xFFEB6654);
  static const Color yellowCardColor = Color(0xFFFDE5A3);
  static const Color chartGreenColor = Color(0xFF7DD56A);
  static const Color darkTextColor = Color(0xFF1E1E1E);
  static const Color mutedTextColor = Color(0xFF757575);

  static Widget buildLetterByLetterText(
    String text, {
    required double progress,
    required TextStyle style,
    Color? unhighlightedColor,
    Color? highlightedColor,
  }) {
    final unhigh =
        unhighlightedColor ??
        (style.color != null
            ? style.color!.withValues(alpha: 0.0)
            : const Color(0x001E1E1E));
    final high = highlightedColor ?? style.color ?? HomeScreen.darkTextColor;

    return Text.rich(
      TextSpan(
        children: List.generate(text.length, (index) {
          final charFraction = 1.0 / text.length;
          final charStart = index * charFraction;
          final charEnd = (index + 1) * charFraction;
          final t = ((progress - charStart) / (charEnd - charStart)).clamp(
            0.0,
            1.0,
          );

          final color = Color.lerp(unhigh, high, t);

          return TextSpan(
            text: text[index],
            style: style.copyWith(color: color),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(),
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      backgroundColor: HomeScreen.bgColor,
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenH = constraints.maxHeight;
            // Baseline screen height is ~660dp for compact phones
            final extraHeight = (screenH - 660.0).clamp(0.0, 240.0);
            final waveHeight = (100.0 + extraHeight * 0.38).clamp(100.0, 155.0);
            final headerGap = (12.0 + extraHeight * 0.12).clamp(12.0, 26.0);
            final chartTopGap = (24.0 + extraHeight * 0.18).clamp(24.0, 42.0);
            final cardBottomPadding = (20.0 + extraHeight * 0.12).clamp(20.0, 36.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Top Header Profile Bar (Avatar comes out from screen, text highlights from left to right)
                  _HeaderBar(
                    avatarScale: controller.avatarScale,
                    avatarFade: controller.avatarFade,
                    headerTextHighlight: controller.headerTextHighlight,
                  ),
                  SizedBox(height: headerGap),

                  // 2. Screen Time Card (comes up from _FocusScoreCard)
                  SlideTransition(
                    position: controller.screenTimeCardSlide,
                    child: FadeTransition(
                      opacity: controller.screenTimeCardFade,
                      child: _ScreenTimeCard(
                        waveHeight: waveHeight,
                        chartTopGap: chartTopGap,
                        bottomPadding: cardBottomPadding,
                      ),
                    ),
                  ),

                  // 3. Overlapping Focus Score Card & Focus Session Button
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // _FocusScoreCard comes up from _StartFocusSessionButton
                        SlideTransition(
                          position: controller.focusCardSlide,
                          child: FadeTransition(
                            opacity: controller.focusCardFade,
                            child: const _FocusScoreCard(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // _StartFocusSessionButton comes up from bottom of screen
                        SlideTransition(
                          position: controller.startButtonSlide,
                          child: FadeTransition(
                            opacity: controller.startButtonFade,
                            child: const _StartFocusSessionButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header Bar (Avatar, Welcome message, Settings icon)
// -----------------------------------------------------------------------------
class _HeaderBar extends StatelessWidget {
  final Animation<double> avatarScale;
  final Animation<double> avatarFade;
  final Animation<double> headerTextHighlight;

  const _HeaderBar({
    required this.avatarScale,
    required this.avatarFade,
    required this.headerTextHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar circle zoom in animation
          FadeTransition(
            opacity: avatarFade,
            child: ScaleTransition(
              scale: avatarScale,
              alignment: Alignment.center,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppAssets.profilePic,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFE57373), Color(0xFFF06292)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Welcome back, Celeste (Fades in letter by letter from left to right)
          Expanded(
            child: AnimatedBuilder(
              animation: headerTextHighlight,
              builder: (context, _) {
                final progress = headerTextHighlight.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeScreen.buildLetterByLetterText(
                      'Welcome back,',
                      progress: progress,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: HomeScreen.darkTextColor,
                      ),
                    ),
                    HomeScreen.buildLetterByLetterText(
                      'Celeste',
                      progress: progress,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: HomeScreen.darkTextColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Settings tune icon button
          AnimatedBuilder(
            animation: headerTextHighlight,
            builder: (context, child) {
              return Opacity(
                opacity: headerTextHighlight.value.clamp(0.0, 1.0),
                child: child,
              );
            },
            child: const Icon(
              Icons.tune,
              color: HomeScreen.darkTextColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Screen Time Card with Wave Chart
// -----------------------------------------------------------------------------
class _ScreenTimeCard extends StatelessWidget {
  final double waveHeight;
  final double chartTopGap;
  final double bottomPadding;

  const _ScreenTimeCard({
    this.waveHeight = 100.0,
    this.chartTopGap = 24.0,
    this.bottomPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 22.0, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title + Date Pill + Calendar (with full padding)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeScreen.buildLetterByLetterText(
                  'SCREEN TIME',
                  progress: controller.screenTimeTextProgress.value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HomeScreen.darkTextColor,
                    letterSpacing: 0.8,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.12),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Thu, June 20',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: HomeScreen.darkTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.12),
                          width: 1.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: HomeScreen.darkTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats row (2:25 Today, 0:12 Last hour, 23 Phone pickups) (with full padding)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Builder(
              builder: (context) {
                // Count up 2:25 from 0:00 as screen time card comes up
                final countProgress = controller.screenTimeCountProgress.value;
                final totalMinutes = (145 * countProgress).round();
                final hours = totalMinutes ~/ 60;
                final mins = totalMinutes % 60;
                final textProgress = controller.screenTimeTextProgress.value;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$hours',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: HomeScreen.darkTextColor,
                                  letterSpacing: -1.0,
                                  height: 1.0,
                                ),
                              ),
                              const _BlinkingColon(
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: HomeScreen.darkTextColor,
                                  letterSpacing: -1.0,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                mins.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: HomeScreen.darkTextColor,
                                  letterSpacing: -1.0,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          HomeScreen.buildLetterByLetterText(
                            'Today',
                            progress: textProgress,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: HomeScreen.mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '0:12',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: HomeScreen.darkTextColor,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          HomeScreen.buildLetterByLetterText(
                            'Last hour',
                            progress: textProgress,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: HomeScreen.mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '23',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: HomeScreen.darkTextColor,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          HomeScreen.buildLetterByLetterText(
                            'Phone pickups',
                            progress: textProgress,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: HomeScreen.mutedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: chartTopGap),

          // Custom Green Wave Line Chart (No left padding)
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 22.0),
            child: SizedBox(
              height: waveHeight,
              child: CustomPaint(
                size: Size(double.infinity, waveHeight),
                painter: _WaveChartPainter(
                  graphProgress: controller.waveGraphProgress.value,
                  cursorLineProgress: controller.cursorLineProgress.value,
                  cursorLineFadePulse: controller.cursorLineFadePulse.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // X-Axis Time Labels (No left padding)
          const Padding(
            padding: EdgeInsets.only(left: 0.0, right: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '8 AM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '10 AM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '12 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '2 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '4 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '6 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
                Text(
                  '8 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeScreen.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Wave Chart Custom Painter (Animated curve tracing, moving dot, rising cursor)
// -----------------------------------------------------------------------------
class _WaveChartPainter extends CustomPainter {
  final double graphProgress;
  final double cursorLineProgress;
  final double cursorLineFadePulse;

  const _WaveChartPainter({
    required this.graphProgress,
    required this.cursorLineProgress,
    this.cursorLineFadePulse = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final yBase = height * 0.76;
    final yStart = height * 0.38;
    final yPlateau = height * 0.14;
    final yHill = height * 0.40;
    final indicatorX = width * 0.87;
    final indicatorY = height * 0.35;
    final topTipY = height * 0.05;
    final bottomTipY = height;

    // Draw subtle horizontal graph grid lines
    final gridLinePaint = Paint()
      ..color = const Color(0xFFEAEAEA)
      ..strokeWidth = 1.0;

    // 1. Line through top tip of vertical indicator line
    canvas.drawLine(Offset(0, topTipY), Offset(width, topTipY), gridLinePaint);

    // 2. Line through the green indicator dot
    canvas.drawLine(
      Offset(0, indicatorY),
      Offset(width, indicatorY),
      gridLinePaint,
    );

    // 3. Baseline through bottom of valleys
    canvas.drawLine(Offset(0, yBase), Offset(width, yBase), gridLinePaint);

    // 4. Line through bottom tip of vertical indicator line
    canvas.drawLine(
      Offset(0, bottomTipY),
      Offset(width, bottomTipY),
      gridLinePaint,
    );

    // Build full wave line path
    final wavePath = Path();
    // 1. Starts flat at medium height near 8 AM
    wavePath.moveTo(0, yStart);
    wavePath.lineTo(width * 0.04, yStart);

    // 2. Curves down to baseline trough at 10 AM
    wavePath.cubicTo(
      width * 0.08,
      yStart,
      width * 0.09,
      yBase,
      width * 0.13,
      yBase,
    );
    wavePath.lineTo(width * 0.19, yBase);

    // 3. Rises smoothly to 12 PM flat plateau (tallest peak)
    wavePath.cubicTo(
      width * 0.23,
      yBase,
      width * 0.24,
      yPlateau,
      width * 0.28,
      yPlateau,
    );
    wavePath.lineTo(width * 0.37, yPlateau);
    // Curves down to 2 PM trough
    wavePath.cubicTo(
      width * 0.41,
      yPlateau,
      width * 0.42,
      yBase,
      width * 0.46,
      yBase,
    );
    wavePath.cubicTo(
      width * 0.48,
      yBase,
      width * 0.48,
      yBase,
      width * 0.52,
      yBase,
    );

    // 4. Medium rounded hill centered at 4 PM
    wavePath.cubicTo(
      width * 0.55,
      yBase,
      width * 0.57,
      yHill,
      width * 0.60,
      yHill,
    );
    wavePath.cubicTo(
      width * 0.63,
      yHill,
      width * 0.65,
      yBase,
      width * 0.68,
      yBase,
    );

    // 5. Flat trough at 6 PM
    wavePath.lineTo(width * 0.77, yBase);

    // 6. Rises smoothly to indicator dot at 7:30 PM
    wavePath.cubicTo(
      width * 0.81,
      yBase,
      width * 0.84,
      indicatorY,
      indicatorX,
      indicatorY,
    );

    // If graph animation hasn't started yet, only show the baseline
    if (graphProgress <= 0.0001) {
      return;
    }

    final metrics = wavePath.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final totalLength = metric.length;
    final currentLength = totalLength * graphProgress.clamp(0.0, 1.0);

    // Extract path up to current animated head
    final extractedPath = metric.extractPath(0.0, currentLength);
    final tangent = metric.getTangentForOffset(currentLength);
    final dotPosition = tangent?.position ?? Offset(0, yStart);

    // 1. Draw gradient fill under the extracted curve
    final fillPath = Path.from(extractedPath);
    fillPath.lineTo(dotPosition.dx, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HomeScreen.chartGreenColor.withValues(alpha: 0.24),
          HomeScreen.chartGreenColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // 2. Draw green stroke line
    final strokePaint = Paint()
      ..color = HomeScreen.chartGreenColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(extractedPath, strokePaint);

    // 3. Vertical indicator line (rises up from bottom and becomes darker color as dot approaches last curve)
    if (cursorLineProgress > 0.001) {
      final topY = height * 0.05;
      final bottomY = height;
      final currentTopY =
          bottomY - (bottomY - topY) * cursorLineProgress.clamp(0.0, 1.0);

      Color cursorColor = Color.lerp(
        HomeScreen.darkTextColor.withValues(alpha: 0.20),
        HomeScreen.darkTextColor,
        cursorLineProgress.clamp(0.0, 1.0),
      )!;

      // After stop: fades to light grey and comes back to original dark color
      if (cursorLineFadePulse > 0.001) {
        const lightGreyColor = Color(0xFFD0D3D8);
        cursorColor = Color.lerp(
          cursorColor,
          lightGreyColor,
          cursorLineFadePulse.clamp(0.0, 1.0),
        )!;
      }

      final cursorPaint = Paint()
        ..color = cursorColor
        ..strokeWidth = 1.6;
      canvas.drawLine(
        Offset(indicatorX, currentTopY),
        Offset(indicatorX, bottomY),
        cursorPaint,
      );
    }

    // 4. Green indicator dot at the animated head position
    final dotPaint = Paint()
      ..color = HomeScreen.chartGreenColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotPosition, 5.5, dotPaint);

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(dotPosition, 5.5, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _WaveChartPainter oldDelegate) =>
      oldDelegate.graphProgress != graphProgress ||
      oldDelegate.cursorLineProgress != cursorLineProgress ||
      oldDelegate.cursorLineFadePulse != cursorLineFadePulse;
}

// -----------------------------------------------------------------------------
// Focus Score Card (Yellow Card with App Badges and Insight Banner)
// -----------------------------------------------------------------------------
class _FocusScoreCard extends StatelessWidget {
  const _FocusScoreCard();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final isPressed = controller.isFocusCardPressed;

    return AnimatedScale(
      scale: isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onFocusCardTap(context),
          onTapDown: (_) => controller.setFocusCardPressed(true),
          onTapCancel: () => controller.setFocusCardPressed(false),
          borderRadius: BorderRadius.circular(32),
          splashColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(
              color: HomeScreen.yellowCardColor,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isPressed ? 0.04 : 0.08,
                  ),
                  blurRadius: isPressed ? 8 : 16,
                  offset: Offset(0, isPressed ? 2 : 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                HomeScreen.buildLetterByLetterText(
                  'FOCUS SCORE',
                  progress: controller.focusCardTextProgress.value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: HomeScreen.darkTextColor,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 14),

                // Score & App Icons Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Score 8.5 + Coral Sparkle Icon
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '8.5',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: HomeScreen.darkTextColor,
                                letterSpacing: -0.8,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Four-pointed coral sparkle star with 4-second opening rotation
                            const _RotatingSparkleIcon(
                              size: 34,
                              color: HomeScreen.coralColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        HomeScreen.buildLetterByLetterText(
                          'Good',
                          progress: controller.focusCardTextProgress.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: HomeScreen.darkTextColor,
                          ),
                        ),
                      ],
                    ),

                    // Most used app icon row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverlappingAppBadges(
                          scaleAnimations: [
                            controller.badge1Scale,
                            controller.badge2Scale,
                            controller.badge3Scale,
                            controller.badge4Scale,
                            controller.badge5Scale,
                          ],
                        ),
                        const SizedBox(height: 6),
                        HomeScreen.buildLetterByLetterText(
                          'Most used',
                          progress: controller.focusCardTextProgress.value,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: HomeScreen.darkTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bottom Insight banner inside Focus Card
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.6),
                          width: 1.4,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: HomeScreen.darkTextColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HomeScreen.buildLetterByLetterText(
                        'Way to go! Your screen time this week is 7% less than last week',
                        progress: controller.focusCardTextProgress.value,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: HomeScreen.darkTextColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildOverlappingAppBadges({
    List<Animation<double>>? scaleAnimations,
  }) {
    const List<String> assetImages = AppAssets.mostUsedApps;

    const double badgeSize = 35.0;
    const double overlapOffset = 25.0;
    final double totalWidth =
        badgeSize + (assetImages.length - 1) * overlapOffset;

    return SizedBox(
      width: totalWidth,
      height: badgeSize,
      child: Stack(
        children: List.generate(assetImages.length, (index) {
          Widget badge = Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                assetImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.apps, size: 14, color: Colors.grey),
                ),
              ),
            ),
          );

          if (scaleAnimations != null && index < scaleAnimations.length) {
            badge = ScaleTransition(
              scale: scaleAnimations[index],
              alignment: Alignment.center,
              child: badge,
            );
          }

          return Positioned(left: index * overlapOffset, child: badge);
        }),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Four-pointed Rotating Sparkle Icon
// -----------------------------------------------------------------------------
class _RotatingSparkleIcon extends StatefulWidget {
  final double size;
  final Color color;

  const _RotatingSparkleIcon({
    this.size = 34.0,
    this.color = HomeScreen.coralColor,
  });

  @override
  State<_RotatingSparkleIcon> createState() => _RotatingSparkleIconState();
}

class _RotatingSparkleIconState extends State<_RotatingSparkleIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 1 * math.pi,
          child: child,
        );
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _FourPointSparklePainter(color: widget.color),
      ),
    );
  }
}

class _FourPointSparklePainter extends CustomPainter {
  final Color color;

  const _FourPointSparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final path = Path();
    path.moveTo(cx, 0);
    path.quadraticBezierTo(cx, cy, w, cy);
    path.quadraticBezierTo(cx, cy, cx, h);
    path.quadraticBezierTo(cx, cy, 0, cy);
    path.quadraticBezierTo(cx, cy, cx, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FourPointSparklePainter oldDelegate) =>
      oldDelegate.color != color;
}

// -----------------------------------------------------------------------------
// Start Focus Session Bottom Button
// -----------------------------------------------------------------------------
class _StartFocusSessionButton extends StatelessWidget {
  const _StartFocusSessionButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(36),
          splashColor: Colors.black12,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: HomeScreen.coralColor,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: HomeScreen.coralColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Start Focus Session',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: HomeScreen.darkTextColor,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Last session: 2 hours ago',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A2016),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Blinking Colon Widget for Clock Display
// -----------------------------------------------------------------------------
class _BlinkingColon extends StatefulWidget {
  final TextStyle style;

  const _BlinkingColon({required this.style});

  @override
  State<_BlinkingColon> createState() => _BlinkingColonState();
}

class _BlinkingColonState extends State<_BlinkingColon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(':', style: widget.style),
    );
  }
}
