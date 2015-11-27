//
//  FDTestFormTableViewController.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "ADTableViewController.h"

@interface FDTestFormTableViewController : ADTableViewController

@property (nonatomic, getter=isPrefilled) BOOL prefilled;
@property (nonatomic) BOOL showTitles;

@end
