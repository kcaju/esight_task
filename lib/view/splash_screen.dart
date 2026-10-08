import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esight_task/controller/splash_controller.dart';
import 'package:esight_task/view/widgets/get_started_button.dart';
import 'package:esight_task/view/widgets/star_clipper.dart';
import 'package:esight_task/view/widgets/word_list_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashController>(
      create: (_) => SplashController(),
      child: const SplashViewBody(),
    );
  }
}

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  static const Color backgroundColor = Color(0xFFEB6654);
  static const Color baseTextColor = Color(0xFFBE4C3E);
  static const Color starFillColor = Color(0xFFFDE494);
  static const Color activeTextColor = Color(0xFF1E1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Consumer<SplashController>(
              builder: (context, controller, child) {
                final progress = controller.progress;

                const topOffset = 10.0;
                const lineHeight = 48.0;

                // Word baseline centers:
                // Word 0 (Goal-setting): ~34 dp
                // Word 6 (Balance): ~322 dp
                // Word 10 (Focus.): ~514 dp
                const topBarCenterY = -80.0; // Enters from top with tip already extending across early keywords
                const balanceCenterY = topOffset + 6.5 * lineHeight; // ~322 dp
                const focusCenterY = topOffset + 10.5 * lineHeight; // ~514 dp

                const startCenterX = 60.0;
                const balanceCenterX = 90.0;
                const focusCenterX = 85.0;

                // Scaled star proportions matching reference design filling the screen
                const startWidth = 280.0;
                const startHeight = 360.0;
                const balanceWidth = 360.0;
                const balanceHeight = 440.0;
                const focusWidth = 440.0;
                const focusHeight = 540.0;

                double currentCenterX;
                double currentCenterY;
                double currentWidth;
                double currentHeight;
                double currentAngle;

                // Two-phase seamless animation without pause/delay:
                // Phase 1 (0.0 -> 0.44): Rapid descent and spin from top into "Balance"
                // Phase 2 (0.44 -> 1.00): Fluidly continues sliding down across each keyword to "Focus.", gradually decelerating into place
                const phase1End = 0.44;

                if (progress <= phase1End) {
                  final t = (progress / phase1End).clamp(0.0, 1.0);
                  final easedPos = Curves.easeOutSine.transform(t);

                  currentCenterX = ui.lerpDouble(
                    startCenterX,
                    balanceCenterX,
                    easedPos,
                  )!;
                  currentCenterY = ui.lerpDouble(
                    topBarCenterY,
                    balanceCenterY,
                    easedPos,
                  )!;
                  currentWidth = ui.lerpDouble(
                    startWidth,
                    balanceWidth,
                    easedPos,
                  )!;
                  currentHeight = ui.lerpDouble(
                    startHeight,
                    balanceHeight,
                    easedPos,
                  )!;

                  // Spinning decelerates smoothly to 0 rad at Balance
                  final spinFactor = 1.0 - Curves.easeOutQuad.transform(t);
                  currentAngle = spinFactor * (-3.0 * math.pi);
                } else {
                  // Phase 2: Instantly continues downward momentum without dead stop, then gently slows down onto Focus
                  final rawT = ((progress - phase1End) / (1.0 - phase1End))
                      .clamp(0.0, 1.0);
                  final easedSlide = Curves.easeOutCubic.transform(rawT);

                  currentCenterX = ui.lerpDouble(
                    balanceCenterX,
                    focusCenterX,
                    easedSlide,
                  )!;
                  currentCenterY = ui.lerpDouble(
                    balanceCenterY,
                    focusCenterY,
                    easedSlide,
                  )!;
                  currentWidth = ui.lerpDouble(
                    balanceWidth,
                    focusWidth,
                    easedSlide,
                  )!;
                  currentHeight = ui.lerpDouble(
                    balanceHeight,
                    focusHeight,
                    easedSlide,
                  )!;

                  // Upright alignment
                  currentAngle = 0.0;
                }

                final starRect = Rect.fromCenter(
                  center: Offset(currentCenterX, currentCenterY),
                  width: currentWidth,
                  height: currentHeight,
                );

                return Stack(
                  children: [
                    // Layer 1: Base background word list in muted faded red
                    Positioned(
                      top: topOffset,
                      left: 18,
                      right: 18,
                      child: WordListView(
                        textColor: baseTextColor,
                        progress: progress,
                        lineHeight: lineHeight,
                        topOffset: topOffset,
                      ),
                    ),

                    // Layer 2: Animated Yellow Four-Pointed Star
                    // Solid opaque yellow covers and hides the words underneath its petals
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: StarPainter(
                            starRect: starRect,
                            angle: currentAngle,
                            fillColor: starFillColor,
                            tipTaper: 0.05,
                            tipDepth: 0.62,
                            innerHoleRatio: 0.22,
                            drawSpineLines: true,
                          ),
                        ),
                      ),
                    ),

                    // Layer 3: Highlighted stark solid black text
                    // Fully visible across the star center for the active framed word
                    Positioned(
                      top: topOffset,
                      left: 18,
                      right: 18,
                      child: IgnorePointer(
                        child: WordListView(
                          textColor: activeTextColor,
                          progress: progress,
                          lineHeight: lineHeight,
                          topOffset: topOffset,
                          activeStarCenterY: currentCenterY,
                        ),
                      ),
                    ),

                    // Layer 4: Bottom "Get Started" pill button
                    // Stateless widget driven by controller state management
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: MediaQuery.paddingOf(context).bottom > 0
                          ? MediaQuery.paddingOf(context).bottom + 8
                          : 28,
                      child: GetStartedButton(
                        isActive: controller.isButtonActive,
                        isPressed: controller.isButtonPressed,
                        onHoverOrPress: (pressed) =>
                            controller.setButtonPressed(pressed),
                        onPressed: () => controller.onGetStartedTap(context),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
