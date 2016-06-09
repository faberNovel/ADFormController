//
//  CTCreditCardTextFieldFormatter.m
//  ChicTypes
//
//  Created by Pierre Felgines on 03/03/2015.
//
//

#import "FDCreditCardTextFieldFormatter.h"

// From http://stackoverflow.com/a/19161529

@interface FDCreditCardTextFieldFormatter () {
    NSString * _previousTextFieldContent;
    UITextRange * _previousSelection;
}
- (void)_reformatAsCardNumber:(UITextField *)textField;
- (NSString *)_removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition;
- (NSString *)_insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition;
@end

@implementation FDCreditCardTextFieldFormatter

#pragma mark - ADTextFieldFormatter

- (void)textFieldValueChanged:(UITextField *)textField {
    [self _reformatAsCardNumber:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _previousTextFieldContent = textField.text;
    _previousSelection = textField.selectedTextRange;
    return YES;
}

#pragma mark - Private

- (void)_reformatAsCardNumber:(UITextField *)textField {
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString * cardNumberWithoutSpaces = [self _removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];
    if (cardNumberWithoutSpaces.length > 16) {
        textField.text = _previousTextFieldContent;
        textField.selectedTextRange = _previousSelection;
        return;
    }

    NSString * cardNumberWithSpaces = [self _insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];
    textField.text = cardNumberWithSpaces;
    UITextPosition * targetPosition = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPosition];
    textField.selectedTextRange = [textField textRangeFromPosition:targetPosition toPosition:targetPosition];
}

- (NSString *)_removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString * digitsOnlyString = [NSMutableString new];
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString * stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        } else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

- (NSString *)_insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSMutableString * stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i = 0; i < string.length; i++) {
        if (i > 0 && i % 4 == 0) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString * stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}


@end
