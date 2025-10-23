import 'package:Athanapp/theme/tokens.dart';
import 'package:flutter/material.dart';

class PassContainer extends StatelessWidget {
  final String? titlePlaceholderText;
  final double passwordSectionPadding;
  final MainAxisAlignment passwordSectionMainAxisAlignment;
  final double passwordSectionBorderRadius;
  final double passwordSectionPaddingLeft;
  final double passwordSectionSpacing;
  final double passwordSectionPaddingRight;

  const PassContainer({
    super.key,
    this.titlePlaceholderText,
    this.passwordSectionPadding = 10,
    this.passwordSectionMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.passwordSectionBorderRadius = 20,
    this.passwordSectionPaddingLeft = 10,
    this.passwordSectionSpacing = 0,
    this.passwordSectionPaddingRight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Flex(
        spacing: gap5,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(left: padding10, right: padding10),
            width: double.infinity,
            child: Flex(
              spacing: gap10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    titlePlaceholderText!,
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
                    Radius.circular(passwordSectionBorderRadius),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(passwordSectionBorderRadius),
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
                  width: 34.1,
                  padding: const EdgeInsets.only(
                    top: padding10,
                    right: padding10,
                  ),
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    width: width241,
                    height: height20,
                    constraints: const BoxConstraints(maxHeight: 20),
                    child: Image(
                      image: AssetImage('assets/eye-icon@2x.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                suffixIconConstraints: BoxConstraints(maxWidth: 34.1),
                hintText: "●●●●●●●●",
                contentPadding: EdgeInsets.only(
                  top: 0,
                  left: passwordSectionPaddingLeft,
                  right: passwordSectionPaddingRight,
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
    );
  }
}
