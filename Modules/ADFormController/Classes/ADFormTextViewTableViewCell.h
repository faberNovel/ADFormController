//
//  ADFormTextViewTableViewCell.h
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import <UIKit/UIKit.h>

@protocol FormTextInputTableViewCell, FormTextInputTableViewCellDelegate;

@interface ADFormTextViewTableViewCell : UITableViewCell <FormTextInputTableViewCell>

@property (nonatomic, readonly, strong) UITextView * textView;
@property (nonatomic, weak) id <FormTextInputTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * inputAccessoryView;

@end
