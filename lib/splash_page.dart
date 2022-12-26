import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_recipes/search_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(milliseconds: 4000),
      defaultNextScreen: SearchPage(title: widget.title),
      backgroundColor: Colors.white,
      splashScreenBody: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Annie Foote's Recipes",
                textScaleFactor: 2.5,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepPurple, fontFamily: 'ConeriaScript'),
              ),
              const Text(
                "Dedicated to all the wonderful meals lovingly prepared by this wonderful woman.",
                textScaleFactor: 1.8,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
              Image(
                height: MediaQuery.of(context).size.height * 0.5,
                alignment: Alignment.topCenter,
                image: Image.asset('assets/images/Annie.jpg').image,
              ),
              LoadingAnimationWidget.threeArchedCircle(
                size: 50,
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
