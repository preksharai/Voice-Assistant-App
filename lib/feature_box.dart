import 'package:flutter/cupertino.dart';
import 'package:voice_assistant_app/palette.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String description;
  FeatureBox({required this.color,required this.headerText,required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
              headerText, style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
              fontFamily: 'Cera pro',
          ),
          ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                description, style: TextStyle(
                color: Pallete.blackColor,
                fontFamily: 'Cera pro',
              ),
              ),
            ),
        ],
        ),
      ),
    );
  }
}
