import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';

class WideButton extends StatelessWidget {

  final Function? onTap;
  final String? title;

  const WideButton({Key? key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap!,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppConfig.gradient,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(title!, style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }
}
