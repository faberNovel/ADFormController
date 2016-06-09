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

@class ADFormDirectionManager;
@protocol ADFormDirectionManagerDelegate <NSObject>
@optional
- (BOOL)formDirectionManager:(ADFormDirectionManager *)formDirectionManager
      canEditCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ADFormDirectionManager : NSObject

@property (nonatomic, weak) id<ADFormDirectionManagerDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (NSIndexPath *)indexPathForDirection:(ADAccessoryViewDirection)direction
                      andBaseIndexPath:(NSIndexPath *)baseIndexPath;
- (BOOL)canMoveToDirection:(ADAccessoryViewDirection)direction
             fromIndexPath:(NSIndexPath *)indexPath;

@end
