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
        autocorrect: false,
        controller: widget.controller,
        cursorColor: Constants.primaryColor,
        style: FontStyle(18, Colors.black87, FontWeight.w400),
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              size: 25,
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
              size: 25,
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

class InputAddressField extends StatefulWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  InputAddressField(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  _InputAddressFieldState createState() => _InputAddressFieldState();
}

class _InputAddressFieldState extends State<InputAddressField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.fromLTRB(15, 6, 10, 6),
      child: Container(
        width: Constants.screenWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              margin: const EdgeInsets.only(right: 3),
              child: Icon(widget.icon, size: 25, color: Colors.black45),
            ),
            Expanded(
              child: TextField(
                minLines: 2,
                maxLines: 2,
                controller: widget.controller,
                cursorColor: Constants.primaryColor,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Colors.black26),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
    );
  }
}

class NavBox extends StatefulWidget {
  String buttonText;
  VoidCallback onPress;
  NavBox({Key? key, required this.buttonText, required this.onPress})
      : super(key: key);

  @override
  _NavBoxState createState() => _NavBoxState();
}

class _NavBoxState extends State<NavBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
        width: Constants.screenWidth(context),
        decoration: BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            )),
        child: Text(
          widget.buttonText,
          textAlign: TextAlign.center,
          style: FontStyle(24, Colors.white, FontWeight.w400),
        ),
      ),
    );
  }
}
