//
//  FDMainFormTableViewController.h
//  FormDemo
//
//  Created by Pierre Felgines on 21/09/2015.
//
//

#import "ADFormTableViewController.h"

@interface FDMainFormTableViewController : ADFormTableViewController
@property (nonatomic, getter=isPrefilled) BOOL prefilled;
@property (nonatomic) BOOL showTitles;
@end
