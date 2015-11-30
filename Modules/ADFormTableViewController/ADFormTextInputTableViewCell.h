//
//  ADFormTextInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import <Foundation/Foundation.h>

@class ADFormCellConfiguration;
@protocol ADFormTextInputTableViewCellDelegate;

@protocol ADFormTextInputTableViewCell <NSObject>

@property (nonatomic, weak) id<ADFormTextInputTableViewCellDelegate> delegate;

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;
- (void)beginEditing;
- (NSString *)textContent;
@end

@protocol ADFormTextInputTableViewCellDelegate <NSObject>
- (void)textInputTableViewCellDidBeginEditing:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (BOOL)textInputTableViewCellShouldReturn:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (void)textInputTableViewCellValueChanged:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
@end