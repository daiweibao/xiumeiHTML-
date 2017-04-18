//
//  RootViewController.m
//  xiumeiHTML
//
//  Created by zmxn on 16/7/12.
//  Copyright © 2016年 xiumei. All rights reserved.
//

#import "RootViewController.h"
#import "HtmlDetaViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Header.h"
#import "MBProgressHUD.h"
//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    //还没有数据
    UIImageView *girl;
    //提示
    UILabel *message;
}

//tableview
@property(nonatomic,strong)UITableView * tableView;
//刷新
@property(nonatomic,assign) NSInteger  currentPage;

//数据源
@property(nonatomic,strong)NSMutableArray * dataSouce;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"嗅美文章测试版";
    
    //加载tableview
    [self tableView];
    
    //请求数据
    [self loadDesignerArticle];
   //刷新
    [self refresh];
}


#pragma mark ==============刷新==================
-(void)refresh{
    MJRefreshNormalHeader * Header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage=0;
        [self loadDesignerArticle];
        
    }];
    
    self.tableView.mj_header=Header;
    
    MJRefreshAutoNormalFooter * footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _currentPage++;
        [self  loadDesignerArticle];
        
    }];
    self.tableView.mj_footer=footer;
    
}


#pragma mark  ===================测试文章列表======================
-(void)loadDesignerArticle{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
    NSDictionary * dict = @{@"page.count":@5,@"page.currPage":@(_currentPage)};
    [manager POST:getTestArticle parameters:dict constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] isEqual:@"00"]) {
                 if (_currentPage==0) {
                    [self.dataSouce removeAllObjects];
                }
                //已经去全部加载完毕
                if (_currentPage>0 && [responseObject[@"result"] count] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        });
                    });
                }
                //数据
                [self.dataSouce addObjectsFromArray:responseObject[@"result"]];
                
                //数据太少影藏
                if (self.dataSouce.count<5) {
                    self.tableView.mj_footer.hidden = YES;
                }
                
                
                //还没有数据提示
                if (self.dataSouce.count==0) {
                    [girl removeFromSuperview];
                    [message removeFromSuperview ];
                    
                    girl = [[UIImageView alloc] init];
                    girl.frame = CGRectMake((SCREEN_WIDTH/2 - 72.0*WidthProportion), 230.0*HeightProportion+64, 144.0*WidthProportion, 208.0*HeightProportion);
                    girl.image = [UIImage imageNamed:@"img-wuxiaoxi"];
                    [self.tableView addSubview:girl];
                    
                    message = [[UILabel alloc]init];
                    message.frame = CGRectMake(0, CGRectGetMaxY(girl.frame)+32.0*HeightProportion, SCREEN_WIDTH, 12);
                    message.text = @"还没有测试数据，快去添加吧~";
                    message.textAlignment = NSTextAlignmentCenter;
                    message.font = [UIFont systemFontOfSize:16];
                    message.textColor = [UIColor grayColor];
                    [self.tableView addSubview:message];
                    // 隐藏加载控件
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    //有数据了就移除
                    [girl removeFromSuperview];
                    [message removeFromSuperview ];
                    
                    
                }
                

            [self.tableView reloadData];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        //没网等各种错误提示
        MBProgressHUD * hudNet = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        hudNet.animationType = MBProgressHUDAnimationZoom;
        hudNet.mode = MBProgressHUDModeText;
        hudNet.color = [UIColor blackColor];
        [hudNet hide:YES afterDelay:1];
        [hudNet setLabelText:error.localizedDescription];
        
        
        [girl removeFromSuperview];
        [message removeFromSuperview ];
        
        girl = [[UIImageView alloc] init];
        girl.frame = CGRectMake((SCREEN_WIDTH/2 - 72.0*WidthProportion), 230.0*HeightProportion+64, 144.0*WidthProportion, 208.0*HeightProportion);
        girl.image = [UIImage imageNamed:@"img-wuxiaoxi"];
        [self.tableView addSubview:girl];
        
        message = [[UILabel alloc]init];
        message.frame = CGRectMake(0, CGRectGetMaxY(girl.frame)+32.0*HeightProportion, SCREEN_WIDTH, 12);
        message.text = @"抱歉，测试接口还没上线~";
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:16];
        message.textColor = [UIColor grayColor];
        [self.tableView addSubview:message];
        // 隐藏加载控件
        self.tableView.mj_footer.hidden = YES;

        
        
        
    }];
    
}

-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}

//tableView懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)  style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //去掉水平滚动线
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
//        self.tableView.scrollsToTop = YES;
        [self.view addSubview:_tableView];
        
    }
    
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSouce.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  44;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * stringAircle = @"cell";
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:stringAircle];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringAircle];
        /* 忽略点击效果 */
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.text = self.dataSouce[indexPath.row][@"title"];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row%2==0) {
        
        cell.backgroundColor = [UIColor colorWithRed:0.902 green:0.808 blue:0.412 alpha:1.000];
        
    }else{
        cell.backgroundColor = [UIColor colorWithRed:0.322 green:0.902 blue:0.243 alpha:1.000];
        
    }
   
    return cell;
    
}


//点击某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HtmlDetaViewController * htmlVC = [[HtmlDetaViewController alloc]init];
    htmlVC.articleNewID = self.dataSouce[indexPath.row][@"testArticleId"];
    htmlVC.stringtitle = self.dataSouce[indexPath.row][@"title"];
    [self.navigationController pushViewController:htmlVC animated:YES];
    
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
