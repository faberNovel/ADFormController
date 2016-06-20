//
//  ADFormCellBoolConfiguration.h
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import <Foundation/Foundation.h>
#import "ADFormCellConfiguration.h"

@interface ADFormCellBoolConfiguration : ADFormCellConfiguration
@property (nonatomic) BOOL boolValue;
@property (nonatomic, strong) UIColor * onTintColor;
@property (nonatomic) CGFloat switchZoom;
@end
