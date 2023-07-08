import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CirillaQuantity extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final double width;
  final double height;
  final Color? color;
  final Color? borderColor;
  final int? min;
  final int? max;
  final Function? actionZero;
  final double? radius;
  final TextStyle? textStyle;

  const CirillaQuantity({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 34,
    this.width = 90,
    this.color,
    this.min = 1,
    this.max,
    this.actionZero,
    this.radius,
    this.borderColor,
    this.textStyle,
  })  : assert(height >= 28),
        assert(width >= 64),
        super(key: key);

  @override
  State<CirillaQuantity> createState() => _CirillaQuantityState();
}

class _CirillaQuantityState extends State<CirillaQuantity> with ShapeMixin {
  late TextEditingController _controller;
  late String _initValue;

  @override
  void initState() {
    _initValue = '${widget.value}';
    _controller = TextEditingController(text: '${widget.value}');
    super.initState();
  }

  void _handleUpdate(int value) {
    widget.onChanged!.call(value);
  }

  void _handleChanged(String newValue) {
    int qty = ConvertData.stringToInt(newValue, widget.min ?? 1);
    int max = widget.max ?? 9999;
    if (widget.onChanged != null && qty <= max) {
      _handleUpdate(qty);
    }
  }

  void _onBlur(PointerDownEvent event) {
    int qty = ConvertData.stringToInt(_controller.text, 0);
    FocusScope.of(context).unfocus();
    if (_controller.text == '' || widget.min == null || qty < widget.min!) {
      _controller.text = _initValue;
    }
  }

  void _increase() {
    int qty = ConvertData.stringToInt(_controller.text, widget.min ?? 1);
    if (widget.max == null || qty < widget.max!) {
      qty++;
    }
    _handleUpdate(qty);
    _controller.text = '$qty';
  }

  void _decrease() {
    int qty = ConvertData.stringToInt(_controller.text, widget.min ?? 1);
    if (widget.min == null || qty > widget.min!) {
      qty--;
    }
    _handleUpdate(qty);
    _controller.text = '$qty';
  }

  @override
  Widget build(BuildContext context) {
    double heightItem = widget.height;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius ?? 4),
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
      ),
      height: heightItem,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          buildIconButton(
            onTap: widget.min != null && widget.min == widget.value ? null : _decrease,
            icon: Icons.remove_rounded,
          ),
          Expanded(child: buildInput()),
          buildIconButton(
            onTap: widget.max != null && widget.max == widget.value ? null : _increase,
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    ThemeData theme = Theme.of(context);
    TextStyle? textStyle =
        theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color).merge(widget.textStyle);
    return TextFormField(
      controller: _controller,
      onChanged: _handleChanged,
      onTapOutside: _onBlur,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: textStyle,
    );
  }

  Widget buildIconButton({
    required IconData icon,
    GestureTapCallback? onTap,
  }) {
    ThemeData theme = Theme.of(context);
    Widget child = Container(
      height: double.infinity,
      width: 32,
      padding: paddingHorizontalTiny,
      child: Icon(
        icon,
        size: 16,
        color: onTap != null ? theme.textTheme.titleMedium?.color : theme.textTheme.bodyMedium?.color,
      ),
    );
    return onTap != null ? InkWell(onTap: onTap, child: child) : child;
  }
}
