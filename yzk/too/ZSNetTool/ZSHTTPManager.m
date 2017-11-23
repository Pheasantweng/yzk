//
//  LTHTTPManager.m
//  AboutAndShare
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ZSHTTPManager.h"
//#define LTBaseURL [NSURL URLWithString:@"http://iosapi.itcast.cn/"]

@implementation ZSHTTPManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ZSHTTPManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",nil];
        instance.requestSerializer =[AFJSONRequestSerializer serializer];
        
    });
    return instance;
}

@end
