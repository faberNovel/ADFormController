//
//  ADFormCellConfiguration.h
//  FormDemo
//
//  Created by Pierre Felgines on 06/06/16.
//
//

#import <Foundation/Foundation.h>

@protocol FormCellConfigurable;

@interface ADFormCellConfiguration : NSObject

@property (nonatomic, strong, nonnull) NSString * title;
@property (nonatomic, strong, nullable) UIFont * titleFont;
@property (nonatomic, strong, nonnull) UIColor * titleColor;
@property (nonatomic, strong, nullable) UIColor * tintColor;
@property (nonatomic, strong, nullable) UIView * rightView;

- (nonnull UITableViewCell *)visit:(nonnull id<FormCellConfigurable>)configurable atIndexPath:(nonnull NSIndexPath *)indexPath;

@end