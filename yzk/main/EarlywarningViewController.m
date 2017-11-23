//
//  EarlywarningViewController.m
//  yzk
//
//  Created by zs on 17/11/15.
//  Copyright © 2017年  翁献山. All rights reserved.
//

#import "EarlywarningViewController.h"
#import "Datamodel.h"
#import "ZSNetTool.h"
#import "CommodityInformationVc.h"
@interface EarlywarningViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *datamodelArray;

@end

@implementation EarlywarningViewController
static NSString *const CellIdentifier = @"WEICHAT_ID1";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datamodelArray addObjectsFromArray:self.Array];
    [self.tableview reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSMutableArray *)datamodelArray{
    if (_datamodelArray==nil) {
        _datamodelArray=[[NSMutableArray alloc]init];
    }
    return _datamodelArray;
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datamodelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    Datamodel *Model =self.datamodelArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",Model.Pname,Model.Pstyle,Model.Pcolor,Model.Psize,Model.PNumber];
    return cell;
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
