//
//  JKRSearchResultViewController.m
//  JKRSearchBar
//
//  Created by tronsis_ios on 17/3/31.
//  Copyright © 2017年 tronsis_ios. All rights reserved.
//

#import "JKRSearchResultViewController.h"
#import "Datamodel.h"
#import "CommodityInformationVc.h"
#import "ZSNetTool.h"
@interface JKRSearchResultViewController ()

@end

@implementation JKRSearchResultViewController

static NSString *const cellID = @"RESULT_CELL_ID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)setFilterDataArray:(NSMutableArray *)filterDataArray {
    _filterDataArray = filterDataArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    Datamodel *Model =self.filterDataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",Model.Pname,Model.Pstyle,Model.Pcolor,Model.Psize,Model.PNumber];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ResultTableView click index: %zd", indexPath.row);
    Datamodel *Model =self.filterDataArray[indexPath.row];
    CommodityInformationVc *Vc =[[CommodityInformationVc alloc]init];
    Vc.State=self.State;
    Vc.Model=Model;
    [self.navigationController pushViewController:Vc animated:YES];

//
}
//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.State==1) {
        return YES;
    }else{
        return NO;
    }
}
//执行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Datamodel *Model =self.filterDataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"删除后的数据永久不能恢复" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                        {
                            [weakSelf deleting:Model.Markingcode];
                        }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                        {
                            
                        }]];
    [alertVC loadViewIfNeeded];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}
-(void)deleting:(NSString*)Id{
    __weak typeof(self) weakSelf = self;
    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/deleting?Markingcode=%@",Id]
                        parameters:nil
                              view:nil
                           success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"isok"]intValue]==1) {
             [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
             
             for (Datamodel *Model in self.filterDataArray) {
                 if ([Model.Markingcode integerValue]==[Id integerValue]) {
                     [self.filterDataArray removeObject:Model];
                 }
             }
             [weakSelf.tableView reloadData];
             if (weakSelf.deleting) {
                 weakSelf.deleting(@"1");
             }
         }else{
             [MBProgressHUD showError:@"服务器报错" toView:self.view];
         }
     } failure:^(NSError *error) {
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];
}


- (void)dealloc {
    NSLog(@"JKRSearchResultViewController dealloc");
}

@end
