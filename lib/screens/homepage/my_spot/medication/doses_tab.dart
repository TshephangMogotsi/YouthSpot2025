import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/round_icon_button.dart';
// import 'package:intl/intl.dart';


class DosesTab extends StatelessWidget {
  const DosesTab({
    super.key,
  });

  // final String _startTime =
  //     DateFormat("hh:mm a").format(DateTime.now()).toString();

  // _showTimePicker(BuildContext context) {
  //   return showTimePicker(
  //     initialEntryMode: TimePickerEntryMode.input,
  //     initialTime: TimeOfDay(
  //       hour: int.parse(_startTime.split(":")[0]),
  //       minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
  //     ),
  //     context: context,
  //   );
  // }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Doses per day *', style: titleStyle),
        const SizedBox(height: 10,),
        PrimaryContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton(
                icon: FontAwesomeIcons.minus,
                onClick: () {},
              ),
              const SizedBox(width: 20,),
              Column(
                children: [
                  Text(
                    'Doses',
                    style: subHeadingStyle,
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    'doses',
                    style: headingStyle,
                  )
                ],
              ),
              const SizedBox(width: 20,),
              RoundIconButton(
                icon: FontAwesomeIcons.plus,
                onClick: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}
