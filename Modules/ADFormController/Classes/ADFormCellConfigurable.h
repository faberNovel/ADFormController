//
//  ADFormCellConfigurable.h
//  FormDemo
//
//  Created by Pierre Felgines on 07/06/16.
//
//

#import <Foundation/Foundation.h>

@protocol FormBoolInputTableViewCell, FormTextInputTableViewCell;

@class ADFormCellBoolConfiguration, ADFormCellTextConfiguration;

@protocol ADFormCellConfigurable <NSObject>
- (nonnull UITableViewCell<FormBoolInputTableViewCell> *)boolInputCellWithConfiguration:(nonnull ADFormCellBoolConfiguration *)configuration
                                                                      atIndexPath:(nonnull NSIndexPath *)indexPath;

- (nonnull UITableViewCell<FormTextInputTableViewCell> *)textInputCellWithConfiguration:(nonnull ADFormCellTextConfiguration *)configuration
                                                                      atIndexPath:(nonnull NSIndexPath *)indexPath;
@end
