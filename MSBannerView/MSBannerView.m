//
//  MSBannerView.m
//  MSBannerView
//
//  Created by dengliwen on 15/8/13.
//  Copyright (c) 2015年 dengliwen. All rights reserved.
//

#import "MSBannerView.h"
#import "MSBannerCollectionViewCell.h"
#import <UIImageView+WebCache.h>

static NSString* const  kBannerCellIdentifier = @"MSBannerCollectionViewCell";

@interface MSBannerView () <UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  网络图片地址数组
 */
@property (nonatomic,strong) NSArray* imageURLStringsGroup;

/**
 *  本地图片数组
 */
@property (nonatomic,strong) NSArray* localizationImagesGroup;

@property (nonatomic, strong)UICollectionView* collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout* flowLayout;

@property (nonatomic, assign)NSInteger totalItemsCount;  // 传入的真实图片个数
@property (nonatomic, assign)NSInteger perGroupItemCount;  // 每一组需要显示的个数
@property (nonatomic, assign)NSInteger displayItemsCount;   //需要显示的总个数
@property (nonatomic, assign)NSInteger displayGroupCount;   //需要显示的总组数

@property (nonatomic, assign)CGFloat currentGroupIndex;    //当先显示所在组

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation MSBannerView


- (instancetype)initWithFrame:(CGRect)frame perGroupItemCount:(NSInteger)perGroupItemCount totalItemsCount:(NSInteger) totalItemsCount
{
    NSAssert( perGroupItemCount < totalItemsCount, @"传入的数组个数必须大于每组个数");
    
    if (self = [super initWithFrame:frame]) {
        _perGroupItemCount = perGroupItemCount;
        _totalItemsCount = totalItemsCount;
        
        // 向上取整加2
        CGFloat count = ceilf(((CGFloat)totalItemsCount / (CGFloat)perGroupItemCount ));
        _displayGroupCount = (NSInteger)count + 2;
        _displayItemsCount = _displayGroupCount * perGroupItemCount;
    
        [self initUIWithFrame:frame];
        
    }
    return self;
}

- (void)initialization
{
    
}

