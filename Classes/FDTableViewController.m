//
//  FDTableViewController.m
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import "FDTableViewController.h"
@import ADKeyboardManager;

@interface FDTableViewController () {
    ADKeyboardManager * _keyboardManager;
}

@end

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
    [self.view addSubview:_tableView];

    NSDictionary * views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];

    _keyboardManager = [[ADKeyboardManager alloc] initWithScrollView:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_keyboardManager ad_startObservingKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_keyboardManager ad_stopObservingKeyboard];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
