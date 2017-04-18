
//
//  HtmlDetaViewController.m
//  xiumeiHTML
//
//  Created by zmxn on 16/7/12.
//  Copyright © 2016年 xiumei. All rights reserved.
//

#import "HtmlDetaViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "Header.h"
//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HtmlDetaViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    
    //加载中
    MBProgressHUD * hudLoding;
}

@property (nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIWebView * webView;

@property(nonatomic,assign)CGFloat webHeight;

@property(nonatomic,strong)NSString * strUrl;

@end

@implementation HtmlDetaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationController];
    [self loadDesignerArticleDeta];
    
    hudLoding = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudLoding.animationType = MBProgressHUDAnimationZoomIn;
    hudLoding.color = [UIColor blackColor];
    [hudLoding setLabelText:@"加载中..."];

   
}

#pragma mark 创建导航栏
-(void)createNavigationController{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(pressButtonLeft)];
    self.navigationItem.leftBarButtonItem = item;
    
    //设置中间标题
    UILabel * labelTitle                = [[UILabel alloc]init];
    labelTitle.frame                   = CGRectMake(100, 0, self.view.frame.size.width-200, 64);
    labelTitle.textColor               = [UIColor blackColor];
    labelTitle.textAlignment           = NSTextAlignmentCenter;
    labelTitle.text = self.stringtitle;
    labelTitle.font                    = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = labelTitle;
    
}
//返回
-(void)pressButtonLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  ===================测试文章详情======================
-(void)loadDesignerArticleDeta{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
    NSDictionary *dict = @{@"testArticleId":self.articleNewID};
    [manager POST:getTestArticleInfo parameters:dict constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] isEqual:@"00"]) {
                self.strUrl = responseObject[@"result"];
                [self.tableView reloadData];
                
                hudLoding.mode = MBProgressHUDModeText;
                [hudLoding setLabelText:@"加载完成"];
                [hudLoding hide:YES afterDelay:0.5];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //没网等各种错误提示
        MBProgressHUD * hudNet = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        hudNet.animationType = MBProgressHUDAnimationZoom;
        hudNet.mode = MBProgressHUDModeText;
        hudNet.color = [UIColor blackColor];
        [hudNet hide:YES afterDelay:1];
        [hudNet setLabelText:error.localizedDescription];

        NSLog(@"%@",error.localizedDescription);
        
    }];
    
    
    
}


#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        //tableview拖动时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark tableView的数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _webView.frame.size.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//        if (self.model.info.length>0) {
            static NSString * reuseID=@"stringnew";
            UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
                if (!self.webView) {
                    
                    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                    webView.backgroundColor = [UIColor whiteColor];
                    self.webView = webView;
                    webView.delegate = self;
                    webView.scrollView.scrollEnabled = NO;
                    NSString *str;
                    if (!self.strUrl) {
                        str = @" ";
                    }else{
                        str = self.strUrl;
                    }
                    
                    NSString * htmlString = [NSString stringWithFormat:@"<head><body width=%fpx style=\"word-wrap:break-word;\"><style>img{max-width:%fpx !important;}</style></head>%@",SCREEN_WIDTH,SCREEN_WIDTH-15,str];
                    
                    [webView loadHTMLString:htmlString baseURL:nil];
                    [cell.contentView addSubview:webView];
                  
                    //KVO获取网页高度
                    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                    
                }
                /* 忽略点击效果 */
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
            }
            
            cell.tag = indexPath.row;
            return cell;
}


//KVO获取网页高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize size = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
    
    if (self.webHeight >0) {
        return;
    }
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height);
    self.webHeight = size.height;
    [self.tableView reloadData];
}

//移除通知
-(void)dealloc{
    //移除观察者
    [self.webView.scrollView removeObserver:self
     
                                 forKeyPath:@"contentSize" context:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
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
