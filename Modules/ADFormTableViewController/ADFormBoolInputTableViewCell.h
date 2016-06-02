//
//  ADFormBoolInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 02/06/16.
//
//

#import <Foundation/Foundation.h>
#import "ADFormInputTableViewCell.h"

@protocol ADFormBoolInputTableViewCellDelegate;

@protocol ADFormBoolInputTableViewCell <ADFormInputTableViewCell>

@property (nonatomic, weak) id<ADFormBoolInputTableViewCellDelegate> delegate;
@property (nonatomic) BOOL boolContent;

@end

@protocol ADFormBoolInputTableViewCellDelegate <NSObject>
- (void)boolInputTableViewCellDidChangeValue:(id<ADFormBoolInputTableViewCell>)boolInputTableViewCell;
@end