//
//  NSDictionary+safeGet.m
//  Pet
//
//  Created by zhuoshang on 2017/3/28.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "NSDictionary+safeGet.h"

@implementation NSDictionary (safeGet)

- (id)jh_objectForKey:(id)aKey {

    if ([[self allKeys] containsObject:aKey]) {
            return [self objectForKey:aKey];
        }else{
            return nil;
        }
}

@end
