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

@class ADFormTextFieldTableViewCell;

@protocol CTFormTextFieldTableViewCellDelegate <NSObject>
@optional
- (NSInteger)numberOfComponentsForCell:(ADFormTextFieldTableViewCell *)cell;
- (NSArray *)optionsForComponent:(NSInteger)component cell:(ADFormTextFieldTableViewCell *)cell;
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes cell:(ADFormTextFieldTableViewCell *)cell;
- (NSArray *)selectedIndexesFromString:(NSString *)string cell:(ADFormTextFieldTableViewCell *)cell;
@end

@interface ADFormTextFieldTableViewCell : UITableViewCell

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
