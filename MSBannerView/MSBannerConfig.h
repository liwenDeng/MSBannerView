//
//  MSBannerConfig.h
//  MSBannerView
//
//  Created by dengliwen on 15/11/26.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSBannerConfig : NSObject

/**
 *  样式配置相关
 */
@property (nonatomic,assign,readonly) CGSize itemSize; // item 大小
@property (nonatomic,assign,readonly) CGFloat spacing; // 间距

/**
 *  默认配置
 *
 *  @return 
 */
+ (instancetype)defaultBannerConfig;

@end
