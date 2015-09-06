//
//  UIView+CurveAnimation.h
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import <UIKit/UIKit.h>

@interface UIView (CurveAnimation)
+ (void)animateWithDuration:(NSTimeInterval)duration
                      curve:(UIViewAnimationCurve)curve
                  animations:(void(^)(void))animations;
@end
