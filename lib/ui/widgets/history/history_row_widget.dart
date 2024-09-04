import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickup_parent/models/ride_history_model.dart';
import 'package:pickup_parent/src/app/extensions.dart';
import 'package:pickup_parent/src/theme/base_theme.dart';
import 'package:pickup_parent/ui/views/history/history_viewmodel.dart';

class HistoryRowWidget extends StatelessWidget {
  final String image;
  final String heading;
  final String containerText;
  final double containerWidth;
  final bool isThisList;
  final List<HistoryData>? childrenNameList;
  final Color historyColor = lightThemeHistoryColor;
  ScrollController scrollController = ScrollController();

  HistoryRowWidget({
    super.key,
    this.isThisList = false,
    this.childrenNameList,
    this.containerWidth = 150,
    required this.image,
    required this.containerText,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
        SizedBox(height: 18, width: 18, child: SvgPicture.asset(image)),
        6.hSpace(),
        Text(
          heading,
          style: textTheme.headlineSmall!.copyWith(fontSize: 12),
        ),
        const Spacer(),
        isThisList
            ? nameList(
                childrenNameList: childrenNameList ?? [],
                textTheme: textTheme,
                theme: theme)
            : Container(
                width: containerWidth,
                child: Wrap(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                            color: historyColor,
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          containerText,
                          overflow: TextOverflow.ellipsis,
                          style:
                              textTheme.headlineSmall!.copyWith(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
      ],
    );
  }

  Container nameList({
    required List<HistoryData> childrenNameList,
    required TextTheme textTheme,
    required ThemeData theme,
  }) {
    return Container(
      width: 190,
      height: 28,
      alignment: Alignment.centerRight,
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsetsDirectional.only(end: 5),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: childrenNameList.length,
          itemBuilder: (context, index) {
            return Center(
              child: Row(
                children: [
                  Text(
                    "${childrenNameList[index].child?.name}",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 0,
                      fontSize: 12,
                    ),
                  ),
                  if (childrenNameList.length > 1 &&
                      index < childrenNameList.length - 1)
                    Text(
                      ',',
                      style: textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 0,
                        fontSize: 12,
                      ),
                    )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => 5.hSpace(),
        ),
      ),
    );
  }
}
