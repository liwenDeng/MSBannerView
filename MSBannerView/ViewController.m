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
    
    
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 1 ; i <= 6; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        UIImage *imge = [UIImage imageNamed:str];
        [arr1 addObject:imge];
    }
    
    MSCircleView *circle = [MSCircleView circleViewWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200) localImageArray:arr1 perPageCount:3];
    circle.delegate = self;
//    circle.autoScroll = YES;
//    circle.scrollByItem = YES;
    circle.cellClass = [MSCircleCustomCell class];
    
    [circle addTapBlock:^(NSInteger index) {
        NSLog(@"current Index:%d",index);
    }];
    
    [circle configCustomCell:^(MSCircleBaseCell *customCell, NSInteger index) {
        ((MSCircleCustomCell*)customCell).textLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    }];
    
    [self.view addSubview:circle];
    
    //    NSArray *arr = @[
    //                     @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
    //                     @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
    //                     @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
    //
    //                     ];
    
    //    MSCircleView *circle = [MSCircleView circleViewWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 200) urlImageArray:arr perPageCount:2];

    
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

@end
