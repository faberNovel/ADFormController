//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CTFormTextCellType) {
    CTFormTextCellTypeEmail,
    CTFormTextCellTypePassword,
    CTFormTextCellTypeName,
    CTFormTextCellTypePhone,
    CTFormTextCellTypeText,
    CTFormTextCellTypeNumber,
    CTFormTextCellTypeDate,
    CTFormTextCellTypePicker
};

@class CTFormTextFieldTableViewCell;

@protocol CTFormTextFieldTableViewCellDelegate <NSObject>
@optional
- (NSInteger)numberOfComponentsForCell:(CTFormTextFieldTableViewCell *)cell;
- (NSArray *)optionsForComponent:(NSInteger)component cell:(CTFormTextFieldTableViewCell *)cell;
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes cell:(CTFormTextFieldTableViewCell *)cell;
- (NSArray *)selectedIndexesFromString:(NSString *)string cell:(CTFormTextFieldTableViewCell *)cell;
@end

@interface CTFormTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic) CTFormTextCellType cellType;
@property (nonatomic, strong) UIView * rightView;

@property (nonatomic, weak) id<CTFormTextFieldTableViewCellDelegate> delegate;
@property (nonatomic) Class textFieldFormatterClass;

+ (NSDateFormatter *)dateFormatter;

- (void)startEditing;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
