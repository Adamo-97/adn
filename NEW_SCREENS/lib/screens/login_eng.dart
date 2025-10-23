import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:Athanapp/widgets/pass_container.dart';

class LoginENG extends StatelessWidget {
  const LoginENG({super.key});

  @override
  Widget build(BuildContext context) {
    onLoginButtonPress() {
      // Please sync "prayers_screen_EN" to the project
    }

    onSignupButtonPress() {
      Navigator.pushNamed(context, 'create_account_eng');
    }

    onForgotPasswordTextPress() {
      Navigator.pushNamed(context, 'forgot_password_eng');
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            height: height932,
            padding: const EdgeInsets.only(
              left: padding25,
              right: padding25,
              bottom: 150,
            ),
            decoration: const BoxDecoration(gradient: gradient1),
            child: Flex(
              spacing: gap20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: padding20,
                    bottom: padding20,
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
                          'Salam Alykum',
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
                                'Email',
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
                                Radius.circular(br20),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(br20),
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
                const PassContainer(titlePlaceholderText: "Password"),
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              top: padding11,
                              left: 7,
                              right: 7,
                              bottom: padding11,
                            ),
                            fixedSize: Size(widthDoubleInfinity, 44),
                            minimumSize: Size(157.5, 44),
                            elevation: 0,
                          ),
                          onPressed: onLoginButtonPress,
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: fs18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.11,
                              letterSpacing: -0.23,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br30),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              top: padding11,
                              left: 7,
                              right: 7,
                              bottom: padding11,
                            ),
                            fixedSize: Size(widthDoubleInfinity, 42),
                            minimumSize: Size(157.5, 42),
                            elevation: 0,
                          ),
                          onPressed: onSignupButtonPress,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: fs18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.11,
                              letterSpacing: -0.23,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: padding5,
                    bottom: padding5,
                  ),
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onForgotPasswordTextPress,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: fs15,
                          fontFamily: 'Poppins',
                          height: 1.33,
                          color: white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
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
                const SizedBox(
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
                          image: AssetImage('assets/Google1@2x.png'),
                          fit: BoxFit.cover,
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
