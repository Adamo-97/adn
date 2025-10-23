import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:Athanapp/widgets/pass_container.dart';

class CreateAccountENG extends StatefulWidget {
  const CreateAccountENG({super.key});

  @override
  _CreateAccountENGState createState() => _CreateAccountENGState();
}

class _CreateAccountENGState extends State<CreateAccountENG> {
  DateTime? _selectedDate = null;

  Future _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      keyboardType: TextInputType.text,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    onSignupButtonPress() {
      Navigator.pushNamed(context, 'login_eng');
    }

    onAlreadyHaveAnPress() {
      Navigator.pushNamed(context, 'login_eng');
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
              bottom: padding100,
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
                    spacing: gap4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Create Account',
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
                                'Full name',
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
                            hintText: "john doe",
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
                                'Date of birth',
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
                      GestureDetector(
                        onTap: () => _showDatePicker(context),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: padding10,
                            left: padding15,
                            right: padding15,
                            bottom: padding10,
                          ),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(br30),
                            ),
                            color: greenLight,
                          ),
                          child: Flex(
                            spacing: gap10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                      : r'DD / MM /YYY',
                                  style: TextStyle(
                                    fontSize: fs15,
                                    fontFamily: 'Poppins',
                                    height: 1.33,
                                    color: greyHighlight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const PassContainer(
                  titlePlaceholderText: "Password",
                  passwordSectionMainAxisAlignment: MainAxisAlignment.start,
                  passwordSectionBorderRadius: 30,
                  passwordSectionPaddingLeft: 15,
                  passwordSectionSpacing: 20,
                  passwordSectionPaddingRight: 15,
                ),
                const PassContainer(
                  titlePlaceholderText: "Confirm Password",
                  passwordSectionMainAxisAlignment: MainAxisAlignment.start,
                  passwordSectionBorderRadius: 30,
                  passwordSectionPaddingLeft: 15,
                  passwordSectionSpacing: 20,
                  passwordSectionPaddingRight: 15,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'By continuing, you agree to \n Terms of Use and Privacy Policy.',
                    style: TextStyle(
                      fontSize: fs12,
                      fontFamily: 'Poppins',
                      height: 1.67,
                      letterSpacing: 1.295,
                      color: white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
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
                    onPressed: onSignupButtonPress,
                  ),
                ),
                SizedBox(
                  width: 273,
                  height: 28,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onAlreadyHaveAnPress,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                          children: [
                            TextSpan(
                              style: TextStyle(color: white),
                              text: 'Already have an account?  ',
                            ),
                            TextSpan(
                              style: TextStyle(color: gold),
                              text: 'Log In',
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
        ),
      ),
    );
  }
}
