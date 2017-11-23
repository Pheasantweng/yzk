//
//  Networkrequest.m
//  Acane
//
//  Created by zs on 17/5/8.
//  Copyright © 2017年 wengxianshan. All rights reserved.
//

#import "Networkrequest.h"
#import "ZSNetTool.h"
#import "ZSHTTPManager.h"
#import "NSDictionary+safeGet.h"

@implementation Networkrequest
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

///**
// 1.注册接口
//
// @param Phone 手机号
// @param view 视图
// @param block 回调
// @param Error 错误回调
// */
//-(void)GetCode:(NSString *)Phone
//      AreaCode:(NSString *)AreaCode
//          view:(UIView *)view
//         block:(void (^)(id data))block
//         Error:(void (^)())Error
//{
//    NSDictionary *Par =@{@"action":@"GetCode",@"Phone":Phone,@"AreaCode":AreaCode};
//    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"%@/api/app/Login/Login.ashx",addressUrl]
//                        parameters:Par
//                              view:view
//                           success:^(id responseObject)
//    {
//        
//        
//        
//        if ([[responseObject jh_objectForKey:@"Result"] integerValue] == 0) {
//            [MBProgressHUD showError:[responseObject
//                                      jh_objectForKey:@"Msg"]
//                              toView:view];
//            Error();
//        }else {
//            block([responseObject jh_objectForKey:@"Msg"]);
//        }
//
//    } failure:^(NSError *error) {
//        Error();
//    }];
//}

@end
