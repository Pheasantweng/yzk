//
//  RecordViewController.m
//  yzk
//
//  Created by zs on 17/11/15.
//  Copyright © 2017年  翁献山. All rights reserved.
//

#import "RecordViewController.h"
#import "ZSNetTool.h"
#import "RecordModel.h"
@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic)NSMutableArray *datamodelArray;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"出库记录";
    [self GETdata];
    // Do any additional setup after loading the view from its nib.
}
-(NSMutableArray*)datamodelArray{
    if (_datamodelArray==nil) {
        _datamodelArray=[[NSMutableArray alloc]init];
    }
    return _datamodelArray;
}
-(void)GETdata{
    NSDictionary *par =@{@"Ason":@"1"};
    [[ZSNetTool sharedInstance]GET:[NSString stringWithFormat:@"http://td.xggserve.com/GetRecord"]
                        parameters:par
                              view:nil
                           success:^(id responseObject)
     {
         [self.datamodelArray removeAllObjects];
         NSArray *array =[RecordModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
         [self.datamodelArray addObjectsFromArray:array];
         [self.tableview reloadData];
     } failure:^(NSError *error) {
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datamodelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (Cell==nil) {
        Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    NSArray *Array =self.datamodelArray;
    RecordModel *Model =[[Array reverseObjectEnumerator] allObjects][indexPath.row];

    Cell.textLabel.text=Model.Markingcode;
    Cell.detailTextLabel.text=[self timeWithTimeIntervalString:Model.datetime];
    return Cell;
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{

    double unixTimeStamp = [timeString doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;

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
