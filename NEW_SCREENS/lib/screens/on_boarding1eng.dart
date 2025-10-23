import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class OnBoarding1ENG extends StatelessWidget {
  const OnBoarding1ENG({super.key});

  @override
  Widget build(BuildContext context) {
    onNextTextPress() {
      Navigator.pushNamed(context, 'on_boarding_2_eng');
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            height: height932,
            padding: const EdgeInsets.only(top: padding100, bottom: padding100),
            decoration: const BoxDecoration(gradient: gradient1),
            child: Flex(
              spacing: gap40,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              direction: Axis.vertical,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: padding20,
                    left: padding25,
                    right: padding25,
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
                          'Learn Prayers, Find Qibla, Track Worship',
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
                const SizedBox(
                  height: 273,
                  width: double.infinity,
                  child: Image(
                    image: AssetImage('assets/image-placeholder1@2x.png'),
                    fit: BoxFit.cover,
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
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: onNextTextPress,
                            child: const Text(
                              'Next',
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
                    ],
                  ),
                ),
                Flex(
                  spacing: gap19,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width13,
                      height: height13,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(br65)),
                        color: white,
                      ),
                    ),
                    Container(
                      width: width13,
                      height: height13,
                      decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(width: 2, color: white),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(br65)),
                      ),
                    ),
                    Container(
                      width: width13,
                      height: height13,
                      decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(width: 2, color: white),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(br65)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
