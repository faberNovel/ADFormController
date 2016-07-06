//
//  ADFormCellTextConfiguration.h
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "ADFormCellConfiguration.h"

@protocol TextFieldFormatter;

typedef NS_ENUM(NSUInteger, ADFormTextCellType) {
    ADFormTextCellTypeEmail,
    ADFormTextCellTypePassword,
    ADFormTextCellTypeName,
    ADFormTextCellTypePhone,
    ADFormTextCellTypeText,
    ADFormTextCellTypeNumber,
    ADFormTextCellTypeDate,
    ADFormTextCellTypePicker,
    ADFormTextCellTypeLongText,
    ADFormTextCellTypePasswordNumber,
};

@protocol FormPickerDataSource;

@interface ADFormCellTextConfiguration : ADFormCellConfiguration
@property (nonatomic) ADFormTextCellType cellType;
@property (nonatomic, strong, nonnull) NSString * text;
@property (nonatomic, strong, nullable) UIFont * textFont;
@property (nonatomic, strong, nonnull) UIColor * textColor;
@property (nonatomic, strong, nonnull) NSString * placeholder;
@property (nonatomic, strong, nullable) id<TextFieldFormatter> textFieldFormatter;
@property (nonatomic, strong, nullable) NSDateFormatter * dateFormatter;
@property (nonatomic, strong, nullable) id<FormPickerDataSource> formPickerDataSource;
@end
