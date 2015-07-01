//
//  Question.m
//  day4--疯狂猜图
//
//  Created by chen on 15/6/29.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "Question.h"

@implementation Question
-(instancetype)initWithDict:(NSDictionary *)dict{

    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
//获取当前数组元素
+(NSArray *)questions{
    NSArray *array=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *mutArray=[NSMutableArray array];
    for (NSDictionary *dict in array) {
        [mutArray addObject:[self questionWithDict:dict]];
    }
    return mutArray;
}
//对象描述方法，类似于java中的tostring方法，便于跟踪调试
-(NSString *)description{
    //推荐的格式：如果是自定义的模型，最好是编写description方法，可以方便调试
    return [NSString stringWithFormat:@"<%@:%p>{answer:%@,icon:%@,title:%@,options:%@}",self.class,self,self.answer,self.icon,self.title,self.options];
}
-(void)setOptions:(NSArray *)options{
    _options=[options sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int seed=arc4random_uniform(2);
        if (seed) {
            return [obj1 compare:obj2];
        }else{
            return [obj2 compare:obj1];
        }
    }];
}

@end
