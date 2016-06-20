//
//  FDMenuTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import "FDMenuTableViewController.h"
#import "FDTestFormTableViewController.h"

static NSString * sCellIdentifier = @"sCellIdentifier";

@implementation FDMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Empty";
        } break;
        case 1: {
            cell.textLabel.text = @"Filled";
        } break;
        case 2: {
            cell.textLabel.text = @"With Title";
        } break;
        case 3: {
            cell.textLabel.text = @"Custom default input accessory";
        } break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FDTestFormTableViewController * mainFormTableViewController = [FDTestFormTableViewController new];
    switch (indexPath.row) {
        case 0: {
            mainFormTableViewController.title = @"Empty";
        } break;
        case 1: {
            mainFormTableViewController.prefilled = YES;
            mainFormTableViewController.title = @"Filled";
        } break;
        case 2: {
            mainFormTableViewController.showTitles = YES;
            mainFormTableViewController.title = @"With Title";
        } break;
        case 3: {
            mainFormTableViewController.customAccessoryView = YES;
        } break;
    }
    [self.navigationController pushViewController:mainFormTableViewController animated:YES];
}

@end
