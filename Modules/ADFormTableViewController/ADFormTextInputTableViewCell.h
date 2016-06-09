//
//  ADFormTextInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import <Foundation/Foundation.h>

@class ADFormCellTextConfiguration;

@protocol ADFormTextInputTableViewCellDelegate;

@protocol ADFormTextInputTableViewCell

@property (nonatomic, weak) id<ADFormTextInputTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * inputAccessoryView;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) NSString * textContent;

- (void)beginEditing;

- (void)applyConfiguration:(ADFormCellTextConfiguration *)configuration;

@end

@protocol ADFormTextInputTableViewCellDelegate <NSObject>
- (void)textInputTableViewCellDidBeginEditing:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (BOOL)textInputTableViewCellShouldReturn:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (void)textInputTableViewCellValueChanged:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
@end