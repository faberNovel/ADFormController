//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormCellConfiguration.h"

@interface ADFormTextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField * textField;

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;

@end
