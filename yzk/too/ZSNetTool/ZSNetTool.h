//
//  LTNetTool.h
//  AboutAndShare
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ZSNetTool : NSObject

//@property (nonatomic,strong) AFHTTPSessionManager *afHttpManger;

/**
 *  单例
 */
+ (instancetype)sharedInstance;

/**
 *  POST请求方法
 *
 *  @param URLString  网络地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    错误回调
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters view:(UIView *)view success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  GET请求方法
 *
 *  @param URLString  网络地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    错误回调
 */
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters view:(UIView *)view success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  上传多张图片
 *
 *  @param URLString    网址
 *  @param imageDataArr 图片二进制数组
 *  @param name         图片名字
 *  @param fileName     图片保存文件名
 *  @param pregress     进度
 *  @param success      成功回调
 *  @param failure      失败回调
 */
- (void)POSTLoadImageWithURLString:(NSString *)URLString imageDataArr:(NSArray <NSData*> *)imageDataArr name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  上传单张图片
 *
 *  @param URLString 网络地址
 
 
 *  @param imageData 图片二进制
 *  @param name      图片名称
 *  @param fileName  图片保存文件名
 *  @param pregress  上传进度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)POSTLoadImageWithURLString:(NSString *)URLString imageData:(NSData*)imageData name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 上传录音
 
 *  @param URLString 网络地址
 *  @param videoData 录音二进制
 *  @param name      录音名称
 *  @param fileName  录音保存文件名
 *  @param pregress  上传进度
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)POSTLoadVideoWithURLString:(NSString *)URLString videoData:(NSData*)videoData name:(NSString*)name fileName:(NSString*)fileName progress:(void(^)(NSProgress *progress))pregress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
@end
