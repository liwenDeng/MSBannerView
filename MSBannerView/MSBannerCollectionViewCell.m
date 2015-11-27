//
//  MSBannerCollectionViewCell.m
//  MSBannerView
//
//  Created by dengliwen on 15/8/13.
//  Copyright (c) 2015年 dengliwen. All rights reserved.
//

#import "MSBannerCollectionViewCell.h"

@implementation MSBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView
{
    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 50, 180)];
    [_numLabel setTextColor:[UIColor redColor]];
    _numLabel.backgroundColor = [UIColor grayColor];

    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_numLabel];
}

@end
