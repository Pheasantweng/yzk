//
//  CommodityInformationVc.h
//  testDemo
//
//  Created by zs on 17/11/3.
//  Copyright © 2017年 wengxianshan. All rights reserved.
//

#import "BaseViewController.h"
#import "Datamodel.h"
@interface CommodityInformationVc : BaseViewController
@property (assign,nonatomic) NSInteger State;/*0添加数据，1修改数据，2出库 3.查看数据*/
@property (strong,nonatomic)NSString *Barcodestr;
@property (strong,nonatomic)Datamodel *Model;
@property (copy,nonatomic) void(^Rdata)(NSString*r);

@end
