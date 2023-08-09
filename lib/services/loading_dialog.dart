import 'package:e_commerce/services/custom_circular.dart';
import 'package:flutter/material.dart';


void showLoading({required BuildContext context})async {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      print(5);
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(),
          child: const Center(
            child: SizedBox(
              height: 70.0,
              width: 70.0,
              child: CustomCircularProgressIndicator(strokeWidth: 6,),
            ),
          ),
        ),
      );
    },
  );
}

void hideLoading({required BuildContext? dialogContext}) async {
  if (dialogContext != null) Navigator.pop(dialogContext);
}