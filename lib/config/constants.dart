import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kSSIorange = Color(0xFFED8261);
const Color backgroundColorLight = Color(0xFFF5F0E8);
const Color backgroundColorDark = Color(0xFF1C1C24);

const pinkClr = Color(0xFFff4667);
const Color darkmodeFore = Color(0xFF1C1C24);
const Color darkmodeLight = Color(0xFF0A0A0A);
const Color properBlack = Color(0xFF1D1B17);
const Color darkModeBg = Color(0xFF1C1C24);
const Color white = Colors.white;
const bluishClr = Color(0xFF4e5ae8);
//theme constants
const yellowClr = Color(0xFFFFB746);

//Quiz constants
const deepGold = Color(0xFF966E2F);
const gold = Color(0xFFCFA050);

const cherry = Color(0xFFDB6B61);
const deepCherry = Color(0xFF7E3E39);

const teal = Color(0xFF6fb1ab);
const deepTeal = Color(0xFF365654);

const blue = Color(0xFF606fde);
const deepBlue = Color(0xFF363f7e);

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    // color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
  );
}

const double mainBorderRadius = 34;
const double innerBorderRadius = 25;

// Audio player constants
const Color articlePlayerBackgroundColor = Color(0xFFF5F5F5);
const Color iconColor = Color(0xFFFF9600);
const Color progressBarColor = Color(0xFFE0E0E0);

class Height10 extends StatelessWidget {
  const Height10({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}

class Height20 extends StatelessWidget {
  const Height20({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class Width10 extends StatelessWidget {
  const Width10({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
    );
  }
}

class Width20 extends StatelessWidget {
  const Width20({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
    );
  }
}

TextStyle get homePageListTitleStyleLight {
  return subHeadingStyle.copyWith(
      color: Colors.black, fontWeight: FontWeight.w800);
}

TextStyle get subHeadingStyle => GoogleFonts.lato(
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        // color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
      ),
    );

TextStyle get headingStyle {
  return GoogleFonts.lato(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    // color: Get.isDarkMode ? Colors.red : Colors.black,
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    // color: Get.isDarkMode ? Colors.red : Colors.black,
  );
}

TextStyle get inputTitle {
  return GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    // color: Get.isDarkMode ? Colors.red : Colors.black,
  );
}

TextStyle get formFieldTitle {
  return GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    // color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
  );
}

TextStyle get pillTitleTextStyle {
  return const TextStyle(
    color: Colors.black,
    fontSize: 19,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get homePageListTitleStyleDark {
  return subHeadingStyle.copyWith(
    color: Colors.white,
  );
}

TextStyle get homePageListSubTitleStyleDark {
  return titleStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white.withValues(alpha: 0.5),
  );
}

//const Color(0x6C236A75),
TextStyle get homePageListSubTitleStyleLight {
  return titleStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0x6C236A75),
  );
}
