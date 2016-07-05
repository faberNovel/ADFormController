//
//  ADFormCellConfigurable.h
//  FormDemo
//
//  Created by Pierre Felgines on 07/06/16.
//
//

#import <Foundation/Foundation.h>
#import "ADFormBoolInputTableViewCell.h"
#import "ADFormTextInputTableViewCell.h"

@class ADFormCellBoolConfiguration, ADFormCellTextConfiguration;

@protocol ADFormCellConfigurable <NSObject>
- (nonnull UITableViewCell<ADFormBoolInputTableViewCell> *)boolInputCellWithConfiguration:(nonnull ADFormCellBoolConfiguration *)configuration
                                                                      atIndexPath:(nonnull NSIndexPath *)indexPath;

- (nonnull UITableViewCell<ADFormTextInputTableViewCell> *)textInputCellWithConfiguration:(nonnull ADFormCellTextConfiguration *)configuration
                                                                      atIndexPath:(nonnull NSIndexPath *)indexPath;
@end
