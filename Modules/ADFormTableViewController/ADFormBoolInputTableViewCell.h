//
//  ADFormBoolInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 02/06/16.
//
//

#import <Foundation/Foundation.h>

@class ADFormCellBoolConfiguration;

@protocol ADFormBoolInputTableViewCellDelegate;

@protocol ADFormBoolInputTableViewCell

@property (nonatomic, weak) id<ADFormBoolInputTableViewCellDelegate> delegate;
@property (nonatomic) BOOL boolContent;

- (void)applyConfiguration:(ADFormCellBoolConfiguration *)configuration;

@end

@protocol ADFormBoolInputTableViewCellDelegate <NSObject>
- (void)boolInputTableViewCellDidChangeValue:(id<ADFormBoolInputTableViewCell>)boolInputTableViewCell;
@end