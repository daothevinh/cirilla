import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

class FieldDate extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final Color? color;

  const FieldDate({
    Key? key,
    this.value,
    this.align,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value is String && value.isNotEmpty == true) {
      TextAlign textAlign = align == 'center'
          ? TextAlign.center
          : align == 'right'
              ? TextAlign.end
              : TextAlign.start;
      return Text(
        value,
        textAlign: textAlign,
        style: TextStyle(color: color),
      );
    }
    return Container();
  }
}
