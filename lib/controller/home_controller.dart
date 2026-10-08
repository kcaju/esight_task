import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../view/applications_screen.dart';

class HomeController extends ChangeNotifier implements TickerProvider {
  late final AnimationController _animationController;

  late final Animation<double> _avatarScale;
  late final Animation<double> _avatarFade;
  late final Animation<double> _headerTextHighlight;

  late final Animation<Offset> _startButtonSlide;
  late final Animation<double> _startButtonFade;

  late final Animation<Offset> _focusCardSlide;
  late final Animation<double> _focusCardFade;
  late final Animation<double> _focusCardTextProgress;
  late final Animation<double> _badge1Scale;
  late final Animation<double> _badge2Scale;
  late final Animation<double> _badge3Scale;
  late final Animation<double> _badge4Scale;
  late final Animation<double> _badge5Scale;

  late final Animation<Offset> _screenTimeCardSlide;
  late final Animation<double> _screenTimeCardFade;
  late final Animation<double> _screenTimeTextProgress;
  late final Animation<double> _screenTimeCountProgress;

  late final Animation<double> _waveGraphProgress;
  late final Animation<double> _cursorLineProgress;
  late final Animation<double> _cursorLineFadePulse;

  bool _isFocusCardPressed = false;
  bool _isDisposed = false;

  HomeController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    // 1. Avatar circle zoom in animation
    _avatarScale = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.26, curve: Curves.easeInOutCubic),
      ),
    );
    _avatarFade = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.14, curve: Curves.easeOut),
      ),
    );
    // Header text highlights from left to right while staying in place
    _headerTextHighlight = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.06, 0.32, curve: Curves.easeInOutCubic),
      ),
    );

    // 2. Start Focus Session Button comes up from bottom of screen
    _startButtonSlide =
        Tween<Offset>(begin: const Offset(0.0, 1.8), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.02, 0.20, curve: Curves.easeOutCubic),
          ),
        );
    _startButtonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.02, 0.14, curve: Curves.easeOut),
      ),
    );

    // 3. Focus Score Card comes up from behind StartFocusSessionButton
    _focusCardSlide =
        Tween<Offset>(begin: const Offset(0.0, 1.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.14, 0.32, curve: Curves.easeOutCubic),
          ),
        );
    _focusCardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.14, 0.26, curve: Curves.easeOut),
      ),
    );
    // Focus score card texts fade in letter by letter as card comes up
    _focusCardTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.16, 0.40, curve: Curves.easeInOutCubic),
      ),
    );

    // App Badges inside Focus Score Card pop out as card comes up
    _badge1Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.20, 0.42, curve: Curves.easeOutBack),
      ),
    );
    _badge2Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.23, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _badge3Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.48, curve: Curves.easeOutBack),
      ),
    );
    _badge4Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.29, 0.51, curve: Curves.easeOutBack),
      ),
    );
    _badge5Scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.54, curve: Curves.easeOutBack),
      ),
    );

    // 4. Screen Time Card comes up from behind FocusScoreCard and settles in place (completes at 0.45)
    _screenTimeCardSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.9), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.26, 0.45, curve: Curves.easeOutCubic),
          ),
        );
    _screenTimeCardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.38, curve: Curves.easeOut),
      ),
    );
    // Screen time card texts fade in letter by letter as card comes up
    _screenTimeTextProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.28, 0.48, curve: Curves.easeInOutCubic),
      ),
    );
    // 2:25 text increases from 0:00 at a gentle reduced speed alongside the wave graph (0.26 -> 0.76)
    _screenTimeCountProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.86, curve: Curves.easeInOutCubic),
      ),
    );

    // 5. Graph dot and line path starts at the same time 2:25 starts increasing from 0:00 (0.26 -> 0.76)
    _waveGraphProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.76, curve: Curves.easeInOutCubic),
      ),
    );

    // 6. Vertical indicator line rises up as dot approaches the last curve (0.60 -> 0.76)
    _cursorLineProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.60, 0.76, curve: Curves.easeOutCubic),
      ),
    );

    // 7. After dot and line stop, vertical indicator line fades to light grey and returns to original color (0.77 -> 0.98)
    _cursorLineFadePulse =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOutCubic)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeInOutCubic)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.77, 0.98, curve: Curves.linear),
          ),
        );

    _animationController.addListener(() {
      if (!_isDisposed) {
        notifyListeners();
      }
    });

    // Auto-start entrance animation on creation
    _animationController.forward();
  }

  AnimationController get animationController => _animationController;

  Animation<double> get avatarScale => _avatarScale;
  Animation<double> get avatarFade => _avatarFade;
  Animation<double> get headerTextHighlight => _headerTextHighlight;

  Animation<Offset> get startButtonSlide => _startButtonSlide;
  Animation<double> get startButtonFade => _startButtonFade;

  Animation<Offset> get focusCardSlide => _focusCardSlide;
  Animation<double> get focusCardFade => _focusCardFade;
  Animation<double> get focusCardTextProgress => _focusCardTextProgress;
  Animation<double> get badge1Scale => _badge1Scale;
  Animation<double> get badge2Scale => _badge2Scale;
  Animation<double> get badge3Scale => _badge3Scale;
  Animation<double> get badge4Scale => _badge4Scale;
  Animation<double> get badge5Scale => _badge5Scale;

  Animation<Offset> get screenTimeCardSlide => _screenTimeCardSlide;
  Animation<double> get screenTimeCardFade => _screenTimeCardFade;
  Animation<double> get screenTimeTextProgress => _screenTimeTextProgress;
  Animation<double> get screenTimeCountProgress => _screenTimeCountProgress;

  Animation<double> get waveGraphProgress => _waveGraphProgress;
  Animation<double> get cursorLineProgress => _cursorLineProgress;
  Animation<double> get cursorLineFadePulse => _cursorLineFadePulse;

  bool get isFocusCardPressed => _isFocusCardPressed;

  void setFocusCardPressed(bool pressed) {
    if (_isFocusCardPressed != pressed) {
      _isFocusCardPressed = pressed;
      notifyListeners();
    }
  }

  void onFocusCardTap(BuildContext context) async {
    setFocusCardPressed(true);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!_isDisposed) {
      setFocusCardPressed(false);
    }
    if (!context.mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ApplicationsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slideAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
        reverseTransitionDuration: const Duration(milliseconds: 650),
      ),
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  void startAnimation() {
    if (!_isDisposed) {
      _animationController.forward(from: 0.0);
    }
  }

  void restartAnimation() {
    if (!_isDisposed) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }
}
