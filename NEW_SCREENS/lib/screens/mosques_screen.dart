import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class MosquesScreen extends StatelessWidget {
  const MosquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),

        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: white,
                height: height932,
                child: Flex(
                  spacing: gap10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: white,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            direction: Axis.vertical,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    color: gainsboro,
                                    width: 375,
                                    height: 466,
                                    alignment: AlignmentDirectional.topStart,
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    bottom: 358.9,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          transform: GradientRotation(
                                            3.14 * 0.5,
                                          ),
                                          colors: [
                                            Color(0xFF212121),
                                            Color(0x00212121),
                                          ],
                                          stops: [0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 375,
                                padding: const EdgeInsets.only(
                                  top: padding14,
                                  left: padding15,
                                  right: padding15,
                                  bottom: padding14,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x40000000),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(13),
                                    topRight: Radius.circular(13),
                                  ),
                                  color: greyHighlight,
                                ),
                                child: Flex(
                                  spacing: 23,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.vertical,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        border: Border.fromBorderSide(
                                          BorderSide(width: 1, color: gray),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: darkGreen,
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            alignment:
                                                                Alignment
                                                                    .topLeft,
                                                            child: Text(
                                                              'Address',
                                                              style: TextStyle(
                                                                fontSize: fs10,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                height: 2.2,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: Text(
                                                            '13.9 km',
                                                            style: TextStyle(
                                                              fontSize: fs7,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 3.14,
                                                              letterSpacing:
                                                                  -0.39,
                                                              color: white,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: width327,
                                            height: height1,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/devider@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            alignment:
                                                                Alignment
                                                                    .topLeft,
                                                            child: Text(
                                                              'Address',
                                                              style: TextStyle(
                                                                fontSize: fs10,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                height: 2.2,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: Text(
                                                            '13.9 km',
                                                            style: TextStyle(
                                                              fontSize: fs7,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 3.14,
                                                              letterSpacing:
                                                                  -0.39,
                                                              color: white,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: width327,
                                            height: height1,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/devider@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            alignment:
                                                                Alignment
                                                                    .topLeft,
                                                            child: Text(
                                                              'Address',
                                                              style: TextStyle(
                                                                fontSize: fs10,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                height: 2.2,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: Text(
                                                            '13.9 km',
                                                            style: TextStyle(
                                                              fontSize: fs7,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 3.14,
                                                              letterSpacing:
                                                                  -0.39,
                                                              color: white,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: width327,
                                            height: height1,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/devider@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            alignment:
                                                                Alignment
                                                                    .topLeft,
                                                            child: Text(
                                                              'Address',
                                                              style: TextStyle(
                                                                fontSize: fs10,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                height: 2.2,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: Text(
                                                            '13.9 km',
                                                            style: TextStyle(
                                                              fontSize: fs7,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 3.14,
                                                              letterSpacing:
                                                                  -0.39,
                                                              color: white,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: width327,
                                            height: height1,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/devider@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: FittedBox(
                                                            fit:
                                                                BoxFit
                                                                    .scaleDown,
                                                            alignment:
                                                                Alignment
                                                                    .topLeft,
                                                            child: Text(
                                                              'Address',
                                                              style: TextStyle(
                                                                fontSize: fs10,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                height: 2.2,
                                                                color: white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: Text(
                                                            '13.9 km',
                                                            style: TextStyle(
                                                              fontSize: fs7,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 3.14,
                                                              letterSpacing:
                                                                  -0.39,
                                                              color: white,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: width327,
                                            height: height1,
                                            child: Image(
                                              image: AssetImage(
                                                'assets/devider@2x.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Flex(
                                        spacing: gap10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Flex(
                                              spacing: gap8,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: width47,
                                                  height: height47,
                                                  decoration: const BoxDecoration(
                                                    border:
                                                        Border.fromBorderSide(
                                                          BorderSide(
                                                            width: 1,
                                                            color: gray,
                                                          ),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(br3),
                                                        ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: height45,
                                                    child: Flex(
                                                      spacing: gap3,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      direction: Axis.vertical,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Mosque name',
                                                            style: TextStyle(
                                                              fontSize: fs18,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.11,
                                                              letterSpacing:
                                                                  -0.23,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Address',
                                                            style: TextStyle(
                                                              fontSize: fs10,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              height: 2.2,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: width38,
                                                  height: height45,
                                                  child: Flex(
                                                    spacing: gap3,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    direction: Axis.vertical,
                                                    children: [
                                                      SizedBox(
                                                        width: width211,
                                                        height: height21,
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/open-map-icon@2x.png',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height21,
                                                        width: double.infinity,
                                                        child: Text(
                                                          '13.9 km',
                                                          style: TextStyle(
                                                            fontSize: fs7,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            height: 3.14,
                                                            color: white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
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
                                  ],
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
              Positioned(
                top: 54,
                left: 34,
                child: Flex(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: width30,
                      height: height30,
                      child: Image(
                        image: AssetImage('assets/location-button@2x.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextField(
                      style: TextStyle(
                        fontSize: fs12,
                        fontFamily: 'Poppins',
                        color: white50,
                      ),
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(64)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(64)),
                        ),
                        fillColor: greyHighlight,
                        filled: true,
                        hintStyle: TextStyle(
                          fontSize: fs12,
                          fontFamily: 'Poppins',
                          color: white50,
                        ),
                        hintText: "Enter location",
                        contentPadding: EdgeInsets.only(
                          top: 0,
                          left: 12,
                          bottom: 0,
                        ),
                        constraints: BoxConstraints.expand(
                          width: 236,
                          height: height30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: width30,
                      height: height30,
                      child: Image(
                        image: AssetImage('assets/search-button@2x.png'),
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
    );
  }
}
