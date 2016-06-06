//
//  ADFormCellConfiguration.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADFormCellConfiguration.h"

@implementation ADFormCellConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.textColor = [UIColor blackColor];
        self.tintColor = [UIColor blackColor];
        self.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        self.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    }
    return self;
}

@end
