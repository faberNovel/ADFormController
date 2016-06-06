//
//  ADFormCellConfiguration.h
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import <Foundation/Foundation.h>

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
    ADFormTextCellTypeSwitch
};

@interface ADFormCellConfiguration : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic) ADFormTextCellType cellType;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, strong) UIView * rightView;

@end