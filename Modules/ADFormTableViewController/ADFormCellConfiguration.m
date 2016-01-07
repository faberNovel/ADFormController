//
//  ADFormCellConfiguration.m
//  Nexity
//
//  Created by Pierre Felgines on 13/10/2015.
//
//

#import "ADFormCellConfiguration.h"

@implementation ADFormCellConfiguration

@end

@implementation ADFormCellConfiguration (Default)

+ (instancetype)defaultConfiguration {
    ADFormCellConfiguration * configuration = [ADFormCellConfiguration new];
    configuration.textColor = [UIColor blackColor];
    configuration.tintColor = [UIColor blackColor];
    configuration.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    configuration.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    return configuration;
}

@end
