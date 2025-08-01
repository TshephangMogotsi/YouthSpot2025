import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/font_constants.dart';

class MySpotCard extends StatelessWidget {
  const MySpotCard({
    super.key,
    required this.title,
    required this.imageURL,
    this.onTap,
    this.color = Colors.grey,
    this.svgColor,
    required this.iconBgColor,
    required this.iconURL,
    required this.iconPadding,
    this.notifications,
    required this.notificationsBgColor,
  });

  final String title;
  final String imageURL;
  final String iconURL;
  final Color color;
  final Color iconBgColor;
  final double iconPadding;
  final Color? svgColor;
  final void Function()? onTap;
  final int? notifications;
  final Color notificationsBgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: color,
            image: DecorationImage(
              image: AssetImage(imageURL),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notifications != null && notifications != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: notificationsBgColor,
                      child: Text(
                        notifications.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          padding: EdgeInsets.all(iconPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: iconBgColor,
                          ),
                          child: iconURL.endsWith('.svg')
                              ? SvgPicture.asset(
                                  iconURL,
                                  width: 10,
                                  height: 10,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Image.asset(iconURL, width: 10, height: 10),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: AppTextStyles.primaryBigBold.copyWith(
                            color: Colors.white,
                          ),
                          // style: const TextStyle(
                          //   color: Colors.white,
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.bold,
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
