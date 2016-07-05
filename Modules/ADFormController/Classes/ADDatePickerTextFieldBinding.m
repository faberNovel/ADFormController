//
//  ADDatePickerTextFieldBinding.m
//  FormDemo
//
//  Created by Pierre Felgines on 28/12/15.
//
//

#import "ADDatePickerTextFieldBinding.h"

@interface ADDatePickerTextFieldBinding () {
    UITextField * _textField;
}

@end

@implementation ADDatePickerTextFieldBinding

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        _textField = textField;

        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(_dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

#pragma mark - Methods

- (void)startEditing {
    if (_textField.text.length == 0) {
        [self _dateChanged:_datePicker];
    } else {
        NSDate * date = [_dateFormatter dateFromString:_textField.text];
        _datePicker.date = date;
    }
}

#pragma mark - Private

- (IBAction)_dateChanged:(UIDatePicker *)sender {
    // Use insertText to simulate touch
    _textField.text = @"";
    [_textField insertText:[self.dateFormatter stringFromDate:sender.date]];
}

@end
