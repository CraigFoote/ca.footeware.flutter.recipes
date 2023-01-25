import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ],
          ),
        ),
      ),
    );
  }
}
