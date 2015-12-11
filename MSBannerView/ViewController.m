//
//  ViewController.m
//  MSBannerView
//
//  Created by dengliwen on 15/8/13.
//  Copyright (c) 2015年 dengliwen. All rights reserved.
//

#import "ViewController.h"
#import "MSCircleView.h"
#import "MSCircleCustomCell.h"
@interface ViewController () <MSCircleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 本地图片
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 1 ; i <= 10; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        UIImage *imge = [UIImage imageNamed:str];
        [arr1 addObject:imge];
    }
    
    MSCircleView *circle = [MSCircleView circleViewWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 200) localImageArray:arr1 perPageCount:3];
    circle.delegate = self;     // 代理方法：可实现item的点击和赋值操作
    circle.autoScroll = YES;    // 开启自动轮播
    circle.scrollByItem = YES;  // YES 每次滑动一个item; NO 每次滑动一页
    
    circle.cellClass = [MSCircleCustomCell class];  //自定义item的Cell
    // 点击item的block 也可以通过代理实现
    [circle addTapBlock:^(NSInteger index) {
        NSLog(@"current Index:%d",index);
    }];
    
    // 自定义cell 的block，也可以通过代理实现
    [circle configCustomCell:^(MSCircleBaseCell *customCell, NSInteger index) {
        
        ((MSCircleCustomCell*)customCell).textLabel.text = [NSString stringWithFormat:@"下标：%ld",(long)index];
        [((MSCircleCustomCell*)customCell).textLabel sizeToFit];
    }];
    
    [self.view addSubview:circle];
    
    // 网络图片创建方式：
    NSArray *arr = @[
                     @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                     @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                     @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",

                     ];

    MSCircleView *circleByWebImage = [MSCircleView circleViewWithFrame:CGRectMake(0, 400,self.view.frame.size.width, 200) urlImageArray:arr perPageCount:2];

    [self.view addSubview:circleByWebImage];
    
    
}

//- (void)circleView:(MSCircleView *)circleView configCustomCell:(MSCircleBaseCell *)customCell AtIndex:(NSInteger)index
//{
//    MSCircleCustomCell *cell = (MSCircleCustomCell*)customCell;
//    cell.textLabel.text = [NSString stringWithFormat:@"%d",index];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"vc dealloc");
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

@end
