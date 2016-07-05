//
//  ADPickerViewTextFieldBinding.m
//  FormDemo
//
//  Created by Pierre Felgines on 28/12/15.
//
//

#import "ADPickerViewTextFieldBinding.h"

#import <ADFormController/ADFormController-Swift.h>

@interface ADPickerViewTextFieldBinding () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UITextField * _textField;
}

@end

@implementation ADPickerViewTextFieldBinding

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        _textField = textField;

        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return self;
}

#pragma mark - Methods

- (void)startEditing {
    if (_textField.text.length == 0) {
        for (int component = 0; component < self.pickerView.numberOfComponents; component++) {
            [self pickerView:self.pickerView didSelectRow:0 inComponent:component];
        }
    } else {
        NSArray * indexes = [_formPickerDataSource selectedIndexesFromString:_textField.text];
        [indexes enumerateObjectsUsingBlock:^(NSNumber * indexNumber, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.pickerView selectRow:[indexNumber integerValue] inComponent:idx animated:NO];
        }];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [_formPickerDataSource numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_formPickerDataSource componentOptions:component] count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_formPickerDataSource componentOptions:component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray * selectedIndexes = [NSMutableArray array];
    for (int component = 0; component < _pickerView.numberOfComponents; component++) {
        [selectedIndexes addObject:@([_pickerView selectedRowInComponent:component])];
    }

    if (selectedIndexes.count) {
        NSString * value = [_formPickerDataSource stringFromSelectedIndexes:selectedIndexes];
        if (value.length) {
            _textField.text = @"";
            [_textField insertText:value];
        }
    }
}

@end
