//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>

@protocol FormTextInputTableViewCell, FormTextInputTableViewCellDelegate;

@interface ADFormTextFieldTableViewCell : UITableViewCell <FormTextInputTableViewCell>

@property (nonatomic, strong, readonly) UITextField * textField;
@property (nonatomic, weak) id<FormTextInputTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * inputAccessoryView;

@end
