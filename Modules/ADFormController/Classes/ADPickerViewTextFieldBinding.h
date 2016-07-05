//
//  ADPickerViewTextFieldBinding.h
//  FormDemo
//
//  Created by Pierre Felgines on 28/12/15.
//
//

#import <Foundation/Foundation.h>

@protocol FormPickerDataSource;

@interface ADPickerViewTextFieldBinding : NSObject

@property (nonatomic, strong, readonly) UIPickerView * pickerView;
@property (nonatomic, strong) id<FormPickerDataSource> formPickerDataSource;

- (instancetype)initWithTextField:(UITextField *)textField;
- (void)startEditing;

@end
