//
//  ADFormSwitchTableViewCell.h
//  FormDemo
//
//  Created by Roland Borgese on 01/06/2016.
//
//

#import <UIKit/UIKit.h>

@protocol FormBoolInputTableViewCell, FormBoolInputTableViewCellDelegate;

@interface ADFormSwitchTableViewCell : UITableViewCell <FormBoolInputTableViewCell>
@property (nonatomic, weak) id <FormBoolInputTableViewCellDelegate> delegate;
@end
