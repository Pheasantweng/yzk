//
//  MainViewController.m
//  yzk
//
//  Created by  翁献山 on 2017/11/2.
//  Copyright © 2017年  翁献山. All rights reserved.
//

#import "MainViewController.h"
#import "MMScanViewController.h"
#import "CommodityInformationVc.h"
#import "GoodsqueryViewController.h"
#import "ViewController.h"
#import "RecordViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"库存管理系统";
    // Do any additional setup after loading the view from its nib.
}

/**
 按钮事件

 @param sender 0查询系统 1管理 2 入库 3 出库
 */
- (IBAction)btn:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{
            ViewController *Vc =[[ViewController alloc]init];
            Vc.State=3;
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case 1:{
            ViewController *Vc =[[ViewController alloc]init];
            Vc.State=1;
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case 2:{
            MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
                if (error) {
                    NSLog(@"error: %@",error);
                } else {
                    NSLog(@"扫描结果：%@",result);
                }
            }];
            scanVc.State=0;
            [self.navigationController pushViewController:scanVc animated:YES];
        }
            break;
        case 3:{
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"请选择出库类型" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"单件出货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"error: %@",error);
                                        } else {
                                            NSLog(@"扫描结果：%@",result);
                                        }
                                    }];
                                    scanVc.State=5;
                                    [weakSelf.navigationController pushViewController:scanVc animated:YES];
                                }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"批量出货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"error: %@",error);
                                        } else {
                                            NSLog(@"扫描结果：%@",result);
                                        }
                                    }];
                                    scanVc.State=2;
                                    [weakSelf.navigationController pushViewController:scanVc animated:YES];
                                }] ];
            [alertVC loadViewIfNeeded];
            [self presentViewController:alertVC animated:YES completion:nil];
        } case 4:{
            RecordViewController *Vc =[[RecordViewController alloc]init];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
