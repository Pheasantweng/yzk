//
//  GoodsqueryViewController.m
//  yzk
//
//  Created by  翁献山 on 2017/11/5.
//  Copyright © 2017年  翁献山. All rights reserved.
//

#import "GoodsqueryViewController.h"
#import "JKRSearchController.h"
#import "JKRSearchResultViewController.h"
#import "ZSNetTool.h"
#import "NSDictionary+safeGet.h"
#import "Datamodel.h"
@interface GoodsqueryViewController ()<UITableViewDataSource, UITableViewDelegate, JKRSearchControllerhResultsUpdating, JKRSearchControllerDelegate, JKRSearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JKRSearchController *searchController;
@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@property (nonatomic,strong)NSMutableArray *datamodelArray;
@property (nonatomic,strong)NSMutableArray *SearchdatamodelArray;

@end

@implementation GoodsqueryViewController
static NSString *const CellIdentifier = @"WEICHAT_ID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    self.jkr_lightStatusBar = YES;
    [self Getdata];

    
    // Do any additional setup after loading the view.
}
-(NSMutableArray *)datamodelArray{
    if (_datamodelArray==nil) {
        _datamodelArray=[[NSMutableArray alloc]init];
    }
    return _datamodelArray;
}
-(NSMutableArray *)SearchdatamodelArray{
    if (_SearchdatamodelArray==nil) {
        _SearchdatamodelArray=[[NSMutableArray alloc]init];
    }
    return _SearchdatamodelArray;
}
-(void)Getdata{
    NSDictionary *Par =@{@"Markingcode":@"1"};
        [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/getmerchandise"]
                            parameters:Par
                                  view:nil
                               success:^(id responseObject)
        {
            [_datamodelArray removeAllObjects];
            NSArray *array =[Datamodel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [_datamodelArray addObjectsFromArray:array];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Home click index: %zd", indexPath.row);
}

#pragma mark - JKRSearchControllerhResultsUpdating
- (void)updateSearchResultsForSearchController:(JKRSearchController *)searchController {
    
    
    [_SearchdatamodelArray removeAllObjects];
    NSString *searchText = searchController.searchBar.text;
        for (Datamodel*Model in self.datamodelArray) {
        if ([Model.Pname containsString:searchText]) {
            [_SearchdatamodelArray addObject:Model];
        }
    }
    if (_SearchdatamodelArray.count>0) {
        [self.datamodelArray removeAllObjects];
        self.datamodelArray=_SearchdatamodelArray;
    }
    [self.tableView reloadData];
    
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
