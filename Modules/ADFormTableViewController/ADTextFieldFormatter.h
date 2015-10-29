//
//  CTTextFieldFormatter.h
//  ChicTypes
//
//  Created by Pierre Felgines on 03/03/2015.
//
//

#import <Foundation/Foundation.h>

@protocol ADTextFieldFormatter <NSObject>
- (void)textFieldValueChanged:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

