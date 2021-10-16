import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:utils_kit/string_utils/string_empty.dart';
import 'package:widget_kit/text_styles/HMTextStyles.dart';
import 'package:widget_kit/texts/HMText.dart';

class HMTextField extends StatefulWidget {
  final String? placeholder;
  final String? labelText;
  final String? hint;
  final bool isEnable;
  final bool isSave;
  final bool isNumber;
  final bool isCardCredit;
  final bool isCurrency;
  final bool isCounterText;
  final bool isPassword;
  final bool isVerify;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function? onTap;
  final TextInputAction textInputAction;
  final Widget? rightWidget;
  final bool isEditable;

  final List<StreamTransformer<String, String>> validatorStreams;

  HMTextField({
    this.placeholder,
    this.labelText,
    this.hint,
    this.isEnable = true,
    this.isSave = false,
    this.isNumber = false,
    this.isCardCredit = false,
    this.isCurrency = false,
    this.isCounterText = false,
    this.isPassword = false,
    this.isVerify = false,
    this.minLines = 1,
    this.maxLines,
    this.maxLength,
    this.controller,
    this.focusNode,
    this.padding,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textInputAction = TextInputAction.done,
    this.rightWidget,
    this.validatorStreams = const [],
    this.isEditable = true,
  });

  @override
  _HMTextFieldState createState() => _HMTextFieldState();
}

