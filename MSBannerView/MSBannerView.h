//
//  MSBannerView.h
//  MSBannerView
//
//  Created by dengliwen on 15/8/13.
//  Copyright (c) 2015年 dengliwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBannerConfig.h"

@class MSBannerView;

/**
 *  代理方法
 */
@protocol MSBannerViewDelegate <NSObject>

- (void)bannerView:(MSBannerView*)bannerView ClickedAtIndex:(NSInteger)index;

@end

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

typedef void(^BannerTapBlock)(NSInteger index);

@interface MSBannerView : UIView

@property (nonatomic, strong) MSBannerConfig* config;
@property (nonatomic, assign) BOOL autoScroll;

/**
 *  点击事件 可以通过代理实现
 */
@property (nonatomic, weak) id<MSBannerViewDelegate> delegate;

/**
 *  点击事件 可以通过block实现
 */
@property (nonatomic, copy) BannerTapBlock bannerTapBlock;

/**
 *  工厂方法：根据图片数组创建
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;

/**
 *  工程方法：根据图片数组创建，并且每一组需要展示多少个图片
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame perGroupItemCount:(NSInteger)perGroupItemCount imagesGroup:(NSArray *)imagesGroup;

/**
 *  工厂方法：根据网络图片地址数组创建
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imagesURLStringsGroup;

/**
 *  工程方法：根据网络图片地址数组创建，并且每一组需要展示多少个图片
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame perGroupItemCount:(NSInteger)perGroupItemCount imageURLStringsGroup:(NSArray *)imagesURLStringsGroup;


/**
 *  点击事件
 */
- (void)addTapEventWithBlock:(BannerTapBlock) block;

@end
