//
//  ADTextInputAccessoryView.m
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "ADTextInputAccessoryView.h"

@implementation ADTextInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

#pragma mark - Getter

- (UIBarButtonItem *)nextBarButtonItem {
    if (!_nextBarButtonItem) {
        UIImage * image = [[UIImage imageNamed:@"FDNextIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _nextBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                              style:UIBarButtonItemStylePlain
                                                             target:nil
                                                             action:nil];
        _nextBarButtonItem.width = 44.0f;
    }
    return _nextBarButtonItem;
}

- (UIBarButtonItem *)previousBarButtonItem {
    if (!_previousBarButtonItem) {
        UIImage * image = [[UIImage imageNamed:@"FDPreviousIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _previousBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:nil
                                                                 action:nil];
        _previousBarButtonItem.width = 44.0f;
    }
    return _previousBarButtonItem;
}

#pragma mark - Private

- (void)_setup {
    self.tintColor = [UIColor blackColor];
    UIBarButtonItem * flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                            target:nil
                                                                                            action:nil];
    self.items = @[ flexibleBarButtonItem,
                    self.previousBarButtonItem,
                    self.nextBarButtonItem ];
}

@end
