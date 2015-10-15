//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormCellConfiguration.h"

@class ADFormTextFieldTableViewCell;

@protocol CTFormTextFieldTableViewCellDelegate <NSObject>
@optional
- (NSInteger)numberOfComponentsForCell:(ADFormTextFieldTableViewCell *)cell;
- (NSArray *)optionsForComponent:(NSInteger)component cell:(ADFormTextFieldTableViewCell *)cell;
- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes cell:(ADFormTextFieldTableViewCell *)cell;
- (NSArray *)selectedIndexesFromString:(NSString *)string cell:(ADFormTextFieldTableViewCell *)cell;
@end

@interface ADFormTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, weak) id<CTFormTextFieldTableViewCellDelegate> delegate;

- (void)startEditing;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;

@end
