import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:Athanapp/widgets/google_apple_continue.dart';

class ForgotPasswordENG extends StatelessWidget {
  const ForgotPasswordENG({super.key});

  @override
  Widget build(BuildContext context) {
    onLogInDarkPress() {
      Navigator.pushNamed(context, 'enter_pin_eng');
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
              left: padding25,
              right: padding25,
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
                  alignment: AlignmentDirectional.center,
                  child: const SizedBox(
                    width: width325,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Forgot Password',
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
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Flex(
                    spacing: gap5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: padding10,
                          right: padding10,
                        ),
                        width: double.infinity,
                        child: const Flex(
                          spacing: gap10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Enter email address',
                                style: TextStyle(
                                  fontSize: fs15,
                                  fontFamily: 'Poppins',
                                  height: 1.33,
                                  color: white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          style: TextStyle(
                            fontSize: fs15,
                            fontFamily: 'Poppins',
                            color: greyHighlight,
                          ),
                          expands: true,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            fillColor: greenLight,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: fs15,
                              fontFamily: 'Poppins',
                              color: greyHighlight,
                            ),
                            hintText: "example@example.com",
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              left: padding10,
                              bottom: 0,
                            ),
                            constraints: BoxConstraints.expand(
                              width: width325,
                              height: height40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      "Next step",
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
                        borderRadius: BorderRadius.all(Radius.circular(br30)),
                      ),
                      padding: EdgeInsets.only(
                        top: padding11,
                        left: 7,
                        right: 7,
                        bottom: padding11,
                      ),
                      fixedSize: Size(widthDoubleInfinity, 42),
                      minimumSize: Size(325, 42),
                      elevation: 0,
                    ),
                    onPressed: onLogInDarkPress,
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
