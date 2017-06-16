//
//  NSObject+Ustb.h
//  RunTime
//
//  Created by rong360 on 17/5/15.
//  Copyright © 2017年 ustb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KeyValue)

+ (id)objectWithDictionary:(NSDictionary *)dict;
+ (NSArray *)modelArrayWithDictionaryArray:(NSArray *)dictArray;

- (NSDictionary *)modelClassInArray;
- (id)objectWithDictionary:(NSDictionary *)dict;

@end
