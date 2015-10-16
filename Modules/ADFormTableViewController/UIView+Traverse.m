//
//  UIView+Traverse.m
//  FormDemo
//
//  Created by Pierre Felgines on 16/10/2015.
//
//

#import "UIView+Traverse.h"

@implementation UIView (Traverse)

- (UIView *)ad_superviewOfClass:(Class)viewClass {
    UIView * view = self;
    while (view != nil) {
        if ([view isKindOfClass:viewClass]) {
            return view;
        }
        view = view.superview;
    }
    return nil;
}


@end
