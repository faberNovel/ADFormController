//
//  FDKeyboardManager.h
//  FormDemo
//
//  Created by Pierre on 06/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface FDKeyboardManager : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)startObservingKeyboard;
- (void)endObservingKeyboard;

@end
