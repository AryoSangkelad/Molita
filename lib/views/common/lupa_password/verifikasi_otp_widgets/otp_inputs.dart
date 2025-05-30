import 'package:flutter/material.dart';

Widget buildOtpInputs(BuildContext context, List<TextEditingController> otpControllers) {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  const _otpBoxSize = 56.0;
  const _otpBoxColor = Color.fromARGB(255, 208, 232, 255);
  const _otpTextColor = Color.fromARGB(255, 2, 125, 162);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(4, (index) {
      return SizedBox(
        width: _otpBoxSize,
        height: _otpBoxSize,
        child: TextField(
          controller: otpControllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: _otpBoxColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: _otpTextColor),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      );
    }),
  );
}