- (void)initUIWithFrame:(CGRect)frame
{
    // 布局格式
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    ;
    CGFloat width = frame.size.width / _perGroupItemCount;
    CGFloat height = frame.size.height;
    flowLayout.itemSize = CGSizeMake(width, height) ;
    flowLayout.minimumLineSpacing = 0;
    
    // 滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    // 创建collectionView
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES; // 是否分页
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MSBannerCollectionViewCell class] forCellWithReuseIdentifier:kBannerCellIdentifier];
    [self addSubview:_collectionView];
    
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup
{
    return [self bannerViewWithFrame:frame perGroupItemCount:1 imagesGroup:imagesGroup];
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame perGroupItemCount:(NSInteger)perGroupItemCount imagesGroup:(NSArray *)imagesGroup
{
    MSBannerView* baner = [[self alloc]initWithFrame:frame perGroupItemCount:perGroupItemCount totalItemsCount:imagesGroup.count];
    baner.localizationImagesGroup = imagesGroup;
    
    [baner scrollToFirstGroup];
    
    return baner;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imagesURLStringsGroup
{
    return [self bannerViewWithFrame:frame perGroupItemCount:1 imageURLStringsGroup:imagesURLStringsGroup];
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame perGroupItemCount:(NSInteger)perGroupItemCount imageURLStringsGroup:(NSArray *)imagesURLStringsGroup
{
    MSBannerView* baner = [[self alloc]initWithFrame:frame perGroupItemCount:perGroupItemCount totalItemsCount:imagesURLStringsGroup.count];
    baner.imageURLStringsGroup = imagesURLStringsGroup;
    
    [baner scrollToFirstGroup];
    return baner;
}

#pragma - mark setProperties
- (void)setImageURLStringsGroup:(NSArray *)imafeURLStringsGroup
{
    _imageURLStringsGroup = imafeURLStringsGroup;
    _totalItemsCount = imafeURLStringsGroup.count;
    [_collectionView reloadData];
}

- (void)setLocalizationImagesGroup:(NSArray *)localizationImagesGroup
{
    _localizationImagesGroup = localizationImagesGroup;
    _totalItemsCount = localizationImagesGroup.count;
    [_collectionView reloadData];
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self startScroll];
    }
}

#pragma - mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _displayItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellIdentifier forIndexPath:indexPath];
    
    // 显示本地图片
    if (self.localizationImagesGroup.count > 0) {
        
        // 获取当前组号
        NSInteger group = indexPath.row / _perGroupItemCount ;
        
        // 起始组 （为虚拟组）
        if (group == 0  ) {
            
            // 倒数第一组起始下标
            NSInteger index = (_displayGroupCount - 3) * _perGroupItemCount;
            NSInteger row = index + indexPath.row;
            
            // 防止数组越界
            if (row  < self.localizationImagesGroup.count) {
                //倒数第一组的内容
                [cell.imageView setImage:self.localizationImagesGroup[row]];
            } else {
                [cell.imageView setImage:nil];
            }
            
        }
        // 最后一组
        else if (group == _displayGroupCount - 1) {
            NSInteger row = indexPath.row % _perGroupItemCount;
            [cell.imageView setImage:self.localizationImagesGroup[row]];
        }
        else {
            NSInteger row = indexPath.row - _perGroupItemCount;
            // 防止数组越界
            if (row < self.localizationImagesGroup.count) {
                [cell.imageView setImage:self.localizationImagesGroup[indexPath.row  - _perGroupItemCount ]];
            } else {
                [cell.imageView setImage:nil];
            }
        }
    }
    
    // 显示网络图片
    else if (self.imageURLStringsGroup.count > 0 ) {
        
        // 获取当前组号
        NSInteger group = indexPath.row / _perGroupItemCount;
        
        // 起始组 （为虚拟组）
        if (group == 0  ) {
            // 倒数第一组起始下标
            NSInteger index = (_displayGroupCount - 3) * _perGroupItemCount;
            // 防止数组越界
            NSInteger row = index + indexPath.row;
            if (row  < self.imageURLStringsGroup.count) {
                //倒数第一组的内容
                [cell.imageView sd_setImageWithURL:self.imageURLStringsGroup[row]];
            } else {
                [cell.imageView setImage:nil];
            }
            
        }
        // 最后一组
        else if (group == _displayGroupCount - 1) {
            NSInteger row = indexPath.row % _perGroupItemCount;
            [cell.imageView sd_setImageWithURL:self.imageURLStringsGroup[row]];
        }
        else {
            NSInteger row = indexPath.row - _perGroupItemCount;
            // 防止数组越界
            if (row < self.imageURLStringsGroup.count) {
                [cell.imageView sd_setImageWithURL:self.imageURLStringsGroup[indexPath.row  - _perGroupItemCount ]];
            } else {
                 [cell.imageView setImage:nil];
            }
            
        }
        
    }
    
    cell.numLabel.text = [NSString stringWithFormat:@"第%d",indexPath.row - _perGroupItemCount];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.bannerTapBlock) {
        self.bannerTapBlock(indexPath.row - _perGroupItemCount);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:ClickedAtIndex:)]) {
        [self.delegate bannerView:self ClickedAtIndex:(indexPath.row - _perGroupItemCount)];
    }

}

- (void)addTapEventWithBlock:(BannerTapBlock)block
{
    _bannerTapBlock = [block copy];
}

#pragma - mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentGroupIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 循环滑动处理
    if (_currentGroupIndex == 0) {
        [self scrollToLastGroup];
    }
    else if (_currentGroupIndex == _displayGroupCount -1 ) {
        [self scrollToFirstGroup];
       
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self stopScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self startScroll];
    }
}

#pragma - mark 自动播放
- (void)startScroll
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(scrollToNextGroup) userInfo:nil repeats:YES];
}

- (void)stopScroll
{
    [_timer invalidate];
}

- (void)scrollToNextItem
{
    NSInteger index = _collectionView.contentOffset.x / _collectionView.frame.size.width;

    // 循环滑动处理
    if (index == 0) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_totalItemsCount inSection:0 ] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else if (index == _totalItemsCount + 1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    }
    else {
        // 向左滑动时设置为 UICollectionViewScrollPositionLeft
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionLeft) animated:YES];
    }
    
}

- (void)scrollToNextGroup
{
    if (_currentGroupIndex == 0 || _currentGroupIndex == _displayGroupCount -1) {
        return;
    }
    CGFloat x = _collectionView.contentOffset.x;
    x += _collectionView.frame.size.width;
    CGFloat y = _collectionView.contentOffset.y;
    [_collectionView setContentOffset:CGPointMake(x, y) animated:YES];
}

- (void)scrollToFirstGroup
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_perGroupItemCount inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
}

- (void)scrollToLastGroup
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(_displayGroupCount - 1)*_perGroupItemCount - 1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
}
@end
