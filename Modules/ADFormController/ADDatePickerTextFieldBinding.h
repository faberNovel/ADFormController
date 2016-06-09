//
//  ADDatePickerTextFieldBinding.h
//  FormDemo
//
//  Created by Pierre Felgines on 28/12/15.
//
//

#import <Foundation/Foundation.h>

@interface ADDatePickerTextFieldBinding : NSObject

@property (nonatomic, strong, readonly) UIDatePicker * datePicker;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;

- (instancetype)initWithTextField:(UITextField *)textField;
- (void)startEditing;

@end

