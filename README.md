# STNavigationBarAutoHide

[![CI Status](https://img.shields.io/travis/talon/STNavigationBarAutoHide.svg?style=flat)](https://travis-ci.org/talon/STNavigationBarAutoHide)
[![Version](https://img.shields.io/cocoapods/v/STNavigationBarAutoHide.svg?style=flat)](https://cocoapods.org/pods/STNavigationBarAutoHide)
[![License](https://img.shields.io/cocoapods/l/STNavigationBarAutoHide.svg?style=flat)](https://cocoapods.org/pods/STNavigationBarAutoHide)
[![Platform](https://img.shields.io/cocoapods/p/STNavigationBarAutoHide.svg?style=flat)](https://cocoapods.org/pods/STNavigationBarAutoHide)

NavigationBar automatically hides when scrolling, same as twitter. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![DemoHomeVC](https://github.com/Talon2333/STNavigationBarAutoHide/blob/main/Example/Demo%20Gif/DemoHomeVC.gif)|![DemoNextVC](https://github.com/Talon2333/STNavigationBarAutoHide/blob/main/Example/Demo%20Gif/DemoNextVC.gif)
---|---
## Requirements

This library requires iOS 13.0+ and Xcode 13.0+.

## Installation

STNavigationBarAutoHide is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'STNavigationBarAutoHide'
```

## Usage

### How to use？

Just need to configure scrollview in your controller.
```
[self st_navigationBarAutoHideConfigureScrollView:yourScrollView];
```

### AutoHideEnabled
Whether auto-hide is available.
```
- (BOOL)st_navigationBarAutoHideEnabled;

- (void)st_setNavigationBarAutoHideEnabled:(BOOL)navigationBarAutoHideEnabled;
```

## Author

talon, talon23333@gmail.com

## Feedback

If you are having problem, post to the Issue or email me. Also if this project helped you, please give me a star. 

## License

STNavigationBarAutoHide is available under the MIT license. See the LICENSE file for more info.
