import 'package:flutter_tts/flutter_tts.dart';

/// Service class for handling Text-to-Speech functionality
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      // Set up completion handler to know when TTS is ready
      _flutterTts!.setCompletionHandler(() {
        print('TTS: Speech completed');
      });

      _flutterTts!.setErrorHandler((msg) {
        print('TTS Error: $msg');
      });

      // Wait longer for TTS engine to be ready
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check if TTS engines are available
      var engines = await _flutterTts!.getEngines;
      print('Available TTS engines: $engines');

      // If no engines available, still try to initialize with defaults
      if (engines.isEmpty) {
        print('No TTS engines found, attempting basic initialization');
        try {
          // Try basic configuration without language check
          await _flutterTts!.setSpeechRate(0.5);
          await _flutterTts!.setVolume(0.8);
          await _flutterTts!.setPitch(1.0);
          _isInitialized = true;
          print('TTS Initialized with basic settings: $_isInitialized');
          return;
        } catch (e) {
          print('Basic TTS initialization failed: $e');
          _isInitialized = false;
          return;
        }
      }

      // Try to set language with fallback
      bool languageSet = false;
      try {
        var result = await _flutterTts!.isLanguageAvailable("en-US");
        print('en-US available: $result');
        if (result == true) {
          await _flutterTts!.setLanguage("en-US");
          languageSet = true;
          print('Language set to en-US');
        }
      } catch (e) {
        print('Language setting failed: $e');
      }

      // If en-US failed, try just "en"
      if (!languageSet) {
        try {
          var result = await _flutterTts!.isLanguageAvailable("en");
          print('en available: $result');
          await _flutterTts!.setLanguage("en");
          languageSet = true;
          print('Language set to en');
        } catch (e) {
          print('Fallback language setting failed: $e');
        }
      }

      // Configure other TTS settings
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(0.8);
      await _flutterTts!.setPitch(1.0);

      _isInitialized =
          true; // Mark as initialized even if language setting failed
      print('TTS Initialized: $_isInitialized');
    } catch (e) {
      print('TTS Initialization Error: $e');
      _isInitialized = false;
    }
  }

  /// Speak the given text with IPA pronunciation
  Future<void> speakIPA(String ipaSymbol, String example) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // First speak the IPA symbol sound (we'll use the example word for now)
      await _flutterTts!.speak(example);

      // Add a short pause
      await Future.delayed(const Duration(milliseconds: 800));

      // Then speak the example word again for clarity
      await _flutterTts!.speak(example);
    } catch (e) {
      print('TTS Error: $e');
    }
  }

  /// Speak any text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    // If still not initialized after first attempt, try once more
    if (!_isInitialized) {
      _isInitialized = false; // Reset flag
      await initialize();
    }

    if (!_isInitialized) {
      print('TTS not available, skipping speech for: $text');
      return;
    }

    try {
      print('Attempting to speak: $text');
      await _flutterTts!.speak(text);
      print('Speech command sent successfully');
    } catch (e) {
      print('TTS Speak Error: $e');
      // Show a fallback message to user
      print('TTS not working on this device/emulator. Text: $text');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
  }

  /// Dispose of the TTS service
  void dispose() {
    _flutterTts = null;
    _isInitialized = false;
  }
}
