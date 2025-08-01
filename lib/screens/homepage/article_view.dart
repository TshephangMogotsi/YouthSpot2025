import 'package:youthspot/config/font_constants.dart';
import 'package:youthspot/global_widgets/primary_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';

import '../../db/models/articles_model.dart';
import '../../global_widgets/primary_padding.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key, required this.article});

  final Article article;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final String defaultLanguage = 'en-US';

  FlutterTts tts = FlutterTts();

  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  String? language;
  String? languageCode;
  List<String> languageCodes = <String>[];
  String? voice;

  ButtonState buttonState = ButtonState.stopped;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
      setupTtsListeners();
    });
  }

  void setupTtsListeners() {
    tts.setCompletionHandler(() {
      setState(() {
        buttonState = ButtonState.stopped;
      });
    });

    tts.setErrorHandler((msg) {
      setState(() {
        buttonState = ButtonState.stopped;
      });
    });
  }

  Future<void> initLanguages() async {
    // Get available language codes
    languageCodes = List<String>.from(await tts.getLanguages);

    // Pick default language if available
    if (languageCodes.contains(defaultLanguage)) {
      languageCode = defaultLanguage;
    } else if (languageCodes.isNotEmpty) {
      languageCode = languageCodes.first;
    }

    language = languageCode; // No display name available in flutter_tts
    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final voices = await tts.getVoices;
    if (voices != null && voices.isNotEmpty) {
      final voiceForLang = voices.firstWhere(
        (v) => v['locale'] == lang,
        orElse: () => null,
      );
      return voiceForLang?['name'];
    }
    return null;
  }

  bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  void speak() {
    buttonState = ButtonState.playing;
    tts.setVolume(volume);
    tts.setSpeechRate(rate);
    if (languageCode != null) {
      tts.setLanguage(languageCode!);
    }
    tts.setPitch(pitch);
    tts.speak(widget.article.description);
  }

  void stop() {
    tts.stop();
  }

  // Stop speaking when the screen is closed
  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return PrimaryScaffold(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.article.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: Colors.grey[600],
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                const Height20(),
                PrimaryPadding(
                  child: Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Height20(),
                const PrimaryDivider(),
                const Height20(),
                PrimaryPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                            decoration: BoxDecoration(
                              color: kSSIorange,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '2 days ago',
                              style: AppTextStyles.secondarySemiBold.copyWith(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Width10(),
                          Text(
                            'By ${widget.article.author}',
                            style: AppTextStyles.primaryBold,
                          ),
                        ],
                      ),
                      // Icon(
                      //   Icons.bookmark_border_rounded,
                      //   color: theme == ThemeMode.dark
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                    ],
                  ),
                ),
                const Height20(),
                const PrimaryPadding(
                  child: Text('Listen to this article'),
                ),
                const Height20(),
                PrimaryPadding(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: articlePlayerBackgroundColor,
                      border: Border.all(
                        color: Colors.grey[300]!.withOpacity(0.4),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (buttonState == ButtonState.stopped) {
                                buttonState = ButtonState.playing;
                                speak();
                              } else if (buttonState == ButtonState.playing) {
                                buttonState = ButtonState.stopped;
                                stop();
                              }
                            });
                          },
                          child: Icon(
                            buttonState == ButtonState.playing
                                ? Icons.stop_circle_rounded
                                : Icons.play_circle_fill_rounded,
                            size: 32,
                            color: iconColor,
                          ),
                        ),
                        const Width10(),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: progressBarColor,
                          ),
                        ),
                        const Width10(),
                      ],
                    ),
                  ),
                ),
                const Height20(),
                PrimaryPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        widget.article.description.replaceAll(r'\n', '\n'),
                        autofocus: true,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                const Height20(),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum ButtonState {
  playing,
  stopped,
}