import 'package:flutter_tts/flutter_tts.dart';

/// Service class for handling Text-to-Speech functionality
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isInitializing = false;
  
  // Cache for already spoken words to reduce TTS initialization overhead
  final Map<String, bool> _spokenCache = {};

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;

    try {
      _flutterTts = FlutterTts();

      // Properly dispose resources on completion
      _flutterTts!.setCompletionHandler(() {
        // Speech completed
      });

      // Handle errors correctly
      _flutterTts!.setErrorHandler((msg) {
        print("TTS Error: $msg");
      });

      // Set up a release handler to properly dispose resources
      _flutterTts!.setCancelHandler(() {
        // Properly clean up
      });

      // Check if TTS engines are available
      var engines = await _flutterTts!.getEngines;

      // If no engines available, still try to initialize with defaults
      if (engines.isEmpty) {
        try {
          // Try basic configuration without language check
          await _flutterTts!.setSpeechRate(0.5);
          await _flutterTts!.setVolume(0.8);
          await _flutterTts!.setPitch(1.0);
          
          // Important: set a max queue length to prevent memory issues
          await _flutterTts!.setQueueMode(1); // Drop all pending speech and start with the new one
          
          _isInitialized = true;
          _isInitializing = false;
          return;
        } catch (e) { 
          _isInitialized = false;
          _isInitializing = false;
          return;
        }
      }

      // Try to set language with fallback
      bool languageSet = false;
      try {
        var result = await _flutterTts!.isLanguageAvailable("en-US");
        if (result == true) {
          await _flutterTts!.setLanguage("en-US");
          languageSet = true;
        }
      } catch (e) {
        // Language setting failed
      }

      // If en-US failed, try just "en"
      if (!languageSet) {
        try {
          await _flutterTts!.isLanguageAvailable("en");
          await _flutterTts!.setLanguage("en");
          languageSet = true;
        } catch (e) {
          // Fallback language setting failed
        }
      }

      // Configure other TTS settings
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(0.8);
      await _flutterTts!.setPitch(1.0);
      
      // Important: set a max queue length to prevent memory issues
      await _flutterTts!.setQueueMode(1); // Drop all pending speech and start with the new one

      _isInitialized = true;
    } catch (e) {
      print("TTS initialization error: $e");
      _isInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Speak the given text with IPA pronunciation
  Future<void> speakIPA(String ipaSymbol, String example) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Skip if we're still initializing to prevent blocking
    if (_isInitializing) return;

    // If not initialized even after attempt, return early
    if (!_isInitialized) return;

    try {
      // First stop any ongoing speech to prevent queuing up
      await stop();
      
      // First speak the IPA symbol sound (we'll use the example word for now)
      await _flutterTts!.speak(example);
      
      // Cache the spoken word
      _spokenCache[example] = true;
    } catch (e) {
      print("TTS Error speaking IPA: $e");
    }
  }

  /// Speak any text
  Future<void> speak(String text) async {
    // If we've already spoken this exact text recently, just return
    if (_spokenCache.containsKey(text) && _isInitialized) {
      // Still try to speak it but skip the initialization
      try {
        await stop();
        await _flutterTts!.speak(text);
        return;
      } catch (e) {
        // Fall through to regular initialization
      }
    }
    
    // Normal initialization path
    if (!_isInitialized) {
      await initialize();
    }

    // Skip if we're still initializing to prevent blocking
    if (_isInitializing) return;

    // If not initialized even after attempt, try once more
    if (!_isInitialized) {
      _isInitialized = false; // Reset flag
      await initialize();
    }

    if (!_isInitialized) {
      return;
    }

    try {
      // First stop any ongoing speech to prevent queuing up
      await stop();
      
      await _flutterTts!.speak(text);
      
      // Cache the spoken word
      _spokenCache[text] = true;
      
      // Limit cache size to prevent memory leaks
      if (_spokenCache.length > 100) {
        final keysToRemove = _spokenCache.keys.take(_spokenCache.length - 50).toList();
        for (final key in keysToRemove) {
          _spokenCache.remove(key);
        }
      }
    } catch (e) {
      print("TTS Error speaking: $e");
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (_flutterTts != null && _isInitialized) {
      try {
        await _flutterTts!.stop();
      } catch (e) {
        print("TTS Error stopping: $e");
      }
    }
  }

  /// Dispose of the TTS service
  void dispose() {
    if (_flutterTts != null) {
      try {
        _flutterTts!.stop();
      } catch (e) {
        // Ignore errors during cleanup
      }
    }
    
    _spokenCache.clear();
    _flutterTts = null;
    _isInitialized = false;
    _isInitializing = false;
  }
}
