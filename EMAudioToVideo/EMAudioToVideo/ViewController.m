//
//  ViewController.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/26.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "ViewController.h"
#import "ASCRootClassEntity.h"
#import "EMBaseNavigationController.h"
#import "DetailViewController.h"
#import "EMPlayResponse.h"
#import "EMDownloaderoperation.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *stockInput;
@property (nonatomic, strong) UITextField *securityKeyInput;
@property (nonatomic, strong) UIButton *testBtn;
@property (nonatomic, strong) NSDictionary *jsonData;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *chechCacheBtn;
@property (nonatomic, strong) UITableView *cachetable;
@property (nonatomic, strong) NSMutableArray *localArraylist;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    self.stockInput = [[UITextField alloc] initWithFrame:CGRectMake(40, 100, self.view.frame.size.width - 80, 40)];
    self.stockInput.placeholder = @"股票代码";
    self.stockInput.text = @"600546";
    self.stockInput.backgroundColor = [UIColor whiteColor];
    self.stockInput.textAlignment = NSTextAlignmentCenter;
    self.stockInput.keyboardType = UIKeyboardTypeNumberPad;
    self.stockInput.layer.borderWidth  = 0.5;
    [self.view addSubview:self.stockInput];

    self.securityKeyInput  =[[UITextField alloc] initWithFrame:CGRectMake(40, 155, self.view.frame.size.width - 80, 40)];
    self.securityKeyInput.placeholder = @"秘钥";
    self.securityKeyInput.text = @"key2";
    self.stockInput.keyboardType = UIKeyboardTypeASCIICapable;
    self.securityKeyInput.backgroundColor = [UIColor whiteColor];
    self.securityKeyInput.textAlignment = NSTextAlignmentCenter;
    self.securityKeyInput.layer.borderWidth  = 0.5;
    [self.view addSubview:self.securityKeyInput];
    self.securityKeyInput.textAlignment = NSTextAlignmentCenter;

    self.testBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 220, self.view.frame.size.width - 120, 40)];
    [self.testBtn setTitle:@"测试" forState:UIControlStateNormal];
    self.testBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.testBtn];
    [self.testBtn addTarget:self action:@selector(testevemt:) forControlEvents:UIControlEventTouchUpInside];

    self.clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 270, self.view.frame.size.width - 120, 40)];
    [self.clearBtn setTitle:@"清理下载缓存" forState:UIControlStateNormal];
    self.clearBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.clearBtn];
    [self.clearBtn addTarget:self action:@selector(clearCacheEvent:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.

    self.chechCacheBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 320, self.view.frame.size.width - 120, 40)];
    [self.chechCacheBtn setTitle:@"检测缓存" forState:UIControlStateNormal];
    self.chechCacheBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.chechCacheBtn];
    [self.chechCacheBtn addTarget:self action:@selector(checkCacheEvent:) forControlEvents:UIControlEventTouchUpInside];

    self.cachetable = [[UITableView alloc] initWithFrame:CGRectMake(0, 370, self.view.frame.size.width, self.view.frame.size.height - 370) style:UITableViewStylePlain];
    [self.view addSubview:self.cachetable];
    self.cachetable.delegate = self;
    self.cachetable.dataSource = self;
    self.localArraylist  = [NSMutableArray array];
    [self getCacheFiles];
    [self.cachetable reloadData];
}

- (void)checkCacheEvent:(id)sender{
    self.localArraylist = [self getCacheFiles];
    [self.cachetable reloadData];
}

- (void)testevemt:(id)sender{
    if (self.stockInput.text.length > 0){
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"你输入的股票代码异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    //600546

    
    NSString *strURL = [NSString stringWithFormat:@"http://180.153.25.174:40010/url?appName=app2&key=%@&stock=%@",self.securityKeyInput.text,self.stockInput.text];
    NSURL *tempurl = [NSURL URLWithString:strURL];
    //创建一个请求NSURLSession.h
    NSURLRequest *request = [NSURLRequest requestWithURL:tempurl];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        ASCRootClassEntity *statusInfoModel = [[ASCRootClassEntity alloc] initWithDic:dict];
        if (statusInfoModel) {
            NSDictionary *datadic = [dict objectForKey:@"data"];
            if (statusInfoModel.data.error_no.integerValue  == 0) {
                DetailViewController *tempDetail = [[DetailViewController alloc] initWithStocKCode:@"600546"];
                [self.navigationController pushViewController:tempDetail animated:YES];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:[datadic objectForKey:@"error_info"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                alert.tag = 0;
                [alert show];
            }
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"网络异常,请检测网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag = 0;
        [alert show];
    }
}

- (NSArray *)getCacheFiles{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *filePath = [EMDownloaderoperation resourceZipRouthPath];
    NSArray *filesArray= [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    return filesArray;
}

- (void)clearCacheEvent:(id)sender{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *filePath = [EMDownloaderoperation resourceZipRouthPath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"缓存文件删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    alert.tag = 0;
    [alert show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.localArraylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentify = @"";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %@",indexPath.row + 1,[self.localArraylist objectAtIndex:indexPath.row]];
    return  cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
//http://180.153.25.174:40010/url?appName=app2&key=key2&stock=600000
@end
