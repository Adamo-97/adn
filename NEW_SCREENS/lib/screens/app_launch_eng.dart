import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class AppLaunchENG extends StatelessWidget {
  const AppLaunchENG({super.key});

  @override
  Widget build(BuildContext context) {
    onAppLaunchENGContainerPress() {
      Navigator.pushNamed(context, 'on_boarding_1_eng');
    }

    onLoginButtonPress() {
      Navigator.pushNamed(context, 'login_eng');
    }

    onSignupButtonPress() {
      Navigator.pushNamed(context, 'create_account_eng');
    }

    onForgotPasswordTextPress() {
      Navigator.pushNamed(context, 'forgot_password_eng');
    }

    onArabicLangButtonContainerPress() {
      // Please sync "app_launch_AR" to the project
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onAppLaunchENGContainerPress,
              child: Container(
                height: height932,
                padding: const EdgeInsets.only(
                  left: padding25,
                  right: padding25,
                  bottom: 150,
                ),
                decoration: const BoxDecoration(gradient: gradient1),
                child: Flex(
                  spacing: 22,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.vertical,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: padding40,
                        bottom: padding40,
                      ),
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: const SizedBox(
                        width: 159,
                        height: 200,
                        child: Image(
                          image: AssetImage('assets/Vector@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
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
                                fixedSize: Size(widthDoubleInfinity, 42),
                                minimumSize: Size(157.5, 42),
                                elevation: 0,
                              ),
                              onPressed: onSignupButtonPress,
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
                      child: Flex(
                        spacing: gap10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 1,
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
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: padding25,
                        right: padding25,
                      ),
                      width: double.infinity,
                      child: Flex(
                        spacing: gap10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: height45,
                            padding: const EdgeInsets.only(
                              top: padding6,
                              left: padding5,
                              right: padding5,
                              bottom: padding6,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br12),
                              ),
                              color: darkGreen,
                            ),
                            child: Flex(
                              spacing: gap5,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: padding5,
                                    right: padding5,
                                  ),
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(br12),
                                    ),
                                    color: greenLight,
                                  ),
                                  child: const Flex(
                                    spacing: gap10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/eng-icon@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'English',
                                        style: TextStyle(
                                          fontSize: fs15,
                                          fontFamily: 'Poppins',
                                          height: 1.33,
                                          color: gold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: onArabicLangButtonContainerPress,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: padding5,
                                        right: padding5,
                                      ),
                                      height: double.infinity,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(br12),
                                        ),
                                        color: darkGreen,
                                      ),
                                      child: const Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'العربية',
                                            style: TextStyle(
                                              fontSize: fs15,
                                              fontFamily: 'Noto Kufi Arabic',
                                              height: 1.33,
                                              letterSpacing: -1.04,
                                              color: white50,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/ara-logo@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
