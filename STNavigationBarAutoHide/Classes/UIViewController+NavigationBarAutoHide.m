//
//  UIViewController+NavigationBarAutoHide.m
//  STNavigationControllerDemo
//
//  Created by talon on 2022/8/23.
//

#import "UIViewController+NavigationBarAutoHide.h"
#import <objc/runtime.h>

#define STNavigationBarCoverViewTag 2333

@interface UIViewController () <UIScrollViewDelegate>

@end

@implementation UIViewController (NavigationBarAutoHide)

#pragma mark - ConfigureScrollView
- (void)st_navigationBarAutoHideConfigureScrollView:(UIScrollView *)scrollView {
    if (scrollView == nil) {
        NSLog(@"[ST NavigationBarAutoHide Error] scrollView cannot be nil!");
        return;
    }
    if (self.navigationController == nil) {
        NSLog(@"[ST NavigationBarAutoHide Error] self.navigationController cannot be nil!");
        return;
    }
    if (scrollView.delegate == nil) {
        scrollView.delegate = self;
    }
    [self st_setNavigationBarAutoHideEnabled:true];
    [self st_swizzleScrollViewDelegateMethod];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewWillDisappear:);
        SEL swizzleSelector = @selector(st_viewWillDisappear:);
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzleSelector);
        
        st_addMethod([self class], originalSelector, originalMethod);
        st_addMethod([self class], swizzleSelector, swizzledMethod);
        st_swizzleSelector([self class], originalSelector, swizzleSelector);
    });
}


#pragma mark - Getter&Setter
//navigationBarAutoHideEnabled
- (BOOL)st_navigationBarAutoHideEnabled {
    NSNumber *value = objc_getAssociatedObject(self, @selector(st_navigationBarAutoHideEnabled));
    return value.boolValue;
}

- (void)st_setNavigationBarAutoHideEnabled:(BOOL)navigationBarAutoHideEnabled {
    objc_setAssociatedObject(self, @selector(st_navigationBarAutoHideEnabled), @(navigationBarAutoHideEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!navigationBarAutoHideEnabled) {
        [self st_showNavigationBarWithAnimated:true];
    }
}

//navigationBarHidden
- (BOOL)st_navigationBarHidden {
    NSNumber *value = objc_getAssociatedObject(self, @selector(st_navigationBarHidden));
    return value.boolValue;
}

- (void)st_setNavigationBarHidden:(BOOL)navigationBarHidden {
    objc_setAssociatedObject(self, @selector(st_navigationBarHidden), @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//beginContentOffsetY
- (CGFloat)st_beginContentOffsetY {
    NSNumber *value = objc_getAssociatedObject(self, @selector(st_beginContentOffsetY));
    return value.floatValue;
}

- (void)st_setBeginContentOffsetY:(CGFloat)beginContentOffsetY {
    objc_setAssociatedObject(self, @selector(st_beginContentOffsetY), @(beginContentOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - viewWillDisappear
- (void)st_viewWillDisappear:(BOOL)animated {
    if ([self respondsToSelector:@selector(st_viewWillDisappear:)]) {
        [self st_viewWillDisappear:animated];
    }
    [self st_showNavigationBarWithAnimated:true];
}


#pragma mark - UIScrollViewDelegate
- (void)st_scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self respondsToSelector:@selector(st_scrollViewDidScroll:)]) {
        [self st_scrollViewDidScroll:scrollView];
    }
    
    bool enabled = [self st_navigationBarAutoHideEnabled];
    if (!enabled) return;
    
    CGFloat contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
    CGFloat scrollOffsetY = contentOffsetY - [self st_beginContentOffsetY];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    bool navigationBarHidden = [self st_navigationBarHidden];

    //hide navigationBar
    if (scrollOffsetY > 0 && !navigationBarHidden) {
        scrollOffsetY = MIN(navigationBarHeight, scrollOffsetY);
        
        if (scrollOffsetY == navigationBarHeight) {
            [self st_setNavigationBarHidden:true];
            [self st_setBeginContentOffsetY:contentOffsetY];
        }
        
        CGFloat alpha = (navigationBarHeight - scrollOffsetY) / navigationBarHeight;
        [self updateNavigationBarAlpha:alpha];
        
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -scrollOffsetY);
    }
    
    //show navigationBar
    else if (scrollOffsetY < 0 && contentOffsetY < navigationBarHeight && navigationBarHidden) {
        [self st_showNavigationBarWithAnimated:true];
    }
}

- (void)st_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self respondsToSelector:@selector(st_scrollViewWillBeginDragging:)]) {
        [self st_scrollViewWillBeginDragging:scrollView];
    }
    
    bool enabled = [self st_navigationBarAutoHideEnabled];
    if (!enabled) return;
     
    CGFloat contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
    [self st_setBeginContentOffsetY:contentOffsetY];
}

