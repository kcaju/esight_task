import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/applications_controller.dart';
import '../utils/app_assets.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  static const Color bgColor = Color(0xFFEFF1EA);
  static const Color darkTextColor = Color(0xFF1E1E1E);
  static const Color mutedTextColor = Color(0xFF757575);
  static const Color coralColor = Color(0xFFEB6654);

  // Card background colors matching design
  static const Color clickupCardColor = Color(0xFFF4F6FC);
  static const Color whatsappCardColor = Color(0xFFCBEAB7);
  static const Color instagramCardColor = Color(0xFFF7B6C8);
  static const Color dribbbleCardColor = Color(0xFFFDE5A3);

  static Widget buildLetterByLetterText(
    String text, {
    required double progress,
    required TextStyle style,
    Color? unhighlightedColor,
    Color? highlightedColor,
  }) {
    final unhigh = unhighlightedColor ??
        (style.color != null
            ? style.color!.withValues(alpha: 0.0)
            : const Color(0x001E1E1E));
    final high = highlightedColor ?? style.color ?? ApplicationsScreen.darkTextColor;

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
    return ChangeNotifierProvider<ApplicationsController>(
      create: (_) => ApplicationsController(),
      child: const _ApplicationsViewBody(),
    );
  }
}

class _ApplicationsViewBody extends StatelessWidget {
  const _ApplicationsViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationsScreen.bgColor,
      body: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenH = constraints.maxHeight;
            final extraHeight = (screenH - 660.0).clamp(0.0, 260.0);
            final topNavGap = (12.0 + extraHeight * 0.10).clamp(12.0, 24.0);
            final barChartHeight = (90.0 + extraHeight * 0.35).clamp(90.0, 150.0);
            final chartTopGap = (24.0 + extraHeight * 0.18).clamp(24.0, 42.0);
            final dribbbleBottomPadding =
                (32.0 + extraHeight * 0.40).clamp(32.0, 95.0);
            final cardHeaderBottomPadding =
                (54.0 + extraHeight * 0.10).clamp(54.0, 70.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Navigation Bar (Back arrow, Applications title, Search icon)
                  const _TopNavBar(),
                  SizedBox(height: topNavGap),

                  // 4 Overlapping Cards Deck
                  _OverlappingCardsDeck(
                    barChartHeight: barChartHeight,
                    chartTopGap: chartTopGap,
                    dribbbleBottomPadding: dribbbleBottomPadding,
                    cardHeaderBottomPadding: cardHeaderBottomPadding,
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
// Top Navigation Bar
// -----------------------------------------------------------------------------
class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return FadeTransition(
      opacity: controller.topBarFade,
      child: SlideTransition(
        position: controller.topBarSlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: ApplicationsScreen.mutedTextColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  ScaleTransition(
                    scale: controller.titleScale,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Applications',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ApplicationsScreen.darkTextColor,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
              ScaleTransition(
                scale: controller.searchIconScale,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: ApplicationsScreen.darkTextColor,
                    size: 26,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Overlapping Cards Deck (Clickup -> Whatsapp -> Instagram -> Dribbble)
// -----------------------------------------------------------------------------
class _OverlappingCardsDeck extends StatelessWidget {
  final double barChartHeight;
  final double chartTopGap;
  final double dribbbleBottomPadding;
  final double cardHeaderBottomPadding;

  const _OverlappingCardsDeck({
    this.barChartHeight = 90.0,
    this.chartTopGap = 24.0,
    this.dribbbleBottomPadding = 32.0,
    this.cardHeaderBottomPadding = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Clickup Card (Top - comes up from Whatsapp)
        SlideTransition(
          position: controller.clickupSlide,
          child: FadeTransition(
            opacity: controller.clickupFade,
            child: _ClickupCard(bottomPadding: cardHeaderBottomPadding),
          ),
        ),

        // 2. Whatsapp Card (Overlaps Clickup - comes up from Instagram)
        Transform.translate(
          offset: const Offset(0, -28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SlideTransition(
                position: controller.whatsappSlide,
                child: FadeTransition(
                  opacity: controller.whatsappFade,
                  child: _WhatsappCard(bottomPadding: cardHeaderBottomPadding),
                ),
              ),

              // 3. Instagram Card (Overlaps Whatsapp - comes up from Dribbble)
              Transform.translate(
                offset: const Offset(0, -28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SlideTransition(
                      position: controller.instagramSlide,
                      child: FadeTransition(
                        opacity: controller.instagramFade,
                        child: _InstagramCard(
                          bottomPadding: cardHeaderBottomPadding,
                        ),
                      ),
                    ),

                    // 4. Dribbble Card (Overlaps Instagram - Expanded Detailed Card)
                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: SlideTransition(
                        position: controller.dribbbleSlide,
                        child: FadeTransition(
                          opacity: controller.dribbbleFade,
                          child: _DribbbleCard(
                            barChartHeight: barChartHeight,
                            chartTopGap: chartTopGap,
                            bottomPadding: dribbbleBottomPadding,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Card 1: Clickup Card
// -----------------------------------------------------------------------------
class _ClickupCard extends StatelessWidget {
  final double bottomPadding;

  const _ClickupCard({this.bottomPadding = 54.0});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Container(
      decoration: BoxDecoration(
        color: ApplicationsScreen.clickupCardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 22, 22, bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApplicationsScreen.buildLetterByLetterText(
                'Clickup',
                progress: controller.clickupTextFade.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ApplicationsScreen.darkTextColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              ApplicationsScreen.buildLetterByLetterText(
                '1:15 hrs/day',
                progress: controller.clickupTextFade.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ApplicationsScreen.mutedTextColor,
                ),
              ),
            ],
          ),
          _buildAppAssetBadge(
            AppAssets.clickup,
            scaleAnimation: controller.clickupBadgeScale,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Card 2: Whatsapp Card
// -----------------------------------------------------------------------------
class _WhatsappCard extends StatelessWidget {
  final double bottomPadding;

  const _WhatsappCard({this.bottomPadding = 54.0});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Container(
      decoration: BoxDecoration(
        color: ApplicationsScreen.whatsappCardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 22, 22, bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApplicationsScreen.buildLetterByLetterText(
                'Whatsapp',
                progress: controller.whatsappTextFade.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ApplicationsScreen.darkTextColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              ApplicationsScreen.buildLetterByLetterText(
                '1:08 hrs/day',
                progress: controller.whatsappTextFade.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A6B3D),
                ),
              ),
            ],
          ),
          _buildAppAssetBadge(
            AppAssets.whatsapp,
            scaleAnimation: controller.whatsappBadgeScale,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Card 3: Instagram Card
// -----------------------------------------------------------------------------
class _InstagramCard extends StatelessWidget {
  final double bottomPadding;

  const _InstagramCard({this.bottomPadding = 54.0});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Container(
      decoration: BoxDecoration(
        color: ApplicationsScreen.instagramCardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 22, 22, bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApplicationsScreen.buildLetterByLetterText(
                'Instagram',
                progress: controller.instagramTextFade.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ApplicationsScreen.darkTextColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              ApplicationsScreen.buildLetterByLetterText(
                '52 mins/day',
                progress: controller.instagramTextFade.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7E3B4F),
                ),
              ),
            ],
          ),
          _buildAppAssetBadge(
            AppAssets.instagram,
            scaleAnimation: controller.instagramBadgeScale,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Card 4: Dribbble Card (Expanded with Bar Chart and Details)
// -----------------------------------------------------------------------------
class _DribbbleCard extends StatelessWidget {
  final double barChartHeight;
  final double chartTopGap;
  final double bottomPadding;

  const _DribbbleCard({
    this.barChartHeight = 90.0,
    this.chartTopGap = 24.0,
    this.bottomPadding = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    // Count up 7:55 from 0:00
    final timingProg = controller.timingCountProgress.value;
    final totalMins = (475 * timingProg).round();
    final h = totalMins ~/ 60;
    final m = totalMins % 60;
    final timeStr = '$h:${m.toString().padLeft(2, '0')}';

    // Decreases from 4 min 20 sec (260s) down to 4 min 3 sec (243s) slowly as the progress indicator stops
    final countdownProg = controller.durationCountdownProgress.value;
    final totalSecs = (260 - (260 - 243) * countdownProg).round();
    final durationMins = totalSecs ~/ 60;
    final durationSecs = totalSecs % 60;
    final durationStr = '$durationMins min $durationSecs sec';

    // Progress bar width from 0 to 120
    final progressWidth = 120.0 * controller.progressBarProgress.value;

    return Container(
      decoration: BoxDecoration(
        color: ApplicationsScreen.dribbbleCardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 24, 22, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: App info + Chevron Down + Dribbble Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApplicationsScreen.buildLetterByLetterText(
                    'Dribbble',
                    progress: controller.dribbbleTextFade.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ApplicationsScreen.darkTextColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  ApplicationsScreen.buildLetterByLetterText(
                    '32 mins/day',
                    progress: controller.dribbbleTextFade.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ApplicationsScreen.mutedTextColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Dropdown circle button (pops out)
                  ScaleTransition(
                    scale: controller.dribbbleBadgeScale,
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: ApplicationsScreen.darkTextColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dribbble icon badge (pops out)
                  _buildAppAssetBadge(
                    AppAssets.dribbble,
                    scaleAnimation: controller.dribbbleBadgeScale,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Pill tag + Last active status (Pops out as _buildAppAssetBadge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScaleTransition(
                scale: controller.moderateFocusScale,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Moderate focus impact',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: controller.lastActiveScale,
                alignment: Alignment.center,
                child: const Text(
                  'Last active 34 mins ago',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ApplicationsScreen.darkTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: chartTopGap),

          // Bar Chart
          SizedBox(
            height: barChartHeight,
            child: _DribbbleBarChart(
              barsProgress: controller.chartBarsProgress.value,
              coralColorProgress: controller.coralPeakColorProgress.value,
            ),
          ),
          const SizedBox(height: 8),

          // X-Axis Time Labels (Slides in from left)
          SlideTransition(
            position: controller.chartXAxisSlide,
            child: FadeTransition(
              opacity: controller.chartXAxisFade,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '8 AM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '10 AM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '12 PM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '2 PM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '4 PM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '6 PM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                  Text(
                    '8 PM',
                    style: TextStyle(
                      fontSize: 10,
                      color: ApplicationsScreen.darkTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Stats row (42 minutes today / 5 pickups) (Fade in letter by letter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ApplicationsScreen.buildLetterByLetterText(
                '42 minutes today',
                progress: controller.dribbbleTextFade.value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: ApplicationsScreen.darkTextColor,
                  letterSpacing: -0.4,
                ),
              ),
              ApplicationsScreen.buildLetterByLetterText(
                '5 pickups',
                progress: controller.dribbbleTextFade.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Session timing row (7:55 / 4 min 3 sec) (Fade in & Count up from 0)
          FadeTransition(
            opacity: controller.dribbbleTextFade,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ApplicationsScreen.darkTextColor,
                  ),
                ),
                Text(
                  durationStr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ApplicationsScreen.darkTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Progress line (Increases from 0 to current width)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 4,
              color: Colors.black.withValues(alpha: 0.1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: progressWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ApplicationsScreen.coralColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Bar Chart Custom Painter for Dribbble Card
// -----------------------------------------------------------------------------
class _DribbbleBarChart extends StatelessWidget {
  final double barsProgress;
  final double coralColorProgress;

  const _DribbbleBarChart({
    required this.barsProgress,
    required this.coralColorProgress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 90),
      painter: _DribbbleBarChartPainter(
        barsProgress: barsProgress,
        coralColorProgress: coralColorProgress,
      ),
    );
  }
}

class _DribbbleBarChartPainter extends CustomPainter {
  final double barsProgress;
  final double coralColorProgress;

  const _DribbbleBarChartPainter({
    required this.barsProgress,
    required this.coralColorProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Subtle baseline
    final baselinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(0, height - 4),
      Offset(width, height - 4),
      baselinePaint,
    );

    // Subtle horizontal graph grid lines above/across tips of coral bars
    final gridLinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    // 1. Horizontal line across tip of 4 PM tall coral bar (0.95 height fraction)
    final y4pmTip = (height - 4) - 0.95 * (height - 8);
    canvas.drawLine(
      Offset(0, y4pmTip),
      Offset(width, y4pmTip),
      gridLinePaint,
    );

    // 2. Horizontal line across tip of 10 AM coral bar (0.65 height fraction)
    final y10amTip = (height - 4) - 0.65 * (height - 8);
    canvas.drawLine(
      Offset(0, y10amTip),
      Offset(width, y10amTip),
      gridLinePaint,
    );

    // Bar definition: (relativeX [0..1], heightFraction [0..1], isCoral)
    const bars = [
      (0.02, 0.15, false),
      (0.06, 0.10, false),
      (0.10, 0.15, false),
      (0.15, 0.45, false),
      (0.20, 0.65, true), // Coral peak at 10 AM
      (0.25, 0.30, false),
      (0.30, 0.40, true),
      (0.35, 0.60, true), // Coral peak near 12 PM
      (0.40, 0.25, false),
      (0.45, 0.15, false),
      (0.50, 0.20, false),
      (0.55, 0.15, false),
      (0.60, 0.10, false),
      (0.65, 0.95, true), // Tall Coral peak at 4 PM
      (0.70, 0.50, false),
      (0.75, 0.15, false),
      (0.80, 0.10, false),
      (0.85, 0.12, false),
      (0.90, 0.35, false),
      (0.95, 0.45, true), // Coral peak near 8 PM
      (1.00, 0.15, false),
    ];

    const barWidth = 3.5;
    const radius = Radius.circular(2.0);

    for (final bar in bars) {
      final x = bar.$1 * (width - barWidth);
      final maxBarHeight = bar.$2 * (height - 8);

      // Stagger bars from left to right as barsProgress advances
      final staggerStart = bar.$1 * 0.45;
      final barFactor =
          ((barsProgress - staggerStart) / 0.55).clamp(0.0, 1.0);
      final barHeight = maxBarHeight * barFactor;
      final y = (height - 4) - barHeight;

      if (barHeight <= 0.0) continue;

      Color barColor = ApplicationsScreen.darkTextColor;
      if (bar.$3) {
        barColor = Color.lerp(
          ApplicationsScreen.darkTextColor,
          ApplicationsScreen.coralColor,
          coralColorProgress.clamp(0.0, 1.0),
        )!;
      }

      final paint = Paint()
        ..color = barColor
        ..style = PaintingStyle.fill;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        radius,
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DribbbleBarChartPainter oldDelegate) =>
      oldDelegate.barsProgress != barsProgress ||
      oldDelegate.coralColorProgress != coralColorProgress;
}

// -----------------------------------------------------------------------------
// Helper to build circular app asset badge
// -----------------------------------------------------------------------------
Widget _buildAppAssetBadge(
  String assetPath, {
  Animation<double>? scaleAnimation,
}) {
  Widget badge = Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.apps, size: 16, color: Colors.grey),
        ),
      ),
    ),
  );

  if (scaleAnimation != null) {
    return ScaleTransition(
      scale: scaleAnimation,
      alignment: Alignment.center,
      child: badge,
    );
  }
  return badge;
}
