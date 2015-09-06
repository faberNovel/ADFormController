//
//  FDTableViewController.m
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import "FDTableViewController.h"

@implementation FDTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStylePlain;
}

- (void)loadView {
    [super loadView];
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self.class tableViewStyle]];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.alwaysBounceVertical = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];

    NSDictionary * views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];

//    _keyboardManager = [[CTKeyboardManager alloc] initWithTableView:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
