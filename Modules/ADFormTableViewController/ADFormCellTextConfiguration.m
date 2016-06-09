//
//  ADFormCellTextConfiguration.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADFormCellTextConfiguration.h"

@implementation ADFormCellTextConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.textColor = [UIColor blackColor];
        self.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    }
    return self;
}

- (UITableViewCell *)visit:(id<ADFormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath {
    return [configurable textInputCellWithConfiguration:self atIndexPath:indexPath];
}

@end
