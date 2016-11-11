//
//  ViewController.m
//  LanGuang
//
//  Created by Kitty on 16/9/29.
//  Copyright © 2016年 Kitty. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "IMYWebView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

@interface ViewController () <IMYWebViewDelegate>

@property(strong,nonatomic)IMYWebView* webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *statusView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    statusView.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1];
    [self.view addSubview:statusView];
    
    self.webView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.16.8.79:8080/mobile-web/#/app/analysis"]]];
    if (self.webView.usingUIWebView) {
        UIWebView *webV = (UIWebView *)self.webView.realWebView;
        webV.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_webView reload];
        }];
//        [webV.scrollView.mj_header beginRefreshing];
        
    }else{
        WKWebView *webV = (WKWebView *)self.webView.realWebView;
        webV.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_webView reload];
        }];
//        [webV.scrollView.mj_header beginRefreshing];
    }
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IMYWebViewDelegate
- (void)webViewDidStartLoad:(IMYWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [SVProgressHUD dismiss];
    if (self.webView.usingUIWebView) {
        UIWebView *webV = (UIWebView *)self.webView.realWebView;
        
        [webV.scrollView.mj_header endRefreshing];
        
    }else{
        WKWebView *webV = (WKWebView *)self.webView.realWebView;
       
        [webV.scrollView.mj_header endRefreshing];
    }
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
    if (self.webView.usingUIWebView) {
        UIWebView *webV = (UIWebView *)self.webView.realWebView;
        
        [webV.scrollView.mj_header endRefreshing];
        
    }else{
        WKWebView *webV = (WKWebView *)self.webView.realWebView;
        
        [webV.scrollView.mj_header endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