class _HMTextFieldState extends State<HMTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  final _textController = BehaviorSubject<String>();

  Stream<String> get _text {
    if (widget.validatorStreams.isNotEmpty) {
      Stream<String> _temp = _textController
        .debounce((_) => TimerStream(true, Duration(milliseconds: 300)))
        .skip(1)
        .distinct((prev, next) => prev == next);

      widget.validatorStreams.forEach((valiation) {
        _temp = _temp.transform(valiation);
      });

      return _temp;
    } else {
      return _textController.stream;
    }
  }

  final _characterCountController = BehaviorSubject<int>.seeded(0);
  Stream<int> get characterCount => _characterCountController.stream;

  bool get isEmptyHintText => widget.placeholder == null || widget.placeholder!.isEmpty;

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
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      _characterCountController.add(_controller.text.length);
      _textController.add(_controller.text);
    });
  }

  _onOnFocusNodeEvent() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: _buildTf(),
    );
  }

  TextStyle get _hintTextStyle => HMTextStyles.b2.copyWith(color: Colors.grey);

  TextStyle get _titleTextStyle => _focusNode.hasFocus
    ? HMTextStyles.h8.copyWith(color: Colors.grey)
    : HMTextStyles.h7.copyWith(color: Colors.grey);

  TextStyle get _normalBankBeText => HMTextStyles.b2.copyWith(color: Color(0xffB4A9F0)); 

  Decoration _containerBackgroundColor({bool isError = false}) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(4)),
    border: Border.all(
      width: isError ? 2 : 1,
      color: isError
        ? Colors.red
        : _focusNode.hasFocus
          ? Colors.black
          : widget.isEnable
            ? Colors.black
            : Colors.grey.shade400
    ),
  );

  TextInputFormatter _textInputFormatter() {
    if (widget.isCardCredit) {
      return MaskedTextInputFormatter(
        mask: 'xxxx xxxx xxxx xxxx',
        separator: ' ',
      );
    } else if (widget.isNumber) {
      if (widget.isCurrency)
        return BeBankCurrencyFormatter();
      else
        return FilteringTextInputFormatter.digitsOnly;
    } else {
      return FilteringTextInputFormatter.singleLineFormatter;
    }
  } 

  InputDecoration get noHintTextDecoration => InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.only(top: 16, bottom: 16, right: 20),
    hintText: widget.placeholder,
    hintStyle: _hintTextStyle,
    labelText: widget.labelText,
    labelStyle: _titleTextStyle,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    ),
  );

  InputDecoration get normalTextDecoration => InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.only(top: 8, bottom: 8, right: 20),
    border: InputBorder.none,
    hintText: widget.placeholder,
    counterText: widget.labelText,
    hintStyle: _hintTextStyle
  );

  Widget _buildTf() {
    return Container(
      padding: widget.padding ?? EdgeInsets.zero,
      child: StreamBuilder<String>(
        initialData: null,
        stream: _text,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: _containerBackgroundColor(isError: snapshot.hasError),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !isEmptyHintText
                          ? Row(children: [
                              widget.isSave
                                ? Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.17),
                                      borderRadius: BorderRadius.all(Radius.circular(2)),
                                      border: Border.all(color: Colors.green.withOpacity(0.17)),
                                    ),
                                    child: HMText(
                                      "ĐÃ LƯU",
                                      color: Colors.green.shade600,
                                      style: HMTextStyles.b3
                                    ),
                                  )
                                : Container()
                            ])
                          : Container(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8, 
                            bottom: 8,
                          ),
                          child: TextField(
                            cursorColor: Colors.blue,
                            minLines: widget.minLines,
                            maxLines: widget.isPassword ? 1 : widget.maxLines,
                            keyboardType: widget.isNumber
                              ? TextInputType.numberWithOptions(decimal: true)
                              : TextInputType.text,
                            obscureText: widget.isPassword,
                            inputFormatters: <TextInputFormatter>[
                              _textInputFormatter(),
                              if (widget.maxLength != null) LengthLimitingTextFieldFormatterFixed(widget.maxLength!)
                            ],
                            maxLength: widget.maxLength,
                            textInputAction: widget.textInputAction,
                            controller: _controller,
                            enabled: widget.isEnable,
                            style: widget.isEnable
                              ? _normalBankBeText.copyWith(color: Colors.grey.shade800)
                              : _normalBankBeText.copyWith(color: Colors.purple),
                            decoration: !isEmptyHintText
                              ? normalTextDecoration
                              : noHintTextDecoration,
                            focusNode: _focusNode,
                            onChanged: widget.onChanged,
                            onSubmitted: widget.onSubmitted,
                            readOnly: !widget.isEditable,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: widget.validatorStreams.isNotEmpty|| isNotEmpty(widget.hint) || widget.isCounterText
                        ? 2
                        : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (snapshot.error == null && isEmpty(widget.hint))
                          ? HMText("", style: HMTextStyles.b4)
                          : HMText(
                              snapshot.error?.toString() ?? widget.hint ?? "",
                              color: snapshot.hasError
                                ? Colors.red
                                : Colors.grey.shade600,
                              style: HMTextStyles.b4
                            ),
                        widget.isCounterText
                          ? StreamBuilder<int>(
                              stream: characterCount,
                              builder: (context, snapshot) {
                                return HMText(
                                  "${snapshot.data ?? 0}/${widget.maxLength}",
                                  color: Colors.grey.shade600,
                                  style: HMTextStyles.b4
                                );
                              }
                            )
                          : Container()
                      ],
                    ),
                  )
                ],
              ),
              _iconRight(),
            ],
          );
        }
      ),
    );
  }

  Widget _iconRight() {
    if (widget.rightWidget != null) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(right: 8, top: 17),
          child: widget.rightWidget,
        ),
      );
    }
    if (widget.isVerify) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(right: 8, top: 17),
          child: Icon(Icons.note_add, size: 24, color: Colors.purple),
        ),
      );
    } else if (_controller.text.isNotEmpty && widget.isEnable) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.only(right: 8, top: 19),
          child: InkWell(
            onTap: () {
              _focusNode.requestFocus();
              _controller.clear();
              if (widget.onChanged != null) widget.onChanged!("");
            },
            child: Icon(Icons.cancel, size: 20, color: Colors.black),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class LengthLimitingTextFieldFormatterFixed extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength != null 
      && maxLength! > 0 
      && newValue.text.characters.length > maxLength!
    ) {
      // If already at the maximum and tried to enter even more, keep the old value.
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }
      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(newValue, maxLength!);
    }
    return newValue;
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String textString = "";
    if (
      !RegExp(r'^[0-9 ]*$').hasMatch(newValue.text) &&
      newValue.text.isNotEmpty)
    {
      textString = newValue.text.substring(0, newValue.text.length - 1);
      return TextEditingValue(
        text: textString,
        selection: TextSelection.collapsed(
          offset: textString.length,
        )
      );
    }
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
          );
        }
      }
    }
    return newValue;
  }
}

class CurrencyFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = new NumberFormat("###,###");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class BeBankCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      int number;
      try {
        number = int.parse(
            newValue.text.replaceAll(",", '').replaceAll(".", ""));
      }
      catch (e) {
        if(oldValue.text.isNotEmpty) {
          number =
              int.parse(oldValue.text.replaceAll(",", '').replaceAll(".", ""));
        }
        else {
          return TextEditingValue(text: "");
        }
      }
      String newString = f.format(number);
      newString = newString.replaceAll(",", ".");
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
