//
//  FDKeyboardManager.m
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import "FDKeyboardManager.h"

@interface FDKeyboardManager () {
    UITableView * _tableView;
}
- (void)_keyboardWillShow:(NSNotification *)notification;
- (void)_keyboardWillHide:(NSNotification *)notification;
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

}

- (void)_keyboardWillHide:(NSNotification *)notification {

}

@end
