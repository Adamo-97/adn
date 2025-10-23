import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class NewPasswordENG extends StatelessWidget {
  const NewPasswordENG({super.key});

  @override
  Widget build(BuildContext context) {
    onChangePassButtonPress() {
      Navigator.pushNamed(context, 'login_eng');
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
                    left: padding10,
                    right: padding4,
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
                          'New Password',
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
                                'Password',
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
                            suffixIcon: Container(
                              width: 39.1,
                              padding: const EdgeInsets.only(
                                top: padding10,
                                right: padding15,
                              ),
                              alignment: AlignmentDirectional.topEnd,
                              child: Container(
                                width: width241,
                                height: height20,
                                constraints: const BoxConstraints(
                                  maxHeight: 20,
                                ),
                                child: Image(
                                  image: AssetImage('assets/eye-icon@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints(
                              maxWidth: 39.1,
                            ),
                            hintText: "●●●●●●●●",
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              left: padding15,
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
                  padding: const EdgeInsets.only(bottom: 30),
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
                                'Confirm Password',
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
                            suffixIcon: Container(
                              width: 39.1,
                              padding: const EdgeInsets.only(
                                top: padding10,
                                right: padding15,
                              ),
                              alignment: AlignmentDirectional.topEnd,
                              child: Container(
                                width: width241,
                                height: height20,
                                constraints: const BoxConstraints(
                                  maxHeight: 20,
                                ),
                                child: Image(
                                  image: AssetImage('assets/eye-icon@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            suffixIconConstraints: BoxConstraints(
                              maxWidth: 39.1,
                            ),
                            hintText: "●●●●●●●●",
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              left: padding15,
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
                      "Change Password",
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
                      padding: EdgeInsets.all(padding10),
                      fixedSize: Size(widthDoubleInfinity, height40),
                      minimumSize: Size(325, 40),
                      elevation: 0,
                    ),
                    onPressed: onChangePassButtonPress,
                  ),
                ),
                Container(
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
                ),
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
