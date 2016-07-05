//
//  CTTextFieldFormatter.h
//  ChicTypes
//
//  Created by Pierre Felgines on 03/03/2015.
//
//

#import <Foundation/Foundation.h>

@protocol ADTextFieldFormatter <NSObject>
- (void)textFieldValueChanged:(nonnull UITextField *)textField;
- (BOOL)textField:(nonnull UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string;
@end

