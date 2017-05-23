//
//  NSObject+Ustb.m
//  RunTime
//
//  Created by rong360 on 17/5/15.
//  Copyright © 2017年 ustb. All rights reserved.
//

#import "NSObject+Ustb.h"
#import "objc/runtime.h"
@implementation NSObject (Ustb)

+ (id)objectWithDictionary:(NSDictionary *)dict
{
    return [[[[self class] alloc] init] objectWithDictionary:dict];
}

+ (NSArray *)modelArrayWithDictionaryArray:(NSArray *)dictArray
{
    if (dictArray == nil) {
        return nil;
    }
    __block BOOL isStop = NO;
    [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSDictionary class]]) {
            *stop = YES;
            isStop = YES;
        }
    }];
    if (isStop) {
        return nil;
    }
    
    NSMutableArray *dict = [NSMutableArray array];
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class modelClass = [self class];
        id modelObject = [[modelClass alloc] init];
        [modelObject objectWithDictionary:obj];
        [dict addObject:modelObject];
    }];
    return [dict copy];
}

- (NSDictionary *)modelClassInArray
{
    return nil;
}
- (id)objectWithDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    unsigned int outCount;
    objc_property_t  *propertys= class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        id value = nil;
        value = [dict valueForKey:[NSString stringWithUTF8String:property_getName(propertys[i])]];
        if (!value) {
            continue;
        }
        NSArray *tmpStrArray = [[NSString stringWithUTF8String:property_getAttributes(propertys[i])] componentsSeparatedByString:@","];
        NSString *fristStr = nil;
        if (tmpStrArray && tmpStrArray.count) {
            fristStr = [tmpStrArray firstObject];
        }
        if (fristStr) {
            NSString *classStr = nil;
            if ([fristStr rangeOfString:@"@\""].location != NSNotFound) {
                classStr = [fristStr substringWithRange:NSMakeRange(3,fristStr.length-4)];
            }
            if ([classStr rangeOfString:@"NS"].location != NSNotFound) {
                if ([classStr isEqualToString:@"NSArray"] || [classStr isEqualToString:@"NSMutableArray"]) {
                    if ([[self modelClassInArray] valueForKey:[NSString stringWithUTF8String:property_getName(propertys[i])]]) {
                        id classModel = [[self modelClassInArray] valueForKey:[NSString stringWithUTF8String:property_getName(propertys[i])]];
                        if ([classModel isKindOfClass:[NSString class]]) {
                            classModel = NSClassFromString(classModel);
                        }
                        value = [classModel modelArrayWithDictionaryArray:value];
                    }
                }
            } else if (classStr) {
                Class modelClass = NSClassFromString(classStr);
                id modelObject = [[modelClass alloc] init];
                value = [modelObject objectWithDictionary:value];
            }
        }
        NSLog(@"%s,  %s",property_getName(propertys[i]),property_getAttributes(propertys[i]));
        [self setValue:value forKey:[NSString stringWithUTF8String:property_getName(propertys[i])]];
    }
    free(propertys);
    return self;
}

@end
