import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class InputField extends StatefulWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  InputField(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
      child: TextField(
        controller: widget.controller,
        cursorColor: Constants.primaryColor,
        style: FontStyle(18, Colors.black87, FontWeight.w400),
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              size: 35,
            ),
            hintText: widget.hint,
            hintStyle: FontStyle(18, Colors.black26, FontWeight.w400),
            border: InputBorder.none),
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
    );
  }
}

class InputPasswordField extends StatefulWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  InputPasswordField(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  _InputPasswordFieldState createState() => _InputPasswordFieldState();
}

class _InputPasswordFieldState extends State<InputPasswordField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 1, 10, 1),
      child: TextField(
        controller: widget.controller,
        cursorColor: Constants.primaryColor,
        style: FontStyle(18, Colors.black87, FontWeight.w400),
        obscureText: true,
        obscuringCharacter: '●',
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              size: 35,
            ),
            hintText: widget.hint,
            hintStyle: FontStyle(18, Colors.black26, FontWeight.w400),
            border: InputBorder.none),
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
    );
  }
}

TextStyle FontStyle(double size, Color color, FontWeight weight) {
  return GoogleFonts.roboto(fontSize: size, color: color, fontWeight: weight);
}
