import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:Athanapp/widgets/google_apple_continue.dart';

class EnterPinENG extends StatelessWidget {
  const EnterPinENG({super.key});

  @override
  Widget build(BuildContext context) {
    onAcceptButtonPress() {
      Navigator.pushNamed(context, 'new_password_eng');
    }

    onDontHaveAnPress() {
      Navigator.pushNamed(context, 'create_account_eng');
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            height: height932,
            padding: const EdgeInsets.only(
              top: padding100,
              left: 33,
              right: 33,
              bottom: padding100,
            ),
            decoration: const BoxDecoration(gradient: gradient1),
            child: Flex(
              spacing: gap20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              direction: Axis.vertical,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: padding20,
                    bottom: padding20,
                  ),
                  width: double.infinity,
                  child: const Flex(
                    spacing: gap4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Security Pin',
                          style: TextStyle(
                            fontSize: fs30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: padding20,
                    right: padding20,
                  ),
                  width: double.infinity,
                  child: const Flex(
                    spacing: gap10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Enter the recovery code sent to your email.',
                          style: TextStyle(
                            fontSize: fs15,
                            fontFamily: 'Poppins',
                            height: 1.33,
                            color: white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Flex(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      TextField(
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          constraints: BoxConstraints.expand(
                            width: 44.8,
                            height: 44.8,
                          ),
                        ),
                      ),
                      TextField(
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          constraints: BoxConstraints.expand(
                            width: 44.8,
                            height: 44.8,
                          ),
                        ),
                      ),
                      TextField(
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          constraints: BoxConstraints.expand(
                            width: 44.8,
                            height: 44.8,
                          ),
                        ),
                      ),
                      TextField(
                        expands: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: greenLight),
                            borderRadius: BorderRadius.all(
                              Radius.circular(500),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          constraints: BoxConstraints.expand(
                            width: 44.8,
                            height: 44.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: padding20,
                    bottom: padding20,
                  ),
                  width: double.infinity,
                  child: Flex(
                    spacing: gap20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              fontSize: fs18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.11,
                              letterSpacing: -0.23,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            padding: EdgeInsets.all(padding10),
                            fixedSize: Size(widthDoubleInfinity, height40),
                            minimumSize: Size(144.5, 40),
                            elevation: 0,
                          ),
                          onPressed: onAcceptButtonPress,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          child: Text(
                            "Send again",
                            style: TextStyle(
                              fontSize: fs18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.11,
                              letterSpacing: -0.23,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: greyHighlight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              top: padding10,
                              left: padding10,
                              right: padding4,
                              bottom: padding10,
                            ),
                            fixedSize: Size(widthDoubleInfinity, height40),
                            minimumSize: Size(144.5, 40),
                            elevation: 0,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const GoogleAppleContinue(),
                Container(
                  padding: const EdgeInsets.only(
                    top: padding20,
                    bottom: padding5,
                  ),
                  width: double.infinity,
                  child: Flex(
                    spacing: gap4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: onDontHaveAnPress,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: fs15,
                                  fontFamily: 'Poppins',
                                  height: 1.33,
                                ),
                                children: [
                                  TextSpan(
                                    style: TextStyle(color: white),
                                    text: 'Don’t have an account? ',
                                  ),
                                  TextSpan(
                                    style: TextStyle(color: gold),
                                    text: 'Sign Up',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
