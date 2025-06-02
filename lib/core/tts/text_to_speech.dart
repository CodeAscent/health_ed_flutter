import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts _flutterTts = FlutterTts();

  // Set default configurations
  TextToSpeech() {
    _flutterTts.setVolume(1.0); // Full volume for better audibility
    _flutterTts.setSpeechRate(
        0.3); // Slower speech rate to make it easier for children
    _flutterTts.setPitch(1.0); // Normal pitch for a more natural voice
    _flutterTts.setVoice({
      'name':
          'en-us-x-sfg#female_2-local', // Example voice (can vary by platform)
      'locale': 'en-US'
    });
  }

  Future<void> speak(String text, {String languageCode = 'hi-IN'}) async {
    // Set the language before speaking
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.speak(text);
    List<dynamic> voices = await _flutterTts.getVoices;
    print(voices);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Clean up resources (optional)
  void dispose() {
    _flutterTts.stop();
  }
}
