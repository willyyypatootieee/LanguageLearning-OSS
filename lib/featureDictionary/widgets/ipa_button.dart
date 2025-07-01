import 'package:flutter/material.dart';
import '../../core/services/tts_service.dart';
import '../../core/constants/app_constants.dart';

enum IPAButtonSize { small, medium, large }

class IPASymbolButton extends StatefulWidget {
  final String symbol;
  final String label;
  final String example;
  final IPAButtonSize size;
  final int index;

  const IPASymbolButton({
    super.key,
    required this.symbol,
    required this.label,
    required this.example,
    this.size = IPAButtonSize.small,
    this.index = 0,
  });

  @override
  State<IPASymbolButton> createState() => _IPASymbolButtonState();
}

class _IPASymbolButtonState extends State<IPASymbolButton>
    with SingleTickerProviderStateMixin {
  bool _isSpeaking = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _buttonWidth {
    switch (widget.size) {
      case IPAButtonSize.small:
        return 85;
      case IPAButtonSize.medium:
        return 110;
      case IPAButtonSize.large:
        return 140;
    }
  }

  double get _buttonHeight {
    switch (widget.size) {
      case IPAButtonSize.small:
        return 100;
      case IPAButtonSize.medium:
        return 120;
      case IPAButtonSize.large:
        return 160;
    }
  }

  Color get _gradientColor {
    // Create different gradient colors based on button index for variety
    List<Color> colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.secondary,
      AppColors.success,
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
    ];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              width: _buttonWidth,
              height: _buttonHeight,
              margin: const EdgeInsets.all(2),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTapDown: (_) => _animationController.forward(),
                  onTapUp: (_) => _animationController.reverse(),
                  onTapCancel: () => _animationController.reverse(),
                  onTap: () async {
                    if (_isSpeaking) return;

                    setState(() {
                      _isSpeaking = true;
                    });

                    try {
                      final ttsService = TTSService();
                      await ttsService.speak(widget.example);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text('Speaking: ${widget.example}'),
                              ],
                            ),
                            backgroundColor: _gradientColor,
                            duration: const Duration(milliseconds: 1000),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isSpeaking = false;
                        });
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _gradientColor.withOpacity(0.1),
                          _gradientColor.withOpacity(0.05),
                          Colors.white.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _gradientColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _gradientColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.9),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        widget.size == IPAButtonSize.large ? 16 : 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isSpeaking)
                            Container(
                              width:
                                  widget.size == IPAButtonSize.large ? 40 : 30,
                              height:
                                  widget.size == IPAButtonSize.large ? 40 : 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _gradientColor,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: EdgeInsets.all(
                                widget.size == IPAButtonSize.large ? 12 : 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _gradientColor,
                                    _gradientColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _gradientColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.symbol,
                                style: TextStyle(
                                  fontSize:
                                      widget.size == IPAButtonSize.large
                                          ? 32
                                          : widget.size == IPAButtonSize.medium
                                          ? 28
                                          : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          SizedBox(
                            height: widget.size == IPAButtonSize.large ? 8 : 4,
                          ),

                          Flexible(
                            child: Text(
                              widget.label,
                              style: TextStyle(
                                fontSize:
                                    widget.size == IPAButtonSize.large
                                        ? 14
                                        : 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Flexible(
                            child: Text(
                              widget.example,
                              style: TextStyle(
                                fontSize:
                                    widget.size == IPAButtonSize.large
                                        ? 12
                                        : 10,
                                color: _gradientColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
