import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode requestfocusNode;
  final IconData? prefixIcon;
  final int? maxLine;
  final bool? enabled;
  const CustomTextField({
    required this.labelName,
    required this.controller,
    required this.focusNode,
    required this.requestfocusNode,
    this.maxLine,
    this.prefixIcon,
    this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 15),
      child: TextFormField(
        enabled: enabled ?? true,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return StringConstants.textfieldError;
          }
          return null;
        },
        onEditingComplete: () {
          requestfocusNode.requestFocus();
        },
        keyboardType: TextInputType.text,
        maxLines: maxLine ?? 1,
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: prefixIcon == null ? 20 : 10, minHeight: 0),
          prefixIcon: prefixIcon == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    prefixIcon,
                    color: ColorConstants.greyColor,
                    size: ImageSizes.mini.value,
                  ),
                ),
          labelText: labelName,
          labelStyle: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.greyColor, fontWeight: FontWeight.w500),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          contentPadding: EdgeInsets.only(left: 10, top: 18, bottom: 15, right: 10),
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
