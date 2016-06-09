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

    NSIndexPath * nextIndexPath = [self _nextIndexPathForDirection:direction fromIndexPath:baseIndexPath];
    return nextIndexPath;
}

- (BOOL)canMoveToDirection:(ADAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * nextIndexPath = [self _nextIndexPathForDirection:direction fromIndexPath:indexPath];
    return nextIndexPath != nil;
}

- (NSIndexPath *)_nextIndexPathForDirection:(ADAccessoryViewDirection)direction fromIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentRow = indexPath.row;
    NSInteger currentSection = indexPath.section;

    NSInteger nextRow = currentRow;
    NSInteger nextSection = currentSection;

    if (direction == ADAccessoryViewDirectionNext) {
        if ([indexPath isEqual:[self _lastIndexPath]]) {
            return nil;
        }

        BOOL isLastRowInSection = currentRow == [_tableView numberOfRowsInSection:currentSection] - 1;
        if (isLastRowInSection) {
            nextSection++;
            nextRow = 0;
        } else {
            nextRow++;
        }
    } else if (direction == ADAccessoryViewDirectionPrevious) {
        if ([indexPath isEqual:[self _firstIndexPath]]) {
            return nil;
        }

        BOOL isFirstRowInSection = currentRow == 0;
        if (isFirstRowInSection) {
            nextSection--;
            nextRow = MAX([_tableView numberOfRowsInSection:nextSection] - 1, 0);
        } else {
            nextRow--;
        }
    }

    NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:nextSection];

    if ([self.delegate respondsToSelector:@selector(formDirectionManager:canEditCellAtIndexPath:)]) {
        BOOL canEditCell = [self.delegate formDirectionManager:self canEditCellAtIndexPath:nextIndexPath];
        if (!canEditCell) {
            // Recursivity
            return [self _nextIndexPathForDirection:direction fromIndexPath:nextIndexPath];
        }
    }

    return nextIndexPath;
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
