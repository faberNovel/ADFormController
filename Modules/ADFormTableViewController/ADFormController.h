//
//  ADFormController.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ADFormCellConfiguration.h"

@class ADFormController;
@protocol ADFormControllerDelegate <NSObject>

- (void)formController:(ADFormController *)formController
    applyConfiguration:(ADFormCellConfiguration *)configuration
          forIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIView *)formController:(ADFormController *)formController inputAccessoryViewForIndexPath:(NSIndexPath *)indexPath;
- (void)formController:(ADFormController *)formController valueChangedForIndexPath:(NSIndexPath *)indexPath;
- (void)formControllerAction:(ADFormController *)formController;

@end

@interface ADFormController : NSObject

@property (nonatomic, weak) id<ADFormControllerDelegate> delegate;

@property (nonatomic, readonly) UIView * defaultInputAccessoryView; // To customize, use delegate method

- (instancetype)initWithTableView:(UITableView *)tableView;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 * Retrieve text value in textfield at indexPath
 */
- (NSString *)stringValueForIndexPath:(NSIndexPath *)indexPath;

/*
 * Retrieve date value in textfield at indexPath
 */
- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath;

@end
