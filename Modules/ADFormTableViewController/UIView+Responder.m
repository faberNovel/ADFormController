//
//  UIView+Responder.m
//  ChicTypes
//
//  Created by Pierre on 02/06/2015.
//
//

#import "UIView+Responder.h"

@implementation UIView (Responder)

- (UIView *)ct_findFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    for (UIView * subView in self.subviews) {
        UIView * firstResponder = [subView ct_findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

@end