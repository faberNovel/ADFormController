//
//  ADFormCellConfiguration.h
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "ADFormPickerDataSource.h"

typedef NS_ENUM(NSUInteger, ADFormTextCellType) {
    ADFormTextCellTypeEmail,
    ADFormTextCellTypePassword,
    ADFormTextCellTypeName,
    ADFormTextCellTypePhone,
    ADFormTextCellTypeText,
    ADFormTextCellTypeNumber,
    ADFormTextCellTypeDate,
    ADFormTextCellTypePicker,
    ADFormTextCellTypeLongText
};

@interface ADFormCellConfiguration : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic) ADFormTextCellType cellType;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIFont * textFont;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic) Class textFieldFormatterClass;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) id<ADFormPickerDataSource> formPickerDataSource;

@end
