//
//  ADFormTextViewTableViewCell.h
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormTextInputTableViewCell.h"

@interface ADFormTextViewTableViewCell : UITableViewCell <ADFormTextInputTableViewCell>

@property (nonatomic, readonly, strong) UITextView * textView;

@end
