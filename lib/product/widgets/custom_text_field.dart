import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CustomTextField extends StatefulWidget {
  final String labelName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;
  final IconData? prefixIcon;
  final int? maxLine;
  final bool? enabled;
  final bool isPassword; // Şifre alanı için yeni özellik

  const CustomTextField({
    required this.labelName,
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    this.maxLine,
    this.prefixIcon,
    this.enabled,
    this.isPassword = false, // Varsayılan olarak false
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Şifre gizleme/gösterme durumu

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        style: context.general.textTheme.bodyLarge!.copyWith(
          color: widget.enabled == false ? ColorConstants.greyColor : ColorConstants.blackColor,
          fontWeight: FontWeight.w600,
        ),
        enabled: widget.enabled ?? true,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false, // Şifre alanı için gizleme özelliği
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'textfield_error'.tr();
          }
          return null;
        },
        onEditingComplete: () {
          widget.requestfocusNode.requestFocus();
        },
        keyboardType: TextInputType.text,
        maxLines: widget.maxLine ?? 1,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.done,
        enableSuggestions: false,
        // obscuringCharacter: '*',
        autocorrect: false,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: widget.prefixIcon == null ? 20 : 10, minHeight: 0),
          prefixIcon: widget.prefixIcon == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    widget.prefixIcon,
                    color: ColorConstants.greyColor,
                    size: ImageSizes.mini.value,
                  ),
                ),
          suffixIcon: widget.isPassword // Şifre alanı için hide/show iconu
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ColorConstants.greyColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Şifre görünürlüğünü değiştir
                    });
                  },
                )
              : null,
          labelText: widget.labelName,
          labelStyle: context.general.textTheme.bodyLarge!.copyWith(
            color: ColorConstants.greyColor,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          contentPadding: const EdgeInsets.only(left: 10, top: 18, bottom: 15, right: 10),
          isDense: true,
          alignLabelWithHint: true,
          border: _buildOutlineInputBorder(borderColor: ColorConstants.blackColor),
          enabledBorder: _buildOutlineInputBorder(borderColor: ColorConstants.greyColor.withOpacity(.5)),
          focusedBorder: _buildOutlineInputBorder(borderColor: ColorConstants.primaryBlueColor),
          focusedErrorBorder: _buildOutlineInputBorder(borderColor: ColorConstants.redColor),
          errorBorder: _buildOutlineInputBorder(borderColor: ColorConstants.redColor),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({Color? borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 2),
    );
  }
}
