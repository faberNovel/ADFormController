//
//  FDEnglishAccessoryToolbar.m
//  FormDemo
//
//  Created by Roland Borgese on 20/06/2016.
//
//

#import "FDEnglishAccessoryToolbar.h"

@interface FDEnglishAccessoryToolbar ()

@property (nonatomic, strong) UIBarButtonItem * nextBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * previousBarButtonItem;

@end

@implementation FDEnglishAccessoryToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

#pragma mark - NavigableView
- (UIView *)view {
    return self;
}

#pragma mark - Private

- (void)_setup {
    _previousBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
    _nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.tintColor = [UIColor blackColor];
    UIBarButtonItem * flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                            target:nil
                                                                                            action:nil];
    self.items = @[self.previousBarButtonItem,
                    flexibleBarButtonItem,
                    self.nextBarButtonItem ];
}

@end
