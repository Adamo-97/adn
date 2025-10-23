import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class GoogleAppleContinue extends StatelessWidget {
  const GoogleAppleContinue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: padding20),
      width: double.infinity,
      child: const Flex(
        spacing: gap10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Flex(
              spacing: gap10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'or continue with',
                    style: TextStyle(
                      fontSize: fs12,
                      fontFamily: 'Poppins',
                      height: 1.67,
                      color: white50,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height40,
            width: double.infinity,
            child: Flex(
              spacing: gap20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: width40,
                  height: double.infinity,
                  child: Image(
                    image: AssetImage('assets/apple-logo@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width40,
                  height: double.infinity,
                  child: Image(
                    image: AssetImage('assets/Google@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
