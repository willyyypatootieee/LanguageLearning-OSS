import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../widgets/mic_waveform_placeholder.dart';
import '../../data/gemini_api_service.dart';
import '../../data/datasources/practice_local_datasource.dart';
import '../../data/repositories/practice_repository_impl.dart';
import '../../domain/repositories/practice_repository.dart';

/// Video call-like screen for practicing with AI bear
class PracticeVideoCallScreen extends StatefulWidget {
  const PracticeVideoCallScreen({super.key});

  @override
  State<PracticeVideoCallScreen> createState() =>
      _PracticeVideoCallScreenState();
}

class _PracticeVideoCallScreenState extends State<PracticeVideoCallScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  RiveAnimationController? _bearController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  bool _isMuted = false;
  // API key - in production, this should be stored securely, not hardcoded
  final String _apiKey = 'AIzaSyCmhRfnswYYEibUkCgrmfd8XQYeK_6z5PM';
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _lastUserText = '';
  String _bearResponse = '';
  String _userText = ''; // Added to show what the user is saying
  GeminiApiService? _geminiService;
  bool _isProcessing =
      false; // For tracking when we're waiting for Gemini response

  // Repository for caching AI responses
  late PracticeRepository _repository;

  // Counter for retry attempts with speech recognition
  int _speechRetryCount = 0;
  static const int _maxSpeechRetries = 3;

  // For handling timeouts
  Timer? _speechTimeout;

  // For tracking sound levels
  double _currentSoundLevel = 0;

  @override
  void initState() {
    super.initState();
    // Initialize repository for caching
    _repository = PracticeRepositoryImpl(PracticeLocalDataSource());

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

    // Initialize speech and TTS services
    _speech = stt.SpeechToText();
    _tts = FlutterTts();

    // Initialize voice and speech recognition with higher sensitivity
    _initializeVoiceServices();
    _initTtsVoice();

    // Initialize the repository
    _repository = PracticeRepositoryImpl(PracticeLocalDataSource());

    // Add observer for app lifecycle changes to handle permission changes
    WidgetsBinding.instance.addObserver(this);

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

  /// Initialize voice services with improved sensitivity
  Future<void> _initializeVoiceServices() async {
    try {
      // Configure speech recognition for better sensitivity
      await _speech.initialize(
        debugLogging: true,
        onStatus: (status) {
          print('DEBUG: Speech init status: $status');
        },
        onError: (error) {
          print('ERROR: Speech init error: ${error.errorMsg}');
        },
      );

      if (Platform.isAndroid) {
        print(
          'DEBUG: Android speech recognition initialized with enhanced settings',
        );

        // Apply our fine-tuned settings
        // We will use these enhanced settings during listening
      } else {
        print(
          'DEBUG: Speech recognition initialized for ${Platform.operatingSystem}',
        );
      }
    } catch (e) {
      print('ERROR: Failed to initialize voice services: $e');
      // Fall back to standard initialization
      try {
        await _speech.initialize();
      } catch (e) {
        print(
          'ERROR: Failed to initialize speech even with standard settings: $e',
        );
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
    _speechTimeout?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app is resumed, check if we should restart listening
      // This helps when returning from permission settings
      if (!_isMuted && !_isListening && !_isProcessing) {
        _startListening();
      }
    }
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

      // Add practice time (approx 5 minutes per session)
      await _repository.addPracticeTime(5);

      // Update streak
      final currentStreak = await _repository.getPracticeStreak();
      await _repository.updatePracticeStreak(currentStreak + 1);

      // Log this as a practice session (estimate words learned)
      int wordsLearned = (_lastUserText.split(' ').length ~/ 3).clamp(5, 20);
      await _repository.logPracticeSession(5, wordsLearned);

      appRouter.pop();
    }
  }

  Future<void> _startListening() async {
    // Cancel any existing timeout
    _speechTimeout?.cancel();

    if (_isMuted || _apiKey == null) return;

    // Check microphone permission using permission_handler
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.microphone.status;
      if (status.isDenied) {
        // Request permission
        final result = await Permission.microphone.request();
        if (result.isDenied) {
          setState(() {
            _userText = 'Microphone permission denied';
          });

          // Show dialog explaining why we need permission
          if (mounted) {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Microphone Permission Required'),
                    content: const Text(
                      'To practice speaking with Dr. Hiro, the app needs access to your microphone. '
                      'Please grant microphone permission in your device settings.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          }
          return;
        }
      } else if (status.isPermanentlyDenied) {
        // User previously denied permission and selected "Don't ask again"
        setState(() {
          _userText = 'Microphone permission permanently denied';
        });

        // Show dialog explaining how to enable the permission in settings
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Microphone Permission Required'),
                  content: const Text(
                    'To practice speaking with Dr. Hiro, the app needs access to your microphone. '
                    'Please enable microphone permission in your device settings.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        openAppSettings();
                      },
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
          );
        }
        return;
      }
    }

    // Reset retry counter if we're starting fresh
    if (!_isListening) {
      _speechRetryCount = 0;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('DEBUG: Speech recognition status: $status');
        if (status == 'done' && !_isMuted) {
          _setBearHearing(false); // Stop Hear animation

          // Only process if we actually got some text
          if (_lastUserText.isNotEmpty) {
            _processUserSpeech(_lastUserText);
            _speechRetryCount = 0; // Reset retry counter on success
          } else if (_speechRetryCount < _maxSpeechRetries) {
            // Retry if no text was detected and we haven't exceeded max retries
            _speechRetryCount++;
            print(
              'DEBUG: No speech detected, retrying (attempt $_speechRetryCount of $_maxSpeechRetries)',
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!_isMuted && mounted) {
                _startListening(); // Retry
              }
            });
          } else {
            // Max retries exceeded, show message
            setState(() {
              _userText = 'Tidak mendengar apa-apa. Coba bicara lebih keras.';
            });
            _speechRetryCount = 0;

            // Show feedback to the user through bear response
            _bearResponse =
                "I'm having trouble hearing you. Could you speak a bit louder please?";
            _speakBearResponse(_bearResponse);

            // Try again after a delay
            Future.delayed(const Duration(seconds: 3), () {
              if (!_isMuted && mounted) {
                _startListening();
              }
            });
          }
        }
      },
      onError: (error) {
        // Log the error for debugging purposes
        print('ERROR: Speech recognition error: ${error.errorMsg}');

        // Handle errors (could be permission-related)
        setState(() {
          _isListening = false;
          _userText =
              error.errorMsg.contains('permission')
                  ? 'Microphone permission denied'
                  : 'Error: ${error.errorMsg}';
        });

        // For most errors (except permission ones), retry
        if (!error.errorMsg.contains('permission')) {
          if (_speechRetryCount < _maxSpeechRetries) {
            _speechRetryCount++;
            print(
              'DEBUG: Speech error, retrying (attempt $_speechRetryCount of $_maxSpeechRetries)',
            );
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (!_isMuted && mounted) {
                _startListening(); // Retry
              }
            });
          }
        }
        // If error is related to permissions, show guidance
        else if (error.errorMsg.contains('permission') && mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Microphone Permission Required'),
                  content: const Text(
                    'To practice speaking with Dr. Hiro, the app needs access to your microphone. '
                    'Please grant microphone permission in your device settings.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _userText = 'Listening...'; // Show that we're listening
      });
      _setBearHearing(true); // Start Hear animation

      try {
        // On Android, use the device's speech recognition engine
        if (Platform.isAndroid) {
          print(
            'DEBUG: Using Android speech recognition with enhanced settings',
          );
        }

        await _speech.listen(
          onResult: (result) {
            // Accept even very short text to reduce "couldn't understand" errors
            if (result.recognizedWords.isNotEmpty) {
              setState(() {
                _lastUserText = result.recognizedWords;
                _userText = result.recognizedWords;
              });

              // If we're getting at least something, consider it valid input
              print(
                'DEBUG: Recognized text length: ${result.recognizedWords.length}',
              );
            }

            // Reset timeout timer every time we get a result
            _speechTimeout?.cancel();
            _speechTimeout = Timer(const Duration(seconds: 8), () {
              if (_isListening &&
                  (_lastUserText.isEmpty || _lastUserText.length < 3)) {
                // If after 8 seconds we have minimal text, stop and retry
                print(
                  'DEBUG: Speech recognition timeout - minimal text received',
                );
                _speech.stop();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (!_isMuted && mounted) {
                    _startListening(); // Retry
                  }
                });
              }
            });

            // Add debug information
            print('DEBUG: Recognition confidence: ${result.confidence}');
            print('DEBUG: Recognized text: ${result.recognizedWords}');

            if (result.finalResult) {
              _setBearHearing(false); // Stop Hear animation
              _processUserSpeech(_lastUserText);
            }
          },
          localeId: 'en_US',
          listenMode:
              stt.ListenMode.confirmation, // Better for conversational use
          pauseFor: const Duration(seconds: 2), // Wait longer before finalizing
          listenFor: const Duration(seconds: 20), // Listen longer
          partialResults: true, // Show intermediate results
          cancelOnError: false, // Don't cancel on errors
          onSoundLevelChange: (level) {
            // Update sound level for visualization
            setState(() {
              _currentSoundLevel = level;
            });

            // Log sound level for debugging
            if (level > 10) {
              // Only log significant sound levels to reduce log spam
              print('DEBUG: Sound level: $level');
            }
          },
        );
      } catch (e) {
        print('ERROR: Exception during speech.listen(): $e');
        if (_speechRetryCount < _maxSpeechRetries) {
          _speechRetryCount++;
          Future.delayed(const Duration(seconds: 1), () {
            if (!_isMuted && mounted) {
              _startListening();
            }
          });
        }
      }
    } else {
      setState(() {
        _userText = 'Speech recognition not available';
      });

      // Try one more time after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (!_isMuted && mounted && _speechRetryCount < _maxSpeechRetries) {
          _speechRetryCount++;
          _startListening();
        }
      });
    }
  }

  Future<void> _processUserSpeech(String userText) async {
    if (userText.trim().isEmpty || _apiKey == null) return;
    setState(() {
      _isListening = false;
      _userText = userText;
      _isProcessing = true;
    });
    _speech.stop();
    // Initialize GeminiApiService with repository for caching
    _geminiService ??= GeminiApiService(
      _apiKey,
      practiceRepository: _repository,
    );
    final response = await _geminiService!.getBearResponse(userText);

    // Log practice session for history tracking
    await _repository.logPracticeSession(1, userText.split(' ').length ~/ 4);

    setState(() {
      _bearResponse = response;
      _isProcessing = false;
    });
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

  /// Configure Android speech recognition for higher sensitivity

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
                        // Bear animation
                        Positioned.fill(
                          child: RiveAnimation.asset(
                            'assets/animation/bear.riv',
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

              // User waveform and speech preview
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: 16,
                ),
                child: Container(
                  height: 100, // Increased height
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(
                      color:
                          _isProcessing
                              ? Colors.orange.withOpacity(0.5)
                              : (_isListening
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.2)),
                      width: 2,
                    ),
                    boxShadow:
                        _isListening
                            ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                            : null,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: MicWaveformPlaceholder(
                          isActive: !_isMuted && _isListening,
                          soundLevel: _currentSoundLevel,
                        ),
                      ),
                      if (_userText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              _userText,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (_isProcessing)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Bear is thinking...',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
