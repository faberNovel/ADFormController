//
//  NSNotification+Keyboard.h
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface NSNotification (Keyboard)
- (NSTimeInterval)keyboardAnimationDuration;
- (UIViewAnimationCurve)keyboardAnimationCurve;
- (CGRect)keyboardFrameEnd;
@end
