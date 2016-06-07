//
//  ADFormCellConfiguration.m
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import "ADFormCellConfiguration.h"

@implementation ADFormCellConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.tintColor = [UIColor blackColor];
        self.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        self.titleColor = [UIColor blackColor];
    }
    return self;
}

- (UITableViewCell *)visit:(id<ADFormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
