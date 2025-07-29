// import 'package:flutter/material.dart';

// import '../../../../config/theme.dart';
// import '../../../../widgets/custom_icon_button.dart';
// import '../../../../widgets/custom_textfield.dart';
// import '../../../../widgets/heights_and_widths.dart';

// class MedicineTypeSelector extends StatefulWidget {
//   const MedicineTypeSelector({
//     super.key,
//   });

//   @override
//   State<MedicineTypeSelector> createState() => _MedicineTypeSelectorState();
// }

// class _MedicineTypeSelectorState extends State<MedicineTypeSelector> {
//   //medicineType controller
//   final TextEditingController _medicineType = TextEditingController();

//   bool isOtherSelected = false;

//   bool isOtherChecked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Medicine Type *', style: titleStyle),
//         const Height10(),
//         Opacity(
//           opacity: isOtherChecked ? 0.3 : 1,
//           child: Row(
//             children: [
//               CustomIconButton(
//                 svgUrl: 'assets/icons/pill.svg',
//                 title: 'Pill',
//                 index: 0,
//                 onPressed: () {}, selectedIndex: 0,
//               ),
//               const Width10(),
//               CustomIconButton(
//                 svgUrl: 'assets/icons/capsule_icon.svg',
//                 title: 'Capsule',
//                 index: 1,
//                 onPressed: () {}, selectedIndex: 0,
//               ),
//               const Width10(),
//               CustomIconButton(
//                 svgUrl: 'assets/icons/medicine.svg',
//                 title: 'Syrup',
//                 index: 2,
//                 onPressed: () {}, selectedIndex: 0,
//               ),
//             ],
//           ),
//         ),
//         const Height20(),
//         //checkbox
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Checkbox(
//               value: isOtherSelected,
//               onChanged: (value) {},
//               // activeColor: kSSIorange,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5),
//                 ),
//               ),
//             ),
//             const Width10(),
//             Text(
//               'Other',
//               style: subTitleStyle,
//             ),
//           ],
//         ),
//         const CustomTextField(
//           hintText: 'Enter Medicine Type',
//         ),
//       ],
//     );
//   }
// }
