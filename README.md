# FancyBottomNavigation

![Fancy Gif](https://github.com/tunitowen/fancy_bottom_navigation/blob/master/fancy_gif.gif "Fancy Gif")

## Getting Started

Add the plugin (pub coming soon):

```yaml
dependencies:
  ...
  fancy_bottom_navigation: ^0.3.2
```

## Limitations
For now this is limited to more than 1 tab, and less than 5. So 2-4 tabs.

## Basic Usage

Adding the widget
```dart
bottomNavigationBar: FancyBottomNavigation(
    tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.search, title: "Search"),
        TabData(iconData: Icons.shopping_cart, title: "Basket")
    ],
    onTabChangedListener: (position) {
        setState(() {
        currentPage = position;
        });
    },
)
```

## TabData
**iconData** -> Icon to be used for the tab<br/>
**title** -> String to be used for the tab<br/>
**onClick** -> Optional function to be used when the circle itself is clicked, on an active tab

## Attributes
### required
**tabs** -> List of `TabData` objects<br/>
**onTabChangedListener** -> Function to handle a tap on a tab, receives `int position`

### optional
**initialSelection** -> Defaults to 0<br/>
**circleColor** -> Defaults to null, derives from `Theme`<br/>
**activeIconColor** -> Defaults to null, derives from `Theme`<br/>
**inactiveIconColor** -> Defaults to null, derives from `Theme`<br/>
**textColor** -> Defaults to null, derives from `Theme`<br/>
**barBackgroundColor** -> Defaults to null, derives from `Theme`<br/>
**key** -> Defaults to null<br/>

## Theming

The bar will attempt to use your current theme out of the box, however you may want to theme it. Here are the attributes:


![Fancy Theming](https://github.com/tunitowen/fancy_bottom_navigation/blob/master/fancy_theming.png "Fancy Theming")

## Programmatic Selection

To select a tab programmatically you will need to assign a GlobalKey to the widget. When you want to change tabs you will need to access the State using this key, and then call `setPage(position)`.<br/>
See example project, main.dart, line 75 for an example.

## Showcase
Using this package in a live app, let me know and I'll add you app here.


## Inspiration

This package was inspired by a design on dribbble by Manoj Rajput:<br/>
https://dribbble.com/shots/5419022-Tab

## Contributing

Contributions are welcome, please submit a PR :)
