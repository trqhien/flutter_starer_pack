import 'package:flutter/material.dart';
import 'package:widget_kit/text_styles/HMTextStyles.dart';

class HMDropDownTextField<T> extends StatefulWidget {
  final T? value;
  final String? textLabel;
  final String? hintText;
  final bool isViewOnly;
  final bool isShowIcon;
  final EdgeInsets? margin;
  final String avatar;
  final Function? onTap;
  final Widget? rightWidget;
  final FocusNode? focusNode;
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;

  HMDropDownTextField({
    this.value,
    required this.items,
    this.textLabel,
    this.avatar = "",
    this.hintText = "",
    this.isShowIcon = true,
    this.onTap,
    this.isViewOnly = false,
    this.margin,
    this.rightWidget,
    this.focusNode,
    this.onChanged,
  });

  @override
  _HMDropDownTextFieldState<T> createState() => _HMDropDownTextFieldState<T>();
}

class _HMDropDownTextFieldState<T> extends State<HMDropDownTextField> {

  late FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    if (!mounted) _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    if (mounted) setState(() {});
  }

  Decoration get _getContainerBackgroundColor => BoxDecoration(
    color: widget.isViewOnly
      ? Colors.purple
      : Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    border: Border.all(
      color: widget.isViewOnly
        ? Colors.purple
        : Colors.black
    )
  );

  // Color get _getColorText {
  //   if (widget.isViewOnly)
  //     return Colors.purple;
  //   else if (widget.text.isNotEmpty)
  //     return Colors.grey.shade800;
  //   else
  //     return Colors.grey;
  // }

  TextStyle get _hintTextStyle => HMTextStyles.b2.copyWith(color: Colors.grey);

  TextStyle get _titleTextStyle => _focusNode.hasFocus
    ? HMTextStyles.h8.copyWith(color: Colors.grey)
    : HMTextStyles.h7.copyWith(color: Colors.grey);

  TextStyle get _normalBankBeText => HMTextStyles.b2;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.purple.shade300,
      padding: widget.margin ?? EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 1,
            // color: widget.errorText.isNotEmpty || widget.isError
            //   ? Colors.red
            //   : _focusNode.hasFocus
            //     ? Colors.black
            //     : widget.isEnable
            //       ? Colors.black
            //       : Colors.grey.shade400
          ),
        ),
        child: DropdownButtonFormField<T>(
          focusNode: _focusNode,
          value: widget.value,
          isExpanded: true,
          elevation: 0,
          items: (widget as HMDropDownTextField<T>).items,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            hintText: widget.hintText,
            hintStyle: _hintTextStyle,
            labelText: widget.textLabel,
            labelStyle: _titleTextStyle,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            ),
          ),
          style: _normalBankBeText,
          iconSize: 20,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (_selectedItem) {
            (widget as HMDropDownTextField<T>).onChanged?.call(_selectedItem);
          },
        ),
      ),
    );
  }
}
