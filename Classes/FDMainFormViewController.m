//
//  FDMainFormViewController.m
//  FormDemo
//
//  Created by Pierre on 05/09/2015.
//
//

#import "FDMainFormViewController.h"
#import "CTFormTextFieldTableViewCell.h"

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeDate,
    FDRowTypeCount
};

static NSString * sCellIdentifier = @"Identifier";

@interface FDMainFormViewController ()

@end

@implementation FDMainFormViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Profile";

    [self.tableView registerClass:[CTFormTextFieldTableViewCell class] forCellReuseIdentifier:sCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FDRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CTFormTextFieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier forIndexPath:indexPath];

    NSString * placeholder = nil;
    switch (indexPath.row) {
        case FDRowTypeName: {
            placeholder = @"Name";
        } break;
        case FDRowTypeEmail: {
            placeholder = @"Email";
        } break;
        case FDRowTypePhoneNumber: {
            placeholder = @"Phone Number";
        } break;
        case FDRowTypeDate: {
            placeholder = @"Date";
        } break;
        default:
            break;
    }
    cell.textField.placeholder = placeholder;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Profile";
}

#pragma mark - UITableViewDelegate


@end
