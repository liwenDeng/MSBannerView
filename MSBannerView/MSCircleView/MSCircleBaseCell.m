//
//  MSCircleCell.m
//  MSBannerView
//
//  Created by dengliwen on 15/12/4.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import "MSCircleBaseCell.h"

@implementation MSCircleBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imaView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imaView];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        self.textLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

@end
