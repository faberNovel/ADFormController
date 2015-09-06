//
//  UIView+CurveAnimation.m
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import "UIView+CurveAnimation.h"

@implementation UIView (CurveAnimation)

+ (void)animateWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve animations:(void(^)(void))animations {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve]; {
        if (animations) {
            animations();
        }
    } [UIView commitAnimations];
}

@end
