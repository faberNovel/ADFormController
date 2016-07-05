//
//  CTFormTextFieldTableViewCell.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormTextInputTableViewCell.h"

@interface ADFormTextFieldTableViewCell : UITableViewCell <ADFormTextInputTableViewCell>

@property (nonatomic, strong, readonly) UITextField * textField;

@end
