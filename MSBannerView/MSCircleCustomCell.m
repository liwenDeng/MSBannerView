//
//  MSCircleCustomCell.m
//  MSBannerView
//
//  Created by dengliwen on 15/12/9.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import "MSCircleCustomCell.h"

@implementation MSCircleCustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imaView.layer.borderColor = [UIColor redColor].CGColor;
        self.imaView.layer.borderWidth = 1;
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        [self.imaView addSubview:self.textLabel];
    }
    return self;
}

@end
