//
//  MSCircleCustomCell.m
//  MSBannerView
//
//  Created by dengliwen on 15/12/9.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import "MSCircleCustomCell.h"

@implementation MSCircleCustomCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        self.textLabel.backgroundColor = [UIColor redColor];
        [self.imaView addSubview:self.textLabel];
    }
    return self;
}

@end
