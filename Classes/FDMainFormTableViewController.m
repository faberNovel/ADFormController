//
//  FDMainFormTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 21/09/2015.
//
//

#import "FDMainFormTableViewController.h"
#import "ADFormTextFieldTableViewCell.h"

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeDate,
    FDRowTypeCount
};

@implementation FDMainFormTableViewController

#pragma mark - FDTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

#pragma mark - CTFormTableViewController

- (NSInteger)numberOfFormCells {
    return FDRowTypeCount;
}

- (void)configureCell:(ADFormTextFieldTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];

    switch (indexPath.row) {
        case FDRowTypeName: {
            cell.textField.placeholder = @"Name";
            cell.cellType = CTFormTextCellTypeName;
        } break;
        case FDRowTypeEmail: {
            cell.textField.placeholder = @"Email";
            cell.cellType = CTFormTextCellTypeEmail;
        } break;
        case FDRowTypePhoneNumber: {
            cell.textField.placeholder = @"Phone";
            cell.cellType = CTFormTextCellTypePhone;
        } break;
        case FDRowTypeDate: {
            cell.textField.placeholder = @"Date";
            cell.cellType = CTFormTextCellTypeDate;
        } break;
        default:
            break;
    }
}

- (void)formAction:(id)sender {
    NSLog(@"FORM ACTION");
}

@end
