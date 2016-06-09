//
//  ADPickerViewTextFieldBinding.h
//  FormDemo
//
//  Created by Pierre Felgines on 28/12/15.
//
//

#import <Foundation/Foundation.h>
#import "ADFormPickerDataSource.h"

@interface ADPickerViewTextFieldBinding : NSObject

@property (nonatomic, strong, readonly) UIPickerView * pickerView;
@property (nonatomic, strong) id<ADFormPickerDataSource> formPickerDataSource;

- (instancetype)initWithTextField:(UITextField *)textField;
- (void)startEditing;

@end
