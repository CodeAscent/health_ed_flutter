import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts _flutterTts = FlutterTts();

  // Set default configurations
  TextToSpeech() {
    _flutterTts.setVolume(0.8); // Slightly lower volume for more clarity
    _flutterTts.setSpeechRate(0.4); // Adjust to slower speed if it sounds rushed
    _flutterTts.setPitch(1.1); // Slightly higher pitch can help with clarity

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
