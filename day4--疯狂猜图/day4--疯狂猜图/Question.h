//
//  Question.h
//  day4--疯狂猜图
//
//  Created by chen on 15/6/29.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic,strong) NSString *answer;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *options;

-(instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) questionWithDict:(NSDictionary *)dict;
+(NSArray *)questions;
@end
