//
//  ADFormCellBoolConfiguration.m
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import "ADFormCellBoolConfiguration.h"

@implementation ADFormCellBoolConfiguration

- (UITableViewCell *)visit:(id<ADFormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath {
    return [configurable boolInputCellWithConfiguration:self atIndexPath:indexPath];
}

@end
