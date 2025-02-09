import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMessageWidget extends StatelessWidget {
  const VoiceMessageWidget({super.key, this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return VoiceMessageView(
      size: 20,
      notActiveSliderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      activeSliderColor: Colors.white,
      circlesColor: Colors.transparent,
      controller: VoiceController(
        audioSrc: url!,
        maxDuration: const Duration(seconds: 10),
        isFile: false,
        onComplete: () {
        },
        onPause: () {
        },
        onPlaying: () {
        },
        onError: (err) {
        },
      ),
      innerPadding: 1,
      cornerRadius: 20,
    );
  }
}
