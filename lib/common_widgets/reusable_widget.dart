import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String labelText;
  final VoidCallback onPressed;

  const ReusableWidget({
    Key? key,
    required this.labelText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black, 
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        CupertinoButton(
          onPressed: onPressed,
          child: const SizedBox(
            width: 80,
            height: 15,
            child: Center(
              child: Image(
                image: AssetImage('assets/img/arrow-forward.png'),
                width: 80,
                height: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
