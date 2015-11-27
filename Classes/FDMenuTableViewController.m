//
//  FDMenuTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import "FDMenuTableViewController.h"
#import "FDMainFormTableViewController.h"
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
            cell.textLabel.text = @"Test";
        } break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            FDMainFormTableViewController * mainFormTableViewController = [FDMainFormTableViewController new];
            mainFormTableViewController.title = @"Empty";
            [self.navigationController pushViewController:mainFormTableViewController animated:YES];
        } break;
        case 1: {
            FDMainFormTableViewController * mainFormTableViewController = [FDMainFormTableViewController new];
            mainFormTableViewController.prefilled = YES;
            mainFormTableViewController.title = @"Filled";
            [self.navigationController pushViewController:mainFormTableViewController animated:YES];
        } break;
        case 2: {
            FDMainFormTableViewController * mainFormTableViewController = [FDMainFormTableViewController new];
            mainFormTableViewController.showTitles = YES;
            mainFormTableViewController.title = @"With Title";
            [self.navigationController pushViewController:mainFormTableViewController animated:YES];
        } break;
        case 3: {
            FDTestFormTableViewController * testFormTableViewController = [FDTestFormTableViewController new];
            testFormTableViewController.title = @"Test";
            [self.navigationController pushViewController:testFormTableViewController animated:YES];
        } break;
    }
}

@end
