//
//  NSNotification+Keyboard.m
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import "NSNotification+Keyboard.h"

@implementation NSNotification (Keyboard)

- (NSTimeInterval)keyboardAnimationDuration {
    return [self.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (UIViewAnimationCurve)keyboardAnimationCurve {
    return [self.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
}

- (CGRect)keyboardFrameEnd {
    return [self.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

@end
