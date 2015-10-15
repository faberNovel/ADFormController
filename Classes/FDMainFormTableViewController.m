//
//  FDMainFormTableViewController.m
//  FormDemo
//
//  Created by Pierre Felgines on 21/09/2015.
//
//

#import "FDMainFormTableViewController.h"
#import "ADFormTextFieldTableViewCell.h"
#import "FDCreditCardTextFieldFormatter.h"

typedef NS_ENUM(NSUInteger, FDRowType) {
    FDRowTypeGender,
    FDRowTypeName,
    FDRowTypeEmail,
    FDRowTypePhoneNumber,
    FDRowTypeLongText,
    FDRowTypeDate,
    FDRowTypeCreditCard,
    FDRowTypeCount
};

@interface FDMainFormTableViewController () {
    NSArray * _genders;
}

@end

@implementation FDMainFormTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _genders = @[ @"Male", @"Female" ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(formAction:)];
}

#pragma mark - FDTableViewController

+ (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

#pragma mark - CTFormTableViewController

- (NSInteger)numberOfFormCells {
    return FDRowTypeCount;
}

- (void)applyConfiguration:(ADFormCellConfiguration *)configuration forIndexPath:(NSIndexPath *)indexPath {
    [super applyConfiguration:configuration forIndexPath:indexPath];
    switch (indexPath.row) {
        case FDRowTypeGender: {
            configuration.placeholder = @"Gender";
            configuration.cellType = ADFormTextCellTypePicker;
        } break;
        case FDRowTypeName: {
            configuration.placeholder = @"Name";
            configuration.cellType = ADFormTextCellTypeName;
        } break;
        case FDRowTypeEmail: {
            configuration.placeholder = @"Email";
            configuration.cellType = ADFormTextCellTypeEmail;
        } break;
        case FDRowTypePhoneNumber: {
            configuration.placeholder = @"Phone";
            configuration.cellType = ADFormTextCellTypePhone;
        } break;
        case FDRowTypeLongText: {
            configuration.placeholder = @"Long text";
            configuration.cellType = ADFormTextCellTypeLongText;
        } break;
        case FDRowTypeDate: {
            configuration.placeholder = @"Date";
            configuration.cellType = ADFormTextCellTypeDate;
        } break;
        case FDRowTypeCreditCard: {
            configuration.placeholder = @"Credit card";
            configuration.cellType = ADFormTextCellTypeNumber;
            configuration.textFieldFormatterClass = [FDCreditCardTextFieldFormatter class];
        } break;
        default:
            break;
    }
}

- (void)formAction:(id)sender {
    [super formAction:sender];

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:FDRowTypeGender inSection:0];
    NSString * gender = [self stringValueForIndexPath:indexPath];
    DDLogInfo(@"Gender = %@", gender);
}

- (NSInteger)numberOfComponentsForIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (NSArray *)optionsForComponent:(NSInteger)component indexPath:(NSIndexPath *)indexPath {
    return _genders;
}

- (NSString *)stringFromSelectedIndexes:(NSArray *)indexes indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [[indexes lastObject] integerValue];
    return _genders[index];
}

- (NSArray *)selectedIndexesFromString:(NSString *)string indexPath:(NSIndexPath *)indexPath {
    NSInteger index = [_genders indexOfObject:string];
    return @[ @(index) ];
}

@end
