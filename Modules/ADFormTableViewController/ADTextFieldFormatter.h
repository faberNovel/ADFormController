//
//  CTTextFieldFormatter.h
//  ChicTypes
//
//  Created by Pierre Felgines on 03/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface ADTextFieldFormatter : NSObject

@property (nonatomic, weak) UITextField * textField;

- (instancetype)initWithTextField:(UITextField *)textField;
- (void)editingValueChanged;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
