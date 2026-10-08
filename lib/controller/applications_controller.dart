import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ApplicationsController extends ChangeNotifier
    implements TickerProvider {
  late final AnimationController _animationController;

  late final Animation<double> _topBarFade;
  late final Animation<Offset> _topBarSlide;
  late final Animation<double> _titleScale;
  late final Animation<double> _searchIconScale;

  late final Animation<Offset> _dribbbleSlide;
  late final Animation<double> _dribbbleFade;
  late final Animation<double> _dribbbleBadgeScale;
  late final Animation<double> _dribbbleTextFade;

  late final Animation<Offset> _instagramSlide;
  late final Animation<double> _instagramFade;
  late final Animation<double> _instagramBadgeScale;
  late final Animation<double> _instagramTextFade;

  late final Animation<Offset> _whatsappSlide;
  late final Animation<double> _whatsappFade;
  late final Animation<double> _whatsappBadgeScale;
  late final Animation<double> _whatsappTextFade;

  late final Animation<Offset> _clickupSlide;
  late final Animation<double> _clickupFade;
  late final Animation<double> _clickupBadgeScale;
  late final Animation<double> _clickupTextFade;

  late final Animation<double> _moderateFocusScale;
  late final Animation<double> _lastActiveScale;

  late final Animation<double> _timingCountProgress;
  late final Animation<double> _progressBarProgress;
  late final Animation<double> _durationCountdownProgress;

  late final Animation<Offset> _chartXAxisSlide;
  late final Animation<double> _chartXAxisFade;
  late final Animation<double> _chartBarsProgress;
  late final Animation<double> _coralPeakColorProgress;

  bool _isDisposed = false;

  ApplicationsController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // 0. Top Bar entrance
    _topBarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );
    _topBarSlide = Tween<Offset>(
      begin: const Offset(0.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOutCubic),
      ),
    );

    // Top nav title zooms in and goes back to normal size
    _titleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 55,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.06, 0.45, curve: Curves.linear),
      ),
    );

    // Top nav search icon zooms in and goes back to normal size
    _searchIconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 55,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.06, 0.45, curve: Curves.linear),
      ),
    );

    // 1. Dribbble Card (bottom of deck)
    _dribbbleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.04, 0.24, curve: Curves.easeOutCubic),
      ),
    );
    _dribbbleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.04, 0.18, curve: Curves.easeOut),
      ),
    );
    _dribbbleBadgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.22, 0.44, curve: Curves.easeOutBack),
      ),
    );
    _dribbbleTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.22, 0.46, curve: Curves.easeOut),
      ),
    );

    // 2. Instagram Card
    _instagramSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.7),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.18, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _instagramFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.18, 0.30, curve: Curves.easeOut),
      ),
    );
    _instagramBadgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.36, 0.58, curve: Curves.easeOutBack),
      ),
    );
    _instagramTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.36, 0.60, curve: Curves.easeOut),
      ),
    );

    // 3. Whatsapp Card
    _whatsappSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.7),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOutCubic),
      ),
    );
    _whatsappFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.44, curve: Curves.easeOut),
      ),
    );
    _whatsappBadgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.50, 0.72, curve: Curves.easeOutBack),
      ),
    );
    _whatsappTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.50, 0.74, curve: Curves.easeOut),
      ),
    );

    // 4. Clickup Card
    _clickupSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.7),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.46, 0.66, curve: Curves.easeOutCubic),
      ),
    );
    _clickupFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.46, 0.58, curve: Curves.easeOut),
      ),
    );
    _clickupBadgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.64, 0.86, curve: Curves.easeOutBack),
      ),
    );
    _clickupTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.64, 0.88, curve: Curves.easeOut),
      ),
    );

    // 5. "Moderate focus impact" & "Last active" Zoom in
    _moderateFocusScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.48, curve: Curves.easeOutBack),
      ),
    );
    _lastActiveScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.28, 0.50, curve: Curves.easeOutBack),
      ),
    );

    // 6. Timing count up (7:55), progress bar growth, and countdown from 4 min 20 sec -> 4 min 3 sec
    _timingCountProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _progressBarProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.68, curve: Curves.easeOutCubic),
      ),
    );
    _durationCountdownProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Dribbble Bar Chart: X-axis slide from left, bars growth, and coral color shift
    _chartXAxisSlide = Tween<Offset>(
      begin: const Offset(-0.35, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.48, curve: Curves.easeOutCubic),
      ),
    );
    _chartXAxisFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.26, 0.44, curve: Curves.easeOut),
      ),
    );
    _chartBarsProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.36, 0.74, curve: Curves.easeOutCubic),
      ),
    );
    _coralPeakColorProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.68, 0.94, curve: Curves.easeInOutCubic),
      ),
    );

    _animationController.addListener(() {
      if (!_isDisposed) {
        notifyListeners();
      }
    });

    // Auto-start card animations on screen open
    _animationController.forward();
  }

  AnimationController get animationController => _animationController;

  Animation<double> get topBarFade => _topBarFade;
  Animation<Offset> get topBarSlide => _topBarSlide;
  Animation<double> get titleScale => _titleScale;
  Animation<double> get searchIconScale => _searchIconScale;

  Animation<Offset> get dribbbleSlide => _dribbbleSlide;
  Animation<double> get dribbbleFade => _dribbbleFade;
  Animation<double> get dribbbleBadgeScale => _dribbbleBadgeScale;
  Animation<double> get dribbbleTextFade => _dribbbleTextFade;

  Animation<Offset> get instagramSlide => _instagramSlide;
  Animation<double> get instagramFade => _instagramFade;
  Animation<double> get instagramBadgeScale => _instagramBadgeScale;
  Animation<double> get instagramTextFade => _instagramTextFade;

  Animation<Offset> get whatsappSlide => _whatsappSlide;
  Animation<double> get whatsappFade => _whatsappFade;
  Animation<double> get whatsappBadgeScale => _whatsappBadgeScale;
  Animation<double> get whatsappTextFade => _whatsappTextFade;

  Animation<Offset> get clickupSlide => _clickupSlide;
  Animation<double> get clickupFade => _clickupFade;
  Animation<double> get clickupBadgeScale => _clickupBadgeScale;
  Animation<double> get clickupTextFade => _clickupTextFade;

  Animation<double> get moderateFocusScale => _moderateFocusScale;
  Animation<double> get lastActiveScale => _lastActiveScale;

  Animation<double> get timingCountProgress => _timingCountProgress;
  Animation<double> get progressBarProgress => _progressBarProgress;
  Animation<double> get durationCountdownProgress => _durationCountdownProgress;

  Animation<Offset> get chartXAxisSlide => _chartXAxisSlide;
  Animation<double> get chartXAxisFade => _chartXAxisFade;
  Animation<double> get chartBarsProgress => _chartBarsProgress;
  Animation<double> get coralPeakColorProgress => _coralPeakColorProgress;

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
