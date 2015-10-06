//
//  FDTableViewController.h
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import <UIKit/UIKit.h>

@interface ADTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

+ (UITableViewStyle)tableViewStyle; // Default UITableViewStylePlain

@end
