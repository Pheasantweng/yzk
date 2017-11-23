//
//  LTNetTool.m
//  AboutAndShare
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 admin. All rights reserved.
//
//
#import "ZSNetTool.h"
#import "ZSHTTPManager.h"
#import "MBProgressHUD.h"
@implementation ZSNetTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters view:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
//    [MBProgressHUD showMessag:@"" toView:view];
    [[ZSHTTPManager sharedManager] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (success) {
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        [MBProgressHUD showError:@"网络连接失败" toView:view];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters view:(UIView *)view success:(void (^)(id))success failure:(void (^)(NSError *))failure
  {
      NSMutableString * str = [NSMutableString stringWithString:URLString];
      [str appendString:@"?"];
      for (NSString * key in parameters.allKeys) {
          if ([str characterAtIndex:str.length - 1] == '?') {
              [str appendString:[NSString stringWithFormat:@"%@=%@",key, [parameters objectForKey:key]]];
          }else {
              [str appendString:[NSString stringWithFormat:@"&%@=%@",key, [parameters objectForKey:key]]];
          }
      }
      NSLog(@"请求接口:%@",str);
      
      if (view) {
          [MBProgressHUD showMessag:@"" toView:view];
      }
      
      [[ZSHTTPManager sharedManager] GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
      {
          if (view) {
              [MBProgressHUD hideHUDForView:view animated:YES];
          }
          
        
          if (success)
          {
              success(responseObject);
          }

      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
          if (view) {
              [MBProgressHUD hideHUDForView:view animated:YES];
              [MBProgressHUD showError:@"网络连接失败" toView:view];
          }
          
          if (failure)
          {
              failure(error);
          }
    }];
}
- (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


- (void)POSTLoadImageWithURLString:(NSString *)URLString imageDataArr:(NSArray <NSData*> *)imageDataArr name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{

    [[ZSHTTPManager sharedManager]POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageDataArr.count; ++i) {
            
            [formData appendPartWithFileData:imageDataArr[i] name:[NSString stringWithFormat:@"%@%d",name,i] fileName:[NSString stringWithFormat:@"%d%@",i,fileName] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        pregress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}


- (void)POSTLoadImageWithURLString:(NSString *)URLString imageData:(NSData*)imageData name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    
    [[ZSHTTPManager sharedManager]POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        pregress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)POSTLoadVideoWithURLString:(NSString *)URLString videoData:(NSData*)videoData name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    
    [[ZSHTTPManager sharedManager]POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:videoData name:name fileName:fileName mimeType:@"audio/mp3"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        pregress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}






@end
