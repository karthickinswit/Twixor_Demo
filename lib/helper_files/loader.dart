import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderDialog {

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    var wid = MediaQuery.of(context).size.width / 2;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 130 , right: 130),
          child: Dialog(
              key: key,
              backgroundColor: Colors.white,
              child: Container(
                width: 60.0,
                height: 60.0,
                child:  Image.asset(
                  'images/loaderOld.gif',
                  height: 60,
                  width: 60,
                ),
              )
          ),
        );
      },
    );
  }
}