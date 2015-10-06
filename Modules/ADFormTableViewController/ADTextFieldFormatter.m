//
//  CTTextFieldFormatter.m
//  ChicTypes
//
//  Created by Pierre Felgines on 03/03/2015.
//
//

#import "ADTextFieldFormatter.h"

@implementation ADTextFieldFormatter

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        self.textField = textField;
    }
    return self;
}

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    [self editingValueChanged];
}

#pragma mark - Methods

- (void)editingValueChanged {

}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
