import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../view/home_screen.dart';

class SplashController extends ChangeNotifier implements TickerProvider {
  late final AnimationController _animationController;

  bool _isDisposed = false;
  bool _isButtonPressed = false;
  bool _isNavigating = false;

  SplashController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _animationController.addListener(() {
      if (!_isDisposed) {
        notifyListeners();
      }
    });

    // Auto-start animation on creation
    _animationController.forward();
  }

  AnimationController get animationController => _animationController;
  Animation<double> get animation => _animationController;
  double get progress => _animationController.value;
  bool get isCompleted => _animationController.isCompleted;
  bool get isButtonPressed => _isButtonPressed;
  bool get isButtonActive => isCompleted || progress >= 0.98;

  void setButtonPressed(bool pressed) {
    if (_isButtonPressed != pressed && !_isDisposed) {
      _isButtonPressed = pressed;
      notifyListeners();
    }
  }

  Future<void> onGetStartedTap(BuildContext context) async {
    if (!isButtonActive || _isNavigating || _isDisposed) return;

    _isNavigating = true;
    setButtonPressed(true);

    // Tactile press-down feel matching _FocusScoreCard
    await Future.delayed(const Duration(milliseconds: 120));
    if (!_isDisposed) {
      setButtonPressed(false);
    }

    // Spring release feel
    await Future.delayed(const Duration(milliseconds: 60));
    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    _isNavigating = false;
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
