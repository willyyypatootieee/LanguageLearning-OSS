import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../widgets/mic_waveform_placeholder.dart';

/// Video call-like screen for practicing with AI bear
class PracticeVideoCallScreen extends StatefulWidget {
  const PracticeVideoCallScreen({super.key});

  @override
  State<PracticeVideoCallScreen> createState() =>
      _PracticeVideoCallScreenState();
}

class _PracticeVideoCallScreenState extends State<PracticeVideoCallScreen>
    with TickerProviderStateMixin {
  RiveAnimationController? _bearController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    // Initialize other animations
    _fadeController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _bearController?.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    // Try to find a state machine controller
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1', // Try common state machine name
    );

    if (controller != null) {
      artboard.addController(controller);
      setState(() {
        _bearController = controller;
      });
    } else {
      // Fallback to simple animation if no state machine found
      final simpleController = SimpleAnimation('idle', autoplay: true);
      artboard.addController(simpleController);
      setState(() {
        _bearController = simpleController;
      });
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _endCall() {
    appRouter.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(
            children: [
              // Top bar with back button and title
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _endCall,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Ngobrol Sama Beruang 🐻',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main video area
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    child: Stack(
                      children: [
                        // Bear animation
                        Positioned.fill(
                          child: RiveAnimation.asset(
                            'assets/animation/bear.riv',
                            onInit: _onRiveInit,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // User video (small preview)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                ),
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: MicWaveformPlaceholder(isActive: !_isMuted),
                ),
              ),

              const SizedBox(height: AppConstants.spacingL),

              // Control buttons
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    _VideoCallButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      isActive: !_isMuted,
                      onTap: _toggleMute,
                      label: _isMuted ? 'Unmute' : 'Mute',
                    ),

                    // End call button
                    _VideoCallButton(
                      icon: Icons.call_end,
                      isActive: false,
                      onTap: _endCall,
                      label: 'End',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom video call control button
class _VideoCallButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String label;
  final Color? color;

  const _VideoCallButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.label,
    this.color,
  });

  @override
  State<_VideoCallButton> createState() => _VideoCallButtonState();
}

class _VideoCallButtonState extends State<_VideoCallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        widget.color ??
        (widget.isActive ? AppColors.primary : AppColors.gray600);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: Colors.white, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
