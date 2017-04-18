
//
//  Header.h
//  xiumeiHTML
//
//  Created by zmxn on 16/7/12.
//  Copyright © 2016年 xiumei. All rights reserved.
//

#ifndef Header_h
#define Header_h


//公司内网IP(打开切换到内网)
//#define OutInterent_IP @"http://192.168.1.23/Bride"

//外网测试
#define OutInterent_IP @"https://test.kemeiapp.com"

//公司外网IP（打开切换到正式网）(😡切换到此网时必须把下面👇H5页面相关的接口切到😡正式网😡)
//#define OutInterent_IP @"http://api2.kemeiapp.com"


#define WidthProportion  SCREEN_WIDTH/750.0    //宽度和屏幕宽度的比例
#define HeightProportion  SCREEN_HEIGHT/1334.0   //高度和屏幕高度的比例

//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//测试文章列表
#define getTestArticle [NSString stringWithFormat:@"%@/outer/v1/article/getTestArticle.do",OutInterent_IP]
//测试文章详情
#define getTestArticleInfo [NSString stringWithFormat:@"%@/outer/v1/article/getTestArticleInfo.do",OutInterent_IP]


#endif /* Header_h */
