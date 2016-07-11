//
//  ADFormCellBoolConfiguration.m
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import "ADFormCellBoolConfiguration.h"
#import <ADFormController/ADFormController-Swift.h>


@implementation ADFormCellBoolConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.switchZoom = 1.f;
    }
    return self;
}

- (UITableViewCell *)visit:(id<FormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath {
    return [configurable boolInputCellWithConfiguration:self atIndexPath:indexPath];
}

@end
