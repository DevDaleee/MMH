import "package:flutter/material.dart";

showSnackBar(
    {required BuildContext context,
    required String texto,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(texto),
    backgroundColor: (isError) ? Colors.red : Colors.green,
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: "Ok",
      textColor: Colors.white,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
