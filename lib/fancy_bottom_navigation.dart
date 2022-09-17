library fancy_bottom_navigation;

import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:fancy_bottom_navigation/paint/half_clipper.dart';
import 'package:fancy_bottom_navigation/paint/half_painter.dart';
import 'package:flutter/material.dart';

const double CIRCLE_SIZE = 60;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 90;
const double CIRCLE_OUTLINE = 10;
const double SHADOW_ALLOWANCE = 20;
const double BAR_HEIGHT = 60;

class FancyBottomNavigation extends StatefulWidget {
  FancyBottomNavigation({
    required this.tabs,
    required this.onTabChangedListener,
    this.key,
    this.initialSelection = 0,
    this.circleColor,
    this.textStyle,
    this.barBackgroundColor,
  })  : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length <= 5);

  final Function(int position) onTabChangedListener;
  final Color? circleColor;
  final Color? barBackgroundColor;
  final TextStyle? textStyle;
  final List<TabData> tabs;
  final int initialSelection;

  final Key? key;

  @override
  FancyBottomNavigationState createState() => FancyBottomNavigationState();
}

class FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin, RouteAware {
  Widget nextIcon = SizedBox();
  Widget activeIcon = SizedBox();

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  late Color circleColor;
  late Color barBackgroundColor;
  late TextStyle textStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].activeIcon;

    circleColor = widget.circleColor ?? Theme.of(context).primaryColor;

    barBackgroundColor = widget.barBackgroundColor ??
        ((Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white);
    textStyle = widget.textStyle ??
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].activeIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          height: BAR_HEIGHT,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: barBackgroundColor,
            borderRadius:
                BorderRadiusDirectional.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.tabs
                .map((t) => TabItem(
                    uniqueKey: t.key,
                    selected: t.key == widget.tabs[currentSelected].key,
                    icon: t.icon,
                    title: t.title,
                    textStyle: textStyle,
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
        Container(
          height: MediaQuery.of(context).padding.bottom,
          color: barBackgroundColor,
        ),
        Positioned.fill(
          top: -(CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE) / 2,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).padding.bottom,
          child: Container(
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              curve: Curves.easeOut,
              alignment: Alignment(_circleAlignX, 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: FractionallySizedBox(
                  widthFactor: 1 / widget.tabs.length,
                  child: GestureDetector(
                    onTap: widget.tabs[currentSelected].onclick as void
                        Function()?,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height:
                              CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                          width:
                              CIRCLE_SIZE + CIRCLE_OUTLINE + SHADOW_ALLOWANCE,
                          child: ClipRect(
                            clipper: HalfClipper(),
                            child: Container(
                              child: Center(
                                child: Container(
                                  width: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                  height: CIRCLE_SIZE + CIRCLE_OUTLINE,
                                  decoration: BoxDecoration(
                                    color: barBackgroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 8)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ARC_HEIGHT,
                          width: ARC_WIDTH,
                          child: CustomPaint(
                            painter: HalfPainter(barBackgroundColor),
                          ),
                        ),
                        SizedBox(
                          height: CIRCLE_SIZE,
                          width: CIRCLE_SIZE,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: circleColor),
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: AnimatedOpacity(
                                duration:
                                    Duration(milliseconds: ANIM_DURATION ~/ 5),
                                opacity: _circleIconAlpha,
                                child: activeIcon,
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
          ),
        )
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
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

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData(
      {required this.icon,
      required this.activeIcon,
      required this.title,
      this.onclick});

  Widget icon;
  Widget activeIcon;
  String title;
  Function? onclick;
  final UniqueKey key = UniqueKey();
}
