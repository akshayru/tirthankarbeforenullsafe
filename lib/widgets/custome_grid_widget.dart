import 'package:tirthankar/core/const.dart';
import 'package:flutter/material.dart';

class CustomGridWidget extends StatelessWidget {
  final Widget child;
  final double sizew;
  final double sizeh;
  final double borderWidth;
  final String image;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  CustomGridWidget(
      {this.child,
      @required this.sizew,
      @required this.sizeh,
      @required this.onTap,
      this.label,
      this.borderWidth = 2,
      this.image,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.elliptical(12, 12),
      ),
      border: Border.all(
        width: borderWidth,
        color: isActive ? AppColors.darkBlue : AppColors.mainColor,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightBlueShadow,
          blurRadius: 10,
          offset: Offset(5, 5),
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Colors.white60,
          blurRadius: 10,
          offset: Offset(-5, -5),
          spreadRadius: 3,
        )
      ],
    );

    if (image != null) {
      boxDecoration = boxDecoration.copyWith(
        image:
            DecorationImage(image: ExactAssetImage(image), fit: BoxFit.cover),
      );
    }
    if (isActive) {
      boxDecoration = boxDecoration.copyWith(
        gradient: RadialGradient(colors: [
          AppColors.lightBlue,
          AppColors.darkBlue,
        ]),
      );
    } else {
      boxDecoration = boxDecoration.copyWith(
        gradient: RadialGradient(colors: [
          AppColors.mainColor,
          AppColors.mainColor,
          AppColors.mainColor,
          Colors.white
        ]),
      );
    }

    return Container(
      width: sizew,
      height: sizeh,
      decoration: boxDecoration,
      child: FlatButton(
        padding: EdgeInsets.all(10),
        onPressed: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.elliptical(10, 10),
        )),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.end,
            // children: <Widget>[
            //   Expanded(
            //     child: child ?? Container(),
            //   ),
            //   Text(
            //       '$label',
            //       style: TextStyle(
            //         color: AppColors.lightBlue,
            //         fontSize: 10,
            //       ),
            //     ),
            // ]
            //This code can put image and icon along with text in center.
            children: <Widget>[
              if (image != null) ...[
                Container(
                    // margin: EdgeInsets.only(top:70.0),
                    ),
              ] else ...[
                child ?? Container(),
              ],
              if (label != null) ...[
                Text(
                  '$label',
                  style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 10,
                  ),
                ),
              ],
            ],

          ),
        ),
      ),
    );
  }
}
