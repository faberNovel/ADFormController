//
//  FDKeyboardManager.m
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import "FDKeyboardManager.h"
#import "UIView+Responder.h"

@interface FDKeyboardManager () {
    UITableView * _tableView;
}
- (void)_keyboardWillShow:(NSNotification *)notification;
- (void)_keyboardWillHide:(NSNotification *)notification;
- (UITableViewCell *)_cellFromFirstResponder;
- (UITableViewCell *)_cellForTextEdigintView:(UIView *)textEditingView;
@end

@implementation FDKeyboardManager

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        _tableView = tableView;
    }
    return self;
}

- (void)startObservingKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)endObservingKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

#pragma mark - Private

- (void)_keyboardWillShow:(NSNotification *)notification {
    UITableViewCell * cell = [self _cellFromFirstResponder];
    if (cell) {
        NSDictionary * keyboardInfo = [notification userInfo];

        NSTimeInterval keyboardAnimationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve keyboardAnimationCurve = [keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
        CGRect keyboardFrameEnd = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

        CGRect keyboardFrame = [_tableView.window convertRect:keyboardFrameEnd
                                                       toView:_tableView.superview];

        CGFloat newBottomInset = _tableView.frame.origin.y + _tableView.frame.size.height - keyboardFrame.origin.y;
        if (newBottomInset > 0){
            UIEdgeInsets tableContentInset = _tableView.contentInset;
            UIEdgeInsets tableScrollIndicatorInsets = _tableView.scrollIndicatorInsets;
            tableContentInset.bottom = newBottomInset;
            tableScrollIndicatorInsets.bottom = tableContentInset.bottom;

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:keyboardAnimationDuration];
            [UIView setAnimationCurve:keyboardAnimationCurve]; {
                _tableView.contentInset = tableContentInset;
                _tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
                NSIndexPath * selectedRow = [_tableView indexPathForCell:cell];
                [_tableView scrollToRowAtIndexPath:selectedRow
                                  atScrollPosition:UITableViewScrollPositionNone
                                          animated:NO];
            } [UIView commitAnimations];
        }
    }
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    UITableViewCell * cell = [self _cellFromFirstResponder];
    if (cell) {
        NSDictionary * keyboardInfo = [notification userInfo];

        NSTimeInterval keyboardAnimationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve keyboardAnimationCurve = [keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

        UIEdgeInsets tableContentInset = _tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = _tableView.scrollIndicatorInsets;
        tableContentInset.bottom = 0;
        tableScrollIndicatorInsets.bottom = tableContentInset.bottom;

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:keyboardAnimationDuration];
        [UIView setAnimationCurve:keyboardAnimationCurve]; {
            _tableView.contentInset = tableContentInset;
            _tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        } [UIView commitAnimations];
    }
}

- (UITableViewCell *)_cellFromFirstResponder {
    UIView * firstResponderView = [_tableView ct_findFirstResponder];
    if ([firstResponderView isKindOfClass:UITextView.class] || [firstResponderView isKindOfClass:UITextField.class]) {
        return [self _cellForTextEdigintView:firstResponderView];
    }
    return nil;
}

- (UITableViewCell *)_cellForTextEdigintView:(UIView *)textEditingView {
    UIView * view = textEditingView;
    while (view != nil) {
        if ([view isKindOfClass:UITableViewCell.class]) {
            return (UITableViewCell *)view;
        }
        view = view.superview;
    }
    return nil;
}


@end
