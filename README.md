# FancyBottomNavigation

![Fancy Gif](https://github.com/tunitowen/fancy_bottom_navigation/blob/master/fancy_gif.gif "Fancy Gif")

WIP .. not ready for publication yet .. soon though

## Limitations
For now this is limited to more than 1 tab, and less than 5. So 2-4 tabs.

## Attributes
### required
**tabs** -> List of `TabData` objects<br/>
**context** -> Current `BuildContext`<br/>
**onTabChangedListener** -> Function to handle a tap on a tab, receives `int position`

### optional
**initialSelection** -> Defaults to 0<br/>
**circleColor** -> Defaults to null, derives from `Theme`<br/>
**activeIconColor** -> Defaults to null, derives from `Theme`<br/>
**inactiveIconColor** -> Defaults to null, derives from `Theme`<br/>
**taxtColor** -> Defaults to null, derives from `Theme`<br/>
**barBagroundColor** -> Defaults to null, derives from `Theme`<br/>

## Theming

The bar will attempt to use your current theme out of the box, however you may want to theme it. Here are the attributes:


![Fancy Theming](https://github.com/tunitowen/fancy_bottom_navigation/blob/master/fancy_theming.png "Fancy Theming")