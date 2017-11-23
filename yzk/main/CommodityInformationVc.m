//
//  CommodityInformationVc.m
//  testDemo
//
//  Created by zs on 17/11/3.
//  Copyright © 2017年 wengxianshan. All rights reserved.
//

#import "CommodityInformationVc.h"
#import "ZSNetTool.h"
@interface CommodityInformationVc ()<UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UIButton *Submitdata;
    @property (weak, nonatomic) IBOutlet UILabel *Barcode;
    @property (weak, nonatomic) IBOutlet UITextField *Field1;/*商品名称*/
    @property (weak, nonatomic) IBOutlet UITextField *Field2;/*商品型号*/
    @property (weak, nonatomic) IBOutlet UITextField *Field3;/*商品码数*/
    @property (weak, nonatomic) IBOutlet UITextField *FIeld4;/*商品颜色*/
    @property (weak, nonatomic) IBOutlet UITextField *Field5;/*商品数量*/

@end

@implementation CommodityInformationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商品信息";
    self.Barcode.text=self.Barcodestr;
    if (self.Model) {
        self.Barcode.text=self.Model.Markingcode;
        self.Field1.text=self.Model.Pname;
        self.Field2.text=self.Model.Pstyle;
        self.Field3.text=self.Model.Psize;
        self.FIeld4.text=self.Model.Pcolor;
        self.Field5.text=self.Model.PNumber;
    }
    self.Submitdata.layer.cornerRadius=17.5;
    if (self.State==2) {
//        self.Submitdata.hidden=YES;
        self.Field1.textColor=[UIColor grayColor];
        self.Field2.textColor=[UIColor grayColor];
        self.Field3.textColor=[UIColor grayColor];
        self.FIeld4.textColor=[UIColor grayColor];
        self.Field1.userInteractionEnabled=NO;
        self.Field2.userInteractionEnabled=NO;
        self.Field3.userInteractionEnabled=NO;
        self.FIeld4.userInteractionEnabled=NO;
        [self.Field5 becomeFirstResponder];
    }else if (self.State==3){
        self.Submitdata.hidden=YES;
        self.Field1.textColor=[UIColor grayColor];
        self.Field2.textColor=[UIColor grayColor];
        self.Field3.textColor=[UIColor grayColor];
        self.FIeld4.textColor=[UIColor grayColor];
        self.Field5.textColor=[UIColor grayColor];
        self.Field1.userInteractionEnabled=NO;
        self.Field2.userInteractionEnabled=NO;
        self.Field3.userInteractionEnabled=NO;
        self.FIeld4.userInteractionEnabled=NO;
        self.Field5.userInteractionEnabled=NO;

    }
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.Field1 resignFirstResponder];
    [self.Field2 resignFirstResponder];
    [self.Field3 resignFirstResponder];
    [self.FIeld4 resignFirstResponder];
    [self.Field5 resignFirstResponder];
    return YES;
}// called when 'return' key pressed. return NO to ignore.
/**
 提交数据

 @param sender 按钮事件
 */
- (IBAction)Submitdata:(UIButton *)sender {
    
    switch (self.State) {
        case 0:{
            [self AddData];
        }
        break;
        case 1:{
            [self ChangeData];
        }
        break;
        case 2:{
            [self outbound];
        }
        break;
        default:
        break;
    }
    
    [self.Field5 resignFirstResponder];
    [self.Field1 resignFirstResponder];
    [self.Field2 resignFirstResponder];
    [self.Field3 resignFirstResponder];
    [self.FIeld4 resignFirstResponder];


}
-(void)AddData{
    if (self.Field1.text.length==0) {
        [MBProgressHUD showError:@"请输入型号" toView:self.view];
    }else if (self.Field2.text.length==0){
        [MBProgressHUD showError:@"请输入内里" toView:self.view];
    }else if (self.Field3.text.length==0){
        [MBProgressHUD showError:@"请输入码数" toView:self.view];
    }else if (self.FIeld4.text.length==0){
        [MBProgressHUD showError:@"请输入颜色" toView:self.view];
    }else if (self.Field5.text.length==0){
        [MBProgressHUD showError:@"请输入商品数量" toView:self.view];
    }else{
        NSDictionary *Par =@{@"Markingcode":self.Barcode.text,@"Pname":self.Field1.text,@"Pstyle":self.Field2.text,@"Pcolor":self.FIeld4.text,@"Pdate":[self getNowTimeTimestamp],@"Pstate":@"0",@"PNumber":self.Field5.text,@"Psize":self.Field3.text};
        [[ZSNetTool sharedInstance]GET:@"http://td.xggserve.com/addProducts"
                            parameters:Par
                                  view:nil
                               success:^(id responseObject)
         {
             if ([[responseObject objectForKey:@"isok"]intValue]==1) {
                 [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }else{
                 [MBProgressHUD showError:@"服务器报错" toView:self.view];
             }
         } failure:^(NSError *error) {
             [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
         }];

    }
}
-(void)ChangeData{
    
    if (self.Field1.text.length==0) {
        [MBProgressHUD showError:@"请输入型号" toView:self.view];
    }else if (self.Field2.text.length==0){
        [MBProgressHUD showError:@"请输入内里" toView:self.view];
    }else if (self.Field3.text.length==0){
        [MBProgressHUD showError:@"请输入码数" toView:self.view];
    }else if (self.FIeld4.text.length==0){
        [MBProgressHUD showError:@"请输入颜色" toView:self.view];
    }else if (self.Field5.text.length==0){
        [MBProgressHUD showError:@"请输入商品数量" toView:self.view];
    }else{
        NSDictionary *Par =@{@"Markingcode":self.Barcode.text,@"Pname":self.Field1.text,@"Pstyle":self.Field2.text,@"Pcolor":self.FIeld4.text,@"Pdate":[self getNowTimeTimestamp],@"Pstate":@"0",@"PNumber":self.Field5.text,@"Psize":self.Field3.text};
        [[ZSNetTool sharedInstance]GET:@"http://td.xggserve.com/changgeProducts"
                            parameters:Par
                                  view:nil
                               success:^(id responseObject)
         {
             if ([[responseObject objectForKey:@"isok"]intValue]==1) {
                 [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }else{
                 [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
             }
         } failure:^(NSError *error) {
             [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
         }];
        
    }

}
-(void)outbound{
    
    
    NSDictionary *Par =@{@"Markingcode":self.Barcode.text,@"PNumber":self.Field5.text,};
    [[ZSNetTool sharedInstance]GET:@"http://td.xggserve.com/outbound"
                        parameters:Par
                              view:nil
                           success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"isok"]intValue]==1) {
             [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         }else{
             [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
         }
     } failure:^(NSError *error) {
         [MBProgressHUD  showError:@"服务器连接失败" toView:self.view];
     }];
}

-(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
    
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
