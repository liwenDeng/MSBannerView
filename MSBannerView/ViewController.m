//
//  ViewController.m
//  MSBannerView
//
//  Created by dengliwen on 15/8/13.
//  Copyright (c) 2015年 dengliwen. All rights reserved.
//

#import "ViewController.h"
#import "MSBannerView.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    MSBannerView *banner = [[MSBannerView alloc]initWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 200) itemSize:CGSizeMake(self.view.frame.size.width, 200) spacing:0];
    NSArray *arr = @[
                     @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                     @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                     @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                     
                     ];

//    MSBannerView *banner = [MSBannerView bannerViewWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 200) imageURLStringsGroup:arr];
    MSBannerView *banner = [MSBannerView bannerViewWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 200) perGroupItemCount:2 imageURLStringsGroup:arr];
    banner.backgroundColor = [UIColor yellowColor];
    banner.autoScroll = NO;
    
    [banner addTapEventWithBlock:^(NSInteger index) {
        NSLog(@"click %ld",(long)index);
    }];
    
    
    [self.view addSubview:banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
