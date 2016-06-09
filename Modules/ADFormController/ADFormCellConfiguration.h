//
//  ADFormCellConfiguration.h
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import <Foundation/Foundation.h>
#import "ADFormCellConfigurable.h"

@interface ADFormCellConfiguration : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, strong) UIView * rightView;

- (UITableViewCell *)visit:(id<ADFormCellConfigurable>)configurable atIndexPath:(NSIndexPath *)indexPath;

@end