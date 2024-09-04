import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/language/language_keys.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';

class SubscriptionDetailListWidget extends StatefulWidget {
  final bool isMethodSelected;
  const SubscriptionDetailListWidget({super.key, required this.isMethodSelected});

  @override
  State<SubscriptionDetailListWidget> createState() => _SubscriptionDetailListWidgetState();
}

class _SubscriptionDetailListWidgetState extends State<SubscriptionDetailListWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    const Color packageClr = lightThemeHistoryColor;
    return Container(
      width: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:(widget.isMethodSelected)? theme.primaryColor : theme.dialogBackgroundColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
                color:(widget.isMethodSelected)? packageClr : theme.dialogBackgroundColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
                    child: Image.asset('assets/jazz_cash.png')),
                const Spacer(),
                Container(
                  height: 17,
                  width: 17,
                  margin:const  EdgeInsetsDirectional.only(end: 5,top: 5),
                  padding:const EdgeInsets.all(2),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70),
                    border: Border.all(color: (widget.isMethodSelected)?theme.primaryColor : theme.cardColor),
                    color:(widget.isMethodSelected)? theme.primaryColor: theme.dialogBackgroundColor,
                  ),
                  child:(widget.isMethodSelected)? Image.asset('assets/check.png') : null,
                )
              ],),
          ),
        ],
      ),
    );
  }
}
