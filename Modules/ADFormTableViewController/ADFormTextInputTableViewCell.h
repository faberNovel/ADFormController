//
//  ADFormTextInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import <Foundation/Foundation.h>
#import "ADFormInputTableViewCell.h"

@protocol ADFormTextInputTableViewCellDelegate;

@protocol ADFormTextInputTableViewCell <ADFormInputTableViewCell>

@property (nonatomic, weak) id<ADFormTextInputTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * inputAccessoryView;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) NSString * textContent;

- (void)beginEditing;

@end

@protocol ADFormTextInputTableViewCellDelegate <NSObject>
- (void)textInputTableViewCellDidBeginEditing:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (BOOL)textInputTableViewCellShouldReturn:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
- (void)textInputTableViewCellValueChanged:(id<ADFormTextInputTableViewCell>)textInputTableViewCell;
@end