library fancy_bottom_navigation;

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:fancy_bottom_navigation/paint/half_clipper.dart';
import 'package:fancy_bottom_navigation/paint/half_painter.dart';

const double CIRCLE_SIZE = 60;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 90;
const double CIRCLE_OUTLINE = 10;
const double SHADOW_ALLOWANCE = 20;
const double BAR_HEIGHT = 60;

class FancyBottomNavigation extends StatefulWidget {
  FancyBottomNavigation(
      {@required this.tabs,
      @required this.context,
      this.initialSelection = 0,
      this.onTabChangedListener,
      this.circleColor,
      this.activeIconColor,
      this.inactiveIconColor,
      this.textColor,
      this.barBackgroundColor})
      : assert(onTabChangedListener != null),
        assert(context != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 5);

  final Function(int position) onTabChangedListener;
  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;
  final BuildContext context;

  @override
  _FancyBottomNavigationState createState() => _FancyBottomNavigationState();
}

class _FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
    circleColor = (widget.circleColor == null)
        ? (Theme.of(widget.context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(widget.context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(widget.context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(widget.context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null)
        ? (Theme.of(widget.context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(widget.context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(widget.context).primaryColor
        : widget.inactiveIconColor;
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    setState(() {
      currentSelected = selected;
      _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
      nextIcon = widget.tabs[selected].iconData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: BAR_HEIGHT,
          margin: EdgeInsets.only(top: (CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE)/2),
          decoration: BoxDecoration(color: barBackgroundColor, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.tabs
                .map((t) => TabItem(
                    uniqueKey: t.key,
                    selected: t.key == widget.tabs[currentSelected].key,
                    iconData: t.iconData,
                    title: t.title,
                    iconColor: inactiveIconColor,
                    textColor: textColor,
                    callbackFunction: (uniqueKey) {
                      int selected = widget.tabs
                          .indexWhere((tabData) => tabData.key == uniqueKey);
                      widget.onTabChangedListener(selected);
                      _setSelected(uniqueKey);
                      _initAnimationAndStart(_circleAlignX, 1);
                    }))
                .toList(),
          ),
        ),
        IgnorePointer(
          child: Container(
            height: CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
            decoration: BoxDecoration(color: Colors.transparent),
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              curve: Curves.easeOut,
              alignment: Alignment(_circleAlignX, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / widget.tabs.length,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                      width: CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                      child: ClipRect(
                          clipper: HalfClipper(),
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                  height: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8)
                                      ])),
                            ),
                          )),
                    ),
                    SizedBox(
                        height: ARC_HEIGHT,
                        width: ARC_WIDTH,
                        child: CustomPaint(
                          painter: HalfPainter(barBackgroundColor),
                        )),
                    SizedBox(
                      height: CIRCLE_SIZE,
                      width: CIRCLE_SIZE,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: circleColor),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: AnimatedOpacity(
                            duration:
                                Duration(milliseconds: ANIM_DURATION ~/ 5),
                            opacity: _circleIconAlpha,
                            child: Icon(
                              activeIcon,
                              color: activeIconColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
//    _circleAlignX = to;
    _circleIconAlpha = 0;

    Future.delayed(Duration(milliseconds: ANIM_DURATION ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(Duration(milliseconds: (ANIM_DURATION ~/ 5 * 3)), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }
}

class TabData {
  TabData({@required this.iconData, @required this.title});

  IconData iconData;
  String title;
  final UniqueKey key = UniqueKey();
}
