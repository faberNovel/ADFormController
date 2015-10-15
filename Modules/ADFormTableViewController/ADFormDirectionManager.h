//
//  ADFormDirectionManager.h
//  FormDemo
//
//  Created by Pierre Felgines on 15/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ADAccessoryViewDirection) {
    ADAccessoryViewDirectionPrevious,
    ADAccessoryViewDirectionNext
};

@interface ADFormDirectionManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

- (NSIndexPath *)indexPathForDirection:(ADAccessoryViewDirection)direction
                      andBaseIndexPath:(NSIndexPath *)baseIndexPath;
- (BOOL)canMoveToDirection:(ADAccessoryViewDirection)direction
             fromIndexPath:(NSIndexPath *)indexPath;

@end
