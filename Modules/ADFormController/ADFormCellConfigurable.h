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
- (UITableViewCell<ADFormBoolInputTableViewCell> *)boolInputCellWithConfiguration:(ADFormCellBoolConfiguration *)configuration
                                                                      atIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell<ADFormTextInputTableViewCell> *)textInputCellWithConfiguration:(ADFormCellTextConfiguration *)configuration
                                                                      atIndexPath:(NSIndexPath *)indexPath;
@end
