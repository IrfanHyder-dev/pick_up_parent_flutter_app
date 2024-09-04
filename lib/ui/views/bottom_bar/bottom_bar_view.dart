import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup_parent/blank_screen.dart';
import 'package:pickup_parent/ui/views/history/history_view.dart';
import 'package:pickup_parent/ui/views/home/home_view.dart';
import 'package:pickup_parent/ui/views/settings/settings_view.dart';
import 'package:pickup_parent/ui/views/subscription/subscription_view.dart';
import 'package:pickup_parent/ui/widgets/pop_scope_dialog_widget.dart';


class BottomBarView extends StatefulWidget {
  int index;
  BottomBarView({super.key,required this.index});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  /// Controller to handle PageView and also handles initial page
  PageController _pageController = PageController(initialPage: 2);

  int maxCount = 5;

@override
  void initState() {
  print('========================> bottom bar ${widget.index} <========================');
  _pageController = PageController(initialPage: widget.index);
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const BlackScreen(),
    const SubscriptionView(),
    const HomeView(),
    const HistoryView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return PopScopeDialogWidget();
          },
        );
        if (shouldPop == true) {
          MoveToBackground.moveTaskToBack();
          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
                bottomBarPages.length, (index) => bottomBarPages[index]),
          ),
          extendBody: true,
          bottomNavigationBar: CircleNavBar(
            onTap: (v) {
              setState(() {
                widget.index = v;
                _pageController.jumpToPage(widget.index);
              });
            },

            activeIcons: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/navbar_first_icon.svg',
                  height: 20,
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/subscription_white_icon.svg'),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/home_white_icon.svg'),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  'assets/history_white_icon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/setting_white_icon.svg'),
              ),
            ],
            inactiveIcons: [
              SvgPicture.asset('assets/navbar_first_icon.svg'),
              SvgPicture.asset('assets/subscription_black_icon.svg'),
              SvgPicture.asset('assets/home_black_icon.svg'),
              SvgPicture.asset('assets/history_black_icon.svg'),
              SvgPicture.asset('assets/setting_black_icon.svg'),
            ],
            color: Colors.white,
            circleColor: theme.primaryColor,
            height: 60,
            circleWidth: 55,
            iconCurve: Curves.fastOutSlowIn,
            cornerRadius: BorderRadius.only(
              topLeft: widget.index == 0 ? Radius.circular(2) : Radius.circular(8),
              topRight: widget.index == 4 ? Radius.circular(2) : Radius.circular(8),
            ),
            shadowColor: Colors.grey,
            elevation: 5,
            activeIndex: widget.index,
          )
      ),
    );
  }
}
