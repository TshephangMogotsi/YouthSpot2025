import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/screens/sos_screen.dart';

import 'homepage/journal/journal.dart';
import 'homepage/lifestyleQuiz/quiz_intro.dart';
import 'homepage_list_tile.dart';

class Extras extends StatefulWidget {
  const Extras({
    super.key,
  });

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomePageListTile(
          title: 'SOS',
          subtitle: 'In urgent distress? Send us an SOS message',
          svgURL: 'assets/Backgrounds/SOS.svg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SOSScreen(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        HomePageListTile(
          title: 'Journal',
          subtitle: 'Your daily dose of motivation & affirmations',
          svgURL: 'assets/icons/journal.svg',
          onTap: () async {
            // final authenticate = await LocalAuth.authenticate();
            // setState(() {
            //   authenticated = authenticate;
            // });

            // if (!context.mounted) return;

            // if (authenticated) {
            //   await Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const Journal(),
            //     ),
            //   );
            // }
            // setState(() {
            //   authenticated = false;
            // });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Journal(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        HomePageListTile(
          title: 'Motivational Quotes',
          subtitle: 'Your daily dose of motivation & affirmations',
          svgURL: 'assets/icons/motivational_quotes.svg',
          onTap: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const MotivationalQuotes(),
            //   ),
            // );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        HomePageListTile(
          title: 'LifeStyle Quiz',
          subtitle: 'Take a Quiz to know yourself better',
          svgURL: 'assets/icons/quiz.svg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LifestyleQuiz(),
              ),
            );
          },
        ),
      ],
    );
  }
}
