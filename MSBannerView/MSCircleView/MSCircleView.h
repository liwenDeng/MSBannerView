//
//  MSCircleView.h
//  MSBannerView
//
//  Created by dengliwen on 15/12/2.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCircleBaseCell.h"

@class MSCircleView;

@protocol MSCircleViewDelegate <NSObject>

@optional

- (void)circleView:(MSCircleView*) circleView clickedAtIndex:(NSInteger)index;

- (void)circleView:(MSCircleView *)circleView configCustomCell:(MSCircleBaseCell*)customCell AtIndex:(NSInteger)index;

- (void)circleView:(MSCircleView*) circleView scrollToPageIndex:(NSInteger)pageindex;

@end

typedef void(^CircleViewTapBlock)(NSInteger index);
typedef void(^CircleViewCustomCellConfigBlock)(MSCircleBaseCell* customCell,NSInteger index);
typedef void(^CircleViewPageScrollBlock)(NSInteger index);

@interface MSCircleView : UIView

/**
 *  滑动方式 YES 每次滑动一个Item,NO 每次滑动一页
 */
@property (nonatomic, assign)BOOL scrollByItem;

/**
 *  是否自动播放
 */
@property (nonatomic, assign)BOOL autoScroll;

/**
 *  点击事件代理
 */
@property (nonatomic, weak)id<MSCircleViewDelegate> delegate;

/**
 *  点击事件
 */
@property (nonatomic, copy)CircleViewTapBlock block;

/**
 *  配置自定义Cell
 */
@property (nonatomic, copy)CircleViewCustomCellConfigBlock configBlock;

/**
 *  当前页码 从1开始
 */
@property (nonatomic, copy)CircleViewPageScrollBlock pageScrollBlock;

/**
 *  播放间隔 默认为2.5
 */
@property (nonatomic, assign)NSTimeInterval interval;

@property (nonatomic, strong)Class cellClass;

/**
 *  通过本地图片数组创建，一页一张图片
 */
+ (instancetype)circleViewWithFrame:(CGRect)frame localImageArray:(NSArray*)localImageArray;

/**
 *  通过本地图片数组创建，指定每一页显示多少张
 */
+ (instancetype)circleViewWithFrame:(CGRect)frame localImageArray:(NSArray*)localImageArray perPageCount:(NSInteger)perPageCount;

/**
 *  通过图片网络地址数组创建，一页一张图片
 */
+ (instancetype)circleViewWithFrame:(CGRect)frame urlImageArray:(NSArray*)urlImageArray;

/**
 *  通过图片网络地址数组创建，指定每一页显示多少张
 */
+ (instancetype)circleViewWithFrame:(CGRect)frame urlImageArray:(NSArray*)urlImageArray perPageCount:(NSInteger)perPageCount;

/**
 *  点击回调
 */
- (void)addTapBlock:(CircleViewTapBlock)block;
- (void)configCustomCell:(CircleViewCustomCellConfigBlock)configBlock;
- (void)addPageScrollBlock:(CircleViewPageScrollBlock)pageScrollBlock;

@end
