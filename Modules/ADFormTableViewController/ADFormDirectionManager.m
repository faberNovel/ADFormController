//
//  ADFormDirectionManager.m
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import "ADFormDirectionManager.h"

@interface ADFormDirectionManager () {
    __weak UITableView * _tableView;
}

@end

@implementation ADFormDirectionManager

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        _tableView = tableView;
    }
    return self;
}

- (NSIndexPath *)indexPathForDirection:(ADAccessoryViewDirection)direction andBaseIndexPath:(NSIndexPath *)baseIndexPath {
    if (!baseIndexPath) {
        return nil;
    }

    if (![self canMoveToDirection:direction fromIndexPath:baseIndexPath]) {
        return nil;
    }

    NSInteger nextSection = baseIndexPath.section;
    NSInteger nextRow = baseIndexPath.row;

    if (direction == ADAccessoryViewDirectionNext) {
        BOOL isLastRowInSection = baseIndexPath.row == [_tableView numberOfRowsInSection:baseIndexPath.section] - 1;
        nextSection = isLastRowInSection ? baseIndexPath.section + 1 : baseIndexPath.section;
        nextRow = isLastRowInSection ? 0 : baseIndexPath.row + 1;
    } else {
        BOOL isFirstRowInSection = baseIndexPath.row == 0;
        nextSection = isFirstRowInSection ? baseIndexPath.section - 1 : baseIndexPath.section;
        nextRow = isFirstRowInSection ? [_tableView numberOfRowsInSection:nextSection] - 1 : baseIndexPath.row - 1;
    }

    return [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
}

- (BOOL)canMoveToDirection:(ADAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    switch (direction) {
        case ADAccessoryViewDirectionPrevious:
            return ![indexPath isEqual:[self _firstIndexPath]];
        case ADAccessoryViewDirectionNext:
            return ![indexPath isEqual:[self _lastIndexPath]];
    }
    return NO;
}

#pragma mark - Private

- (NSIndexPath *)_firstIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (NSIndexPath *)_lastIndexPath {
    NSInteger lastSection = [_tableView numberOfSections] - 1;
    return [NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:lastSection] - 1
                              inSection:lastSection];
}

@end
