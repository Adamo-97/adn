import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class InfoPageTemplateEN extends StatelessWidget {
  const InfoPageTemplateEN({super.key});

  @override
  Widget build(BuildContext context) {
    onBackButtonIconPress() {
      // Please sync "purification_screen_EN" to the project
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF212121),
        appBar: AppBar(
          title: Text(
            'Page Title',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.8,
              color: white,
            ),
            textAlign: TextAlign.center,
          ),
          leading: Container(
            width: width30,
            height: 36,
            padding: const EdgeInsets.only(top: 3, bottom: 3),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onBackButtonIconPress,
                child: SizedBox(
                  width: width30,
                  height: height30,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onBackButtonIconPress,
                      child: const Image(
                        image: AssetImage('assets/back-button@2x.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Container(
              width: width30,
              height: 36,
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: const SizedBox(
                width: width30,
                height: height30,
                child: Image(
                  image: AssetImage('assets/Share@2x.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          backgroundColor: white,
          centerTitle: true,
          toolbarHeight: 36,
        ),
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: height932,
                padding: const EdgeInsets.only(
                  top: 44,
                  left: padding25,
                  right: padding25,
                  bottom: 657,
                ),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: Offset(0, 24),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(br5)),
                  color: greyHighlight,
                ),
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 600),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      Container(
                        height: 66,
                        padding: const EdgeInsets.only(
                          top: padding10,
                          bottom: 9,
                        ),
                        width: double.infinity,
                        child: Flex(
                          spacing: gap10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            SizedBox(),
                            const SizedBox(
                              height: height1,
                              width: double.infinity,
                              child: Image(
                                image: AssetImage('assets/Devider@2x.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: padding5,
                          bottom: padding100,
                        ),
                        width: double.infinity,
                        constraints: const BoxConstraints(minWidth: 200),
                        height: 165,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Flex(
                            spacing: gap8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            direction: Axis.vertical,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: fs18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.23,
                                    color: white,
                                  ),
                                  expands: true,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br5),
                                      ),
                                    ),
                                    fillColor: darkGreen,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      fontSize: fs18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.23,
                                      color: white,
                                    ),
                                    hintText: "paragraph",
                                    contentPadding: EdgeInsets.only(
                                      top: 0,
                                      left: padding5,
                                      bottom: 0,
                                    ),
                                    constraints: BoxConstraints.expand(
                                      width: width325,
                                      height: 32,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: padding10,
                                  right: padding10,
                                ),
                                width: double.infinity,
                                child: const Flex(
                                  spacing: gap5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.vertical,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'this is the paragraph',
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -45,
                bottom: 0,
                child: Container(
                  width: 466,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      transform: GradientRotation(3.14 * 0),
                      colors: [Color(0xFF212121), Color(0x00212121)],
                      stops: [0.08, 1],
                    ),
                  ),
                  child: const Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.horizontal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
