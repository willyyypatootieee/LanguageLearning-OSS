import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../widgets/mic_waveform_placeholder.dart';
import '../../data/gemini_api_service.dart';

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
  final String? _apiKey = 'AIzaSyCmhRfnswYYEibUkCgrmfd8XQYeK_6z5PM';
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _lastUserText = '';
  String _bearResponse = '';
  GeminiApiService? _geminiService;

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
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _initTtsVoice();
    // Bear greets the user on call start
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      const greeting =
          "HI! I'm Dr Hiro, here I will accompany you on this voice call.";
      setState(() => _bearResponse = greeting);
      _setBearTalking(false); // Ensure not talking before
      await Future.delayed(const Duration(milliseconds: 100));
      _setBearTalking(true); // Start talk animation
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(greeting);
      _setBearTalking(false); // Stop talk animation
      await Future.delayed(const Duration(milliseconds: 400));
      const followUp = "How are you today?";
      setState(() => _bearResponse = followUp);
      _setBearTalking(true); // Start talk animation
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(followUp);
      _setBearTalking(false); // Stop talk animation
      if (!_isMuted) _startListening();
    });
  }

  Future<void> _initTtsVoice() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.25); // more human-like speed
    await _tts.setPitch(1.0); // natural pitch
    await _tts.setVolume(1.0);
    // Try to select a high-quality US English voice (male or female, for AI variety)
    final voices = await _tts.getVoices;
    if (voices is List) {
      // Try to find a male US English voice first
      final usMaleVoices =
          voices.where((v) {
            final name = v['name']?.toString().toLowerCase() ?? '';
            final locale = v['locale']?.toString().toLowerCase() ?? '';
            return (locale.contains('en-us') || name.contains('en-us')) &&
                (name.contains('male') ||
                    name.contains('mal') ||
                    name.contains('en-us-x-sfg#male_1') ||
                    name.contains('en-us-x-tpc-local'));
          }).toList();
      if (usMaleVoices.isNotEmpty) {
        await _tts.setVoice(usMaleVoices.first);
        return;
      }
      // Fallback: try to find a female US English voice
      final usFemaleVoices =
          voices.where((v) {
            final name = v['name']?.toString().toLowerCase() ?? '';
            final locale = v['locale']?.toString().toLowerCase() ?? '';
            return (locale.contains('en-us') || name.contains('en-us')) &&
                (name.contains('female') ||
                    name.contains('fem') ||
                    name.contains('en-us-x-sfg#female_1') ||
                    name.contains('en-us-x-iom-local') ||
                    name.contains('en-us-x-tpc-local'));
          }).toList();
      if (usFemaleVoices.isNotEmpty) {
        await _tts.setVoice(usFemaleVoices.first);
        return;
      }
      // Fallback: just pick any US English voice
      final anyUsVoice = voices.firstWhere((v) {
        final name = v['name']?.toString().toLowerCase() ?? '';
        final locale = v['locale']?.toString().toLowerCase() ?? '';
        return locale.contains('en-us') || name.contains('en-us');
      }, orElse: () => null);
      if (anyUsVoice != null) {
        await _tts.setVoice(anyUsVoice);
      }
    }
  }

  @override
  void dispose() {
    _bearController?.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _speech.stop();
    _tts.stop();
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
    if (!_isMuted) {
      _startListening();
    } else {
      _speech.stop();
    }
  }

  void _endCall() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text(
              'Apakah kamu yakin ingin mengakhiri panggilan?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya'),
              ),
            ],
          ),
    );
    if (shouldEnd == true) {
      _speech.stop();
      _tts.stop();
      appRouter.pop();
    }
  }

  Future<void> _startListening() async {
    if (_isMuted || _apiKey == null) return;
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' && !_isMuted) {
          _setBearHearing(false); // Stop Hear animation
          _processUserSpeech(_lastUserText);
        }
      },
      onError: (error) {},
    );
    if (available) {
      setState(() => _isListening = true);
      _setBearHearing(true); // Start Hear animation
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastUserText = result.recognizedWords;
          });
          if (result.finalResult) {
            _setBearHearing(false); // Stop Hear animation
            _processUserSpeech(_lastUserText);
          }
        },
        localeId: 'en_US',
      );
    }
  }

  Future<void> _processUserSpeech(String userText) async {
    if (userText.trim().isEmpty || _apiKey == null) return;
    setState(() => _isListening = false);
    _speech.stop();
    _geminiService ??= GeminiApiService(_apiKey!);
    final response = await _geminiService!.getBearResponse(userText);
    setState(() => _bearResponse = response);
    await _speakBearResponse(response);
    if (!_isMuted) _startListening();
  }

  void _setBearTalking(bool isTalking) {
    if (_bearController is StateMachineController) {
      final controller = _bearController as StateMachineController;
      final talkInput = controller.findInput<bool>('Talk');
      if (talkInput != null) {
        talkInput.value = isTalking;
      }
    }
  }

  void _setBearHearing(bool isHearing) {
    if (_bearController is StateMachineController) {
      final controller = _bearController as StateMachineController;
      final hearInput = controller.findInput<bool>('Hear');
      if (hearInput != null) {
        hearInput.value = isHearing;
      }
    }
  }

  Future<void> _speakBearResponse(String text) async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.35); // more human-like speed
    await _tts.setPitch(1.0); // natural pitch
    await _tts.setVolume(1.0);
    if (_bearController is StateMachineController) {
      final controller = _bearController as StateMachineController;
      final talkInput = controller.findInput<bool>('Talk');
      final successInput = controller.findInput('success');
      if (talkInput != null) {
        talkInput.value = true;
        await Future.delayed(const Duration(milliseconds: 80));
        await _tts.awaitSpeakCompletion(true);
        await _tts.speak(text);
        await Future.delayed(const Duration(milliseconds: 120));
        talkInput.value = false;
        // Trigger success animation after talking (for SMITrigger)
        if (successInput != null &&
            successInput.runtimeType.toString() == '_SMITrigger') {
          // Use dynamic to call fire() if available
          (successInput as dynamic).fire();
        }
      } else {
        _setBearTalking(true);
        await _tts.awaitSpeakCompletion(true);
        await _tts.speak(text);
        _setBearTalking(false);
      }
    } else {
      _setBearTalking(true);
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(text);
      _setBearTalking(false);
    }
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
                flex: 1,
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
                        // Cat animation
                        Positioned.fill(
                          child: RiveAnimation.asset(
                            'assets/animation/cat.riv',
                            onInit: _onRiveInit,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_bearResponse.isNotEmpty)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _bearResponse,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // User waveform (small preview)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: 16,
                ),
                child: Container(
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
              ),

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
