//
//  ADFormCellTextConfiguration.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADFormCellTextConfiguration.h"
#import <ADFormController/ADFormController-Swift.h>

@implementation ADFormCellTextConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.tintColor = [UIColor blackColor];
        self.textColor = [UIColor blackColor];
        self.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    }
    return self;
}

- (UITableViewCell *)visit:(id<FormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath {
    return [configurable textInputCellWithConfiguration:self atIndexPath:indexPath];
}

@end
