import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/widgets/ProgressWidget.dart';

class LoadingAlertDialog extends StatelessWidget
{
  final String? message;
  const LoadingAlertDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text(message!),
        ],
      ),
    );
  }
}
