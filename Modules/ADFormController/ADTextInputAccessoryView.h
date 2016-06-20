//
//  ADTextInputAccessoryView.h
//  FormDemo
//
//  Created by Pierre Felgines on 27/11/15.
//
//

#import "ADNavigableButtons.h"

@interface ADTextInputAccessoryView : UIToolbar<ADNavigableButtons>

@property (nonatomic, strong) UIBarButtonItem * nextBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem * previousBarButtonItem;

@end
