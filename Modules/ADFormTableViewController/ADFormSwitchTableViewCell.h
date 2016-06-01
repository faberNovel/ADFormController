//
//  ADFormSwitchTableViewCell.h
//  FormDemo
//
//  Created by Roland Borgese on 01/06/2016.
//
//

#import <UIKit/UIKit.h>
#import "ADFormTextInputTableViewCell.h"

@interface ADFormSwitchTableViewCell : UITableViewCell <ADFormTextInputTableViewCell>

@property (nonatomic, readonly, strong) UISwitch * switchView;

@end
