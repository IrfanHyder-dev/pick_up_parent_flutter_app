import 'package:flutter/material.dart';
import 'package:pickup_parent/models/all_subscriptions_model.dart';


import 'package:pickup_parent/src/app/constants/constants.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';

class ChildNamesDialogWidget extends StatelessWidget {
  List<ChildElement> child = [];
  ChildNamesDialogWidget({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: lightThemeFirstGradientColor,
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hMargin,vertical: hMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subscription For',style: textTheme.displayLarge!.copyWith(fontSize: 18),),
                10.vSpace(),
                Container(
                  height: 150,

                  child: ListView.separated(
                    padding: EdgeInsetsDirectional.only(start: 10,end: 20,top: 10,bottom: 10),
                    itemCount: child.length,
                    itemBuilder: (context, index) {
                    return Text(child[index].child?.name ?? '',style: textTheme.displayMedium,);
                  }, separatorBuilder: (context, index) => Divider(color: theme.dividerColor,),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
