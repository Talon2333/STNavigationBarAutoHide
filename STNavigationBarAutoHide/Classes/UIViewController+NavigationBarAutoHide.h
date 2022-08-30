//
//  UIViewController+NavigationBarAutoHide.h
//  TwitterNavigationBarAutoHide
//
//  Created by talon on 2022/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBarAutoHide)

/// Configure ScrollView And AutoHideEnabled Default True
- (void)st_navigationBarAutoHideConfigureScrollView:(UIScrollView *)scrollView;

/// AutoHideEnabled
- (BOOL)st_navigationBarAutoHideEnabled;
- (void)st_setNavigationBarAutoHideEnabled:(BOOL)navigationBarAutoHideEnabled;

@end

NS_ASSUME_NONNULL_END
