//
//  ADTextField.m
//  FormDemo
//
//  Created by Pierre Felgines on 26/11/15.
//
//

#import "ADTextField.h"

@implementation ADTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:) && self.disablePasteAction) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
