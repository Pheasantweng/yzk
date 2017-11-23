//
//  ViewController.m
//  yzk
//
//  Created by  翁献山 on 2017/11/2.
//  Copyright © 2017年  翁献山. All rights reserved.
//

#import "ViewController.h"
#import "JKRSearchController.h"
#import "JKRSearchResultViewController.h"
#import "ZSNetTool.h"
#import "NSDictionary+safeGet.h"
#import "Datamodel.h"
#import "MJRefresh.h"
#import "MMScanViewController.h"
#import "CommodityInformationVc.h"
#import "EarlywarningViewController.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, JKRSearchControllerhResultsUpdating, JKRSearchControllerDelegate, JKRSearchBarDelegate>{
    UIButton *RightBtn1;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JKRSearchController *searchController;
@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@property (nonatomic,strong)NSMutableArray *datamodelArray;
@property (nonatomic,strong)NSMutableArray *SearchdatamodelArray;
@property (nonatomic,strong)NSMutableArray *Earlywarningarray;
@end
static NSString *const CellIdentifier = @"WEICHAT_ID";

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [self Getdata];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商品列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    self.jkr_lightStatusBar = YES;
    // 默认的下拉刷新和上拉加载
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self Getdata];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushNav) name:@"PUsh" object:nil];
    [self Right];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)Right{
    RightBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    RightBtn1.frame=CGRectMake(0, 0, 20, 20);
    RightBtn1.backgroundColor=[UIColor redColor];
    [RightBtn1 setTitle:@"" forState:UIControlStateNormal];
    RightBtn1.titleLabel.font=[UIFont systemFontOfSize:12];
    RightBtn1.layer.cornerRadius=10;
    RightBtn1.hidden=YES;
    UIBarButtonItem *Right =[[UIBarButtonItem alloc]initWithCustomView:RightBtn1];
    [RightBtn1 addTarget:self action:@selector(RightBtn1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=Right;
}
-(void)RightBtn1{
    EarlywarningViewController *Vc =[[EarlywarningViewController alloc]init];
    Vc.navigationItem.title=@"低库存预警";
    Vc.State=self.State;
    Vc.Array =self.Earlywarningarray;
    [self.navigationController pushViewController:Vc animated:YES];
    
}
-(void)PushNav{
    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"扫描结果：%@",result);
        }
    }];
    scanVc.State=self.State;
    [self.navigationController pushViewController:scanVc animated:YES];

}
-(NSMutableArray *)datamodelArray{
    if (_datamodelArray==nil) {
        _datamodelArray=[[NSMutableArray alloc]init];
    }
    return _datamodelArray;
}
-(NSMutableArray *)Earlywarningarray{
    if (_Earlywarningarray==nil) {
        _Earlywarningarray=[[NSMutableArray alloc]init];
    }
    return _Earlywarningarray;
}
-(NSMutableArray *)SearchdatamodelArray{
    if (_SearchdatamodelArray==nil) {
        _SearchdatamodelArray=[[NSMutableArray alloc]init];
    }
    return _SearchdatamodelArray;
}
-(void)Getdata{
    __weak typeof(self) weakSelf = self;
    NSDictionary *Par =@{@"Markingcode":@"1"};

    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/getmerchandise"]parameters:Par
                              view:nil
                           success:^(id responseObject)
     {
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.datamodelArray removeAllObjects];
         [weakSelf.Earlywarningarray removeAllObjects];
         NSArray *array =[Datamodel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
         [weakSelf.datamodelArray addObjectsFromArray:array];
         for (Datamodel *Model in weakSelf.datamodelArray) {
             if ([Model.PNumber intValue]<=5) {
                 [weakSelf.Earlywarningarray addObject:Model];
             }
         }
         if (weakSelf.Earlywarningarray.count>0) {
             [RightBtn1 setTitle:[NSString stringWithFormat:@"%ld",weakSelf.Earlywarningarray.count] forState:UIControlStateNormal];
             RightBtn1.hidden=NO;
         }else{
             RightBtn1.hidden=YES;
         }
         [weakSelf.tableView reloadData];
     } failure:^(NSError *error) {
         [weakSelf.tableView.mj_header endRefreshing];
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datamodelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Datamodel *Model =self.datamodelArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",Model.Pname,Model.Pstyle,Model.Pcolor,Model.Psize,Model.PNumber];
    return cell;
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
    
    Datamodel *Model =self.datamodelArray[indexPath.row];
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
    
//    http://localhost:8888/ordersystem/public/changgeProducts
        NSDictionary *Par =@{@"Markingcode":Id};
    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/deleting"]
                        parameters:Par
                              view:nil
                           success:^(id responseObject)
     {
         
         if ([[responseObject objectForKey:@"isok"]intValue]==1) {
             [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
             [weakSelf Getdata];
         }else{
             [MBProgressHUD showError:@"服务器报错" toView:self.view];
         }
     } failure:^(NSError *error) {
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];
}
//侧滑出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Home click index: %zd", indexPath.row);
    Datamodel *Model =self.datamodelArray[indexPath.row];
    if (Model.Markingcode) {
        [self Querydata:Model.Markingcode];
    }
}
-(void)Querydata:(NSString *)Id{
    NSDictionary *Par =@{@"Markingcode":Id};
    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/getinfo"]
                        parameters:Par
                              view:nil
                           success:^(id responseObject)
     {
         Datamodel *array =[Datamodel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
         if (array) {
             CommodityInformationVc *Vc =[[CommodityInformationVc alloc]init];
             Vc.State=self.State;
             Vc.Model=array;
             [self.navigationController pushViewController:Vc animated:YES];
         }else{
             [MBProgressHUD  showError:@"商品不存在" toView:self.view];

         }
         
     } failure:^(NSError *error) {
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];
    
}

#pragma mark - JKRSearchControllerhResultsUpdating
- (void)updateSearchResultsForSearchController:(JKRSearchController *)searchController {
    __weak typeof(self) weakSelf = self;
    [self.SearchdatamodelArray removeAllObjects];
    NSString *searchText = searchController.searchBar.text;
    [self.datamodelArray enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop){
       Datamodel*Model=[self.datamodelArray objectAtIndex:idx];
        if ([Model.Pname containsString:searchText]||[Model.Markingcode containsString:searchText]) {
            [self.SearchdatamodelArray addObject:Model];
        }
    }];
    NSLog(@"%ld",_SearchdatamodelArray.count);
        JKRSearchResultViewController *resultController = (JKRSearchResultViewController *)searchController.searchResultsController;
    resultController.deleting=^(NSString *d){
        [weakSelf Getdata];
    };
    resultController.State=self.State;
        if (!(searchText.length > 0)) resultController.filterDataArray = @[];
        else resultController.filterDataArray = self.SearchdatamodelArray;
}

#pragma mark - JKRSearchControllerDelegate
- (void)willPresentSearchController:(JKRSearchController *)searchController {
    NSLog(@"willPresentSearchController, %@", searchController);
    
    
}

- (void)didPresentSearchController:(JKRSearchController *)searchController {
    NSLog(@"didPresentSearchController, %@", searchController);
    
    
}

- (void)willDismissSearchController:(JKRSearchController *)searchController {
    NSLog(@"willDismissSearchController, %@", searchController);
    
    
}

- (void)didDismissSearchController:(JKRSearchController *)searchController {
    NSLog(@"didDismissSearchController, %@", searchController);
    
    
}

#pragma mark - JKRSearchBarDelegate
- (void)searchBarTextDidBeginEditing:(JKRSearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing %@", searchBar);
    
    
}

- (void)searchBarTextDidEndEditing:(JKRSearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing %@", searchBar);
    
    
}

- (void)searchBar:(JKRSearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchBar:%@ textDidChange:%@", searchBar, searchText);
    
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}

- (JKRSearchController *)searchController {
    if (!_searchController) {
        JKRSearchResultViewController *resultSearchController = [[JKRSearchResultViewController alloc] init];
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:resultSearchController];
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.delegate = self;
    }
    return _searchController;
}

- (void)dealloc {
    NSLog(@"Controller dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PUsh" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
