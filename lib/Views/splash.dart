import 'package:elm_fyp/Views/constants.dart';
import 'package:elm_fyp/Views/login_register/login.dart';
import 'package:elm_fyp/Views/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    _movetoScreen();
    super.initState();
  }

  _movetoScreen() async {
    await Future.delayed(const Duration(seconds: 2), () {
      _animationController!.forward();
    });
    await Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Constants.screenHeight(context),
        width: Constants.screenWidth(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_image.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: RotationTransition(
                    turns: _animation!,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 20)
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/icon.png"))),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text("Employee Location Management",
                    style: FontStyle(20, Colors.black, FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
