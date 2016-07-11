//
//  FDFormModel.h
//  FormDemo
//
//  Created by Pierre Felgines on 03/06/16.
//
//

#import <Foundation/Foundation.h>

@interface FDFormModel : NSObject
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSDate * birthDate;
@property (nonatomic) BOOL married;
@property (nonatomic, strong) NSString * creditCard;
@property (nonatomic, strong) NSString * expiration;
@end
