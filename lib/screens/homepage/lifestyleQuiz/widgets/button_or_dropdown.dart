import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../global_widgets/primary_container.dart';

class ButtonOrRadioButton extends StatefulWidget {
  const ButtonOrRadioButton({
    super.key,
    required this.data,
    this.backgroundColor = kSSIorange,
    this.hasBorder = false,
    this.borderColor = Colors.white,
    this.onTap,
  });

  final List<String> data;
  final Color backgroundColor;
  final bool hasBorder;
  final Color borderColor;
  final void Function()? onTap;

  @override
  State<ButtonOrRadioButton> createState() => _ButtonOrRadioButtonState();
}

class _ButtonOrRadioButtonState extends State<ButtonOrRadioButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length == 1) {
      return _buildButton(widget.data[0]);
    } else {
      return _buildRadioButtonList();
    }
  }

  Widget _buildButton(String title) {
    return InkWell(
      onTap: widget.onTap,
      child: PrimaryContainer(
    
        child: Text(title),
      ),
    );
  }

  Widget _buildRadioButtonList() {
    return Column(
      children: widget.data
          .map(
            (e) => InkWell(
              onTap: widget.onTap,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: PrimaryContainer(
                  child: Text(e),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