- (void)st_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self respondsToSelector:@selector(st_scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self st_scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
    bool enabled = [self st_navigationBarAutoHideEnabled];
    if (!enabled) return;
    
    //show navigationBar
    CGFloat velocityY = velocity.y;
    if (velocityY < 0) {
        [self st_showNavigationBarWithAnimated:true];
    }
    
    else if (velocityY == 0) {
        CGFloat contentOffsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
        CGFloat scrollOffsetY = contentOffsetY - [self st_beginContentOffsetY];
        CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        
        if (contentOffsetY < navigationBarHeight) {
            [self st_showNavigationBarWithAnimated:true];
            
        } else {
            CGFloat transformTy = self.navigationController.navigationBar.transform.ty;
            if (transformTy == 0 && transformTy == -navigationBarHeight) return;
            if (scrollOffsetY <= 0) return;
            
            if (transformTy >= -navigationBarHeight / 2.0) {
                [self st_showNavigationBarWithAnimated:true];

            } else {
                [self st_hideNavigationBarWithAnimated:true];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{}

#pragma mark - NavigationBar Show&Hide
- (void)st_showNavigationBarWithAnimated:(BOOL)animated {
    [self st_setNavigationBarHidden:false];
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self updateNavigationBarAlpha:1.0];
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    } else {
        [self updateNavigationBarAlpha:1.0];
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}

- (void)st_hideNavigationBarWithAnimated:(BOOL)animated {
    [self st_setNavigationBarHidden:true];
    
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self updateNavigationBarAlpha:0];
            self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -navigationBarHeight);
        }];
    } else {
        [self updateNavigationBarAlpha:0];
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -navigationBarHeight);
    }
}

#pragma mark - Swizzle
- (void)st_swizzleScrollViewDelegateMethod {
    [self st_swizzleScrollViewMethodWithOriginalSelector:@selector(scrollViewDidScroll:) swizzleSelector:@selector(st_scrollViewDidScroll:)];
    [self st_swizzleScrollViewMethodWithOriginalSelector:@selector(scrollViewWillBeginDragging:) swizzleSelector:@selector(st_scrollViewWillBeginDragging:)];
    [self st_swizzleScrollViewMethodWithOriginalSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) swizzleSelector:@selector(st_scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
}

- (void)st_swizzleScrollViewMethodWithOriginalSelector:(SEL)originalSelector swizzleSelector:(SEL)swizzleSelector {
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzleSelector);
    
    //add method
    BOOL didAddOriginalMethod = st_addMethod([self class], originalSelector, originalMethod);
    BOOL didAddSwizzledMethod = st_addMethod([self class], swizzleSelector, swizzledMethod);
    
    if (didAddOriginalMethod) {
        Method newOriginalMethod = class_getInstanceMethod([self class], originalSelector);
        //if equal, add fails
        if (originalMethod == newOriginalMethod) {
            didAddOriginalMethod = false;
        }
    }

    if (didAddSwizzledMethod) {
        Method newSwizzledMethod = class_getInstanceMethod([self class], swizzleSelector);
        //if equal, add fails
        if (swizzledMethod == newSwizzledMethod) {
            didAddSwizzledMethod = false;
        }
    }

    if (!didAddOriginalMethod && !didAddSwizzledMethod) return;
    
    st_swizzleSelector([self class], originalSelector, swizzleSelector);
}

static inline BOOL st_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

static inline void st_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


#pragma mark - Update NavigationBarAlpha
- (void)updateNavigationBarAlpha:(CGFloat)alpha {
    static Class navigationBarContentViewClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationBarContentViewClass = NSClassFromString(@"_UINavigationBarContentView");
    });

    if (navigationBarContentViewClass != nil) {
        for (UIView *view in self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:navigationBarContentViewClass]) {
                [self changeSubviewAlphaWithView:view alpha:alpha];
            }
        }
    }
    [self updateNavigationBarTitleColorWithAlpha:alpha];
}

- (void)changeSubviewAlphaWithView:(UIView *)view alpha:(CGFloat)alpha {
    static Class buttonBarStackViewClass;
    static Class modernBarButtonClass;
    static Class backButtonMaskViewClass;
    static Class backButtonContainerViewClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buttonBarStackViewClass = NSClassFromString(@"_UIButtonBarStackView");
        modernBarButtonClass = NSClassFromString(@"_UIModernBarButton");
        backButtonMaskViewClass = NSClassFromString(@"_UIBackButtonMaskView");
        backButtonContainerViewClass = NSClassFromString(@"_UIBackButtonContainerView");
    });
    
    for (UIView *subview in view.subviews)
    {
        subview.alpha = alpha;
        subview.hidden = alpha == 0;
        if ([subview isKindOfClass:buttonBarStackViewClass] ||
            [subview isKindOfClass:modernBarButtonClass] ||
            [subview isKindOfClass:backButtonMaskViewClass] ||
            [subview isKindOfClass:backButtonContainerViewClass]) {
            continue;
        }
        [self changeSubviewAlphaWithView:subview alpha:alpha];
    }
}


- (void)updateNavigationBarTitleColorWithAlpha:(CGFloat)alpha {
    if (self.navigationController.navigationBar.titleTextAttributes) {
        NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
        UIColor *titleColor = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
        if (titleColor) {
            titleColor = [titleColor colorWithAlphaComponent:alpha];
            [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
        }
        self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
        return;
    }
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *standardAppearance = self.navigationController.navigationBar.standardAppearance;
        if (standardAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = [self.navigationController.navigationBar.standardAppearance.titleTextAttributes mutableCopy];
            UIColor *titleColor = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
            if (titleColor) {
                titleColor = [titleColor colorWithAlphaComponent:alpha];
                [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
                
                standardAppearance.titleTextAttributes = titleTextAttributes;
                self.navigationController.navigationBar.standardAppearance = standardAppearance;
            }
        }
        
        UINavigationBarAppearance *scrollEdgeAppearance = self.navigationController.navigationBar.scrollEdgeAppearance;
        if (scrollEdgeAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = [self.navigationController.navigationBar.scrollEdgeAppearance.titleTextAttributes mutableCopy];
            UIColor *titleColor = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
            if (titleColor) {
                titleColor = [titleColor colorWithAlphaComponent:alpha];
                [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
                
                standardAppearance.titleTextAttributes = titleTextAttributes;
                self.navigationController.navigationBar.scrollEdgeAppearance = standardAppearance;
            }
        }
    }
}


@end
