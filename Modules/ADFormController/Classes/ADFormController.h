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
@protocol NavigableButtons;

@protocol ADFormControllerDelegate <NSObject>

- (nullable ADFormCellConfiguration *)configurationForFormController:(nonnull ADFormController *)formController
                                                atIndexPath:(nonnull NSIndexPath *)indexPath;

@optional
- (nonnull UIView *)formController:(nonnull ADFormController *)formController inputAccessoryViewForIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)formController:(nonnull ADFormController *)formController valueChangedForIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)formControllerAction:(nonnull ADFormController *)formController;

@end

@interface ADFormController : NSObject

@property (nonatomic, weak, nullable) id<ADFormControllerDelegate> delegate;

@property (nonatomic, strong, nonnull) UIView<NavigableButtons> * defaultInputAccessoryView; //Not called if -formController: inputAccessoryViewForIndexPath: is implemented in delegate

- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView;

- (nonnull UITableViewCell *)cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/*
 * Retrieve text value in textfield at indexPath
 */
- (nonnull NSString *)stringValueForIndexPath:(nonnull NSIndexPath *)indexPath;

/*
 * Retrieve bool value in switch at indexPath
 */
- (BOOL)boolValueForIndexPath:(nonnull NSIndexPath *)indexPath;

/*
 * Retrieve date value in textfield at indexPath
 */
- (nullable NSDate *)dateValueForIndexPath:(nonnull NSIndexPath *)indexPath;

@end
