//
//  CTFormTableViewController.h
//  ChicTypes
//
//  Created by Pierre Felgines on 27/04/2015.
//
//

#import "ADTableViewController.h"
#import "ADFormCellConfiguration.h"
#import "ADSimpleFormPickerDataSource.h"

@class ADFormTextFieldTableViewCell;

@interface ADFormTableViewController : ADTableViewController

/*
 * Provides number of cells in the form
 */
- (NSInteger)numberOfFormSections;

/*
 * Provides number of cells in the form
 */
- (NSInteger)numberOfFormCellsInSection:(NSInteger)section;

/*
 * Method use to customize each cell. All setup is done in one place
 */
- (void)applyConfiguration:(ADFormCellConfiguration *)configuration forIndexPath:(NSIndexPath *)indexPath;

/*
 * Action when form is validated
 */
- (void)formAction:(id)sender;

/*
 * Called when value changes for textfield at indexPath (i.e. editing)
 */
- (void)valueChangedForTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;

/*
 * Retrieve text value in textfield at indexPath
 */
- (NSString *)stringValueForIndexPath:(NSIndexPath *)indexPath;

/*
 * Retrieve date value in textfield at indexPath
 */
- (NSDate *)dateValueForIndexPath:(NSIndexPath *)indexPath;

@end
