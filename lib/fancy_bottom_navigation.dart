library fancy_bottom_navigation;

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:fancy_bottom_navigation/paint/half_clipper.dart';
import 'package:fancy_bottom_navigation/paint/half_painter.dart';
import 'package:fancy_bottom_navigation/model/tab_data.dart';

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
          height: 65,
          margin: EdgeInsets.only(top: 50),
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
            height: 100,
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
                      height: 90,
                      width: 90,
                      child: ClipRect(
                          clipper: HalfClipper(),
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 70,
                                  height: 70,
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
                        height: 70,
                        width: 90,
                        child: CustomPaint(
                          painter: HalfPainter(barBackgroundColor),
                        )),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                            border: Border.all(
                                color: Colors.white,
                                width: 5,
                                style: BorderStyle.none)),
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
