//
//  ADFormTextViewTableViewCell.h
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "ADFormCellConfiguration.h"

@interface ADFormTextViewTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) UITextView * textView;

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;

@end
