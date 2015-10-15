//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormCellConfiguration.h"

@interface ADFormTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField * textField;

- (void)startEditing;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;

@end
