//
//  ADFormInputTableViewCell.h
//  FormDemo
//
//  Created by Pierre Felgines on 02/06/16.
//
//

#import <Foundation/Foundation.h>

@class ADFormCellConfiguration;

@protocol ADFormInputTableViewCell <NSObject>
- (void)applyConfiguration:(ADFormCellConfiguration *)configuration;
@end
