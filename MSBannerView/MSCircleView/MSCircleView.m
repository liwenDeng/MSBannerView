//
//  MSCircleView.m
//  MSBannerView
//
//  Created by dengliwen on 15/12/2.
//  Copyright © 2015年 dengliwen. All rights reserved.
//

#import "MSCircleView.h"
#import <UIImageView+WebCache.h>

static NSString* const  kCellIdentifier = @"MSCircleCellIdentifier";

@interface MSCircleView () <UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  本地图片数组
 */
@property (nonatomic, strong)NSArray* localImageArray;

/**
 *  网络图片（地址）数组
 */
@property (nonatomic, strong)NSArray* urlImageArray;

/**
 *  每一业显示图片的个数
 */
@property (nonatomic, assign)NSInteger perPageCount;
// 传入图片数量
@property (nonatomic, assign)NSInteger realImageCount;
@property (nonatomic, strong)UICollectionView* collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, assign)NSInteger totalPage;
@property (nonatomic, strong)NSTimer* timer;

@end

@implementation MSCircleView

+ (instancetype)circleViewWithFrame:(CGRect)frame urlImageArray:(NSArray *)urlImageArray
{
    return [self circleViewWithFrame:frame urlImageArray:urlImageArray perPageCount:1];
}

+ (instancetype)circleViewWithFrame:(CGRect)frame urlImageArray:(NSArray *)urlImageArray perPageCount:(NSInteger)perPageCount
{
    return [[self alloc]initWithFrame:frame imageArray:urlImageArray perPageCount:perPageCount];
}

+ (instancetype)circleViewWithFrame:(CGRect)frame localImageArray:(NSArray *)localImageArray
{
    return [self circleViewWithFrame:frame localImageArray:localImageArray perPageCount:1];
}

+ (instancetype)circleViewWithFrame:(CGRect)frame localImageArray:(NSArray *)localImageArray perPageCount:(NSInteger)perPageCount
{
    return [[self alloc]initWithFrame:frame imageArray:localImageArray perPageCount:perPageCount];
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray*)imageArray perPageCount:(NSInteger)perPageCount
{
    
    if (self = [super initWithFrame:frame]) {
        [self setImageArray:imageArray perPageCount:perPageCount];
        [self initUIWithFrame:frame];
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame
{
    // 布局格式
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat width = frame.size.width / _perPageCount;
    CGFloat height = frame.size.height;
    _flowLayout.itemSize = CGSizeMake(width, height) ;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // collectionView
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES; // 是否分页
    
    [_collectionView registerClass:self.cellClass ? self.cellClass : [MSCircleBaseCell class]  forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionView];
    
}

- (void)setImageArray:(NSArray*)imageArray perPageCount:(NSInteger)perPageCount {
    _perPageCount = perPageCount;
    _realImageCount = imageArray.count;
    _urlImageArray = [NSMutableArray array];
    _localImageArray = [NSMutableArray array];
    if (imageArray.count > 1) {
        if ([[imageArray firstObject] isKindOfClass:[UIImage class]]) {
            [self reSetLocalImageArray:imageArray perPageCount:perPageCount];
        }
        else if ([[imageArray firstObject] isKindOfClass:[NSString class]]) {
            [self reSetUrlImageArrayWith:imageArray perPageCount:perPageCount];
        }
        [self.collectionView reloadData];
        [self scrollToFirstPage];
    }
}

#pragma  mark - 重新填充数据
- (void)reSetUrlImageArrayWith:(NSArray *)urlImageArray perPageCount:(NSInteger)perPageCount
{
    
    if (perPageCount == 1) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:urlImageArray];
        [array addObject:[urlImageArray firstObject]];
        [array insertObject:[urlImageArray lastObject] atIndex:0];
        self.urlImageArray = array;
        _totalPage = array.count / perPageCount;
        return;
    }
    
    // 如果能除尽，则传入的个数为一个循环，再补上头和尾
    if (urlImageArray.count % perPageCount == 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:urlImageArray];
        for (NSInteger i = 0; i < perPageCount; i++) {
            // 补上头
            NSString *head = [urlImageArray objectAtIndex:i];
            [array addObject:head];
            // 补上尾
            NSString *tail = [urlImageArray objectAtIndex:urlImageArray.count - perPageCount + i];
            [array insertObject:tail atIndex:i];
        }
        self.urlImageArray = array;
        _totalPage = array.count / perPageCount;
        
        return;
    }
    // 如果除不尽，则每 urlImageArray.count * perPageCount 为一组循环,再加上头和尾
    else {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < perPageCount; i++) {
            [array addObjectsFromArray:urlImageArray];
        }
        for (NSInteger i = 0; i < perPageCount; i++) {
            // 补上头
            NSString *head = [urlImageArray objectAtIndex:i];
            [array addObject:head];
            // 补上尾
            NSString *tail = [urlImageArray objectAtIndex:urlImageArray.count - perPageCount + i];
            [array insertObject:tail atIndex:i];
        }
        self.urlImageArray = array;
        _totalPage = array.count / perPageCount;
        return;
    }
    
}

- (void)reSetLocalImageArray:(NSArray *)localImageArray perPageCount:(NSInteger)perPageCount
{
    if (perPageCount == 1) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:localImageArray];
        [array addObject:[localImageArray firstObject]];
        [array insertObject:[localImageArray lastObject] atIndex:0];
        self.localImageArray = array;
        _totalPage = array.count / perPageCount;
        return;
    }
    
    // 如果能除尽，则传入的个数为一个循环，再不上头和尾
    if (localImageArray.count % perPageCount == 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:localImageArray];
        for (NSInteger i = 0; i < perPageCount; i++) {
            // 补上头
            NSString *head = [localImageArray objectAtIndex:i];
            [array addObject:head];
            // 补上尾
            NSString *tail = [localImageArray objectAtIndex:localImageArray.count - perPageCount + i];
            [array insertObject:tail atIndex:i];
        }
        self.localImageArray = array;
        _totalPage = array.count / perPageCount;
        
        return;
    }
    // 如果除不尽，则每 urlImageArray.count * perPageCount 为一组循环,再加上头和尾
    else {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < perPageCount; i++) {
            [array addObjectsFromArray:localImageArray];
        }
        for (NSInteger i = 0; i < perPageCount; i++) {
            // 补上头
            NSString *head = [localImageArray objectAtIndex:i];
            [array addObject:head];
            // 补上尾
            NSString *tail = [localImageArray objectAtIndex:localImageArray.count - perPageCount + i];
            [array insertObject:tail atIndex:i];
        }
        self.localImageArray = array;
        _totalPage = array.count / perPageCount;
        return;
    }
    
}

#pragma mark - UICollectionViewDelegate&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urlImageArray.count ? self.urlImageArray.count : self.localImageArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSCircleBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (self.urlImageArray.count) {
        NSString *imageStr = self.urlImageArray[indexPath.row];
        [cell.imaView sd_setImageWithURL:[NSURL URLWithString:imageStr]] ;
    } else {
        cell.imaView.image = self.localImageArray[indexPath.row];
    }
    
    // Cell在外部下标
    NSInteger index = (indexPath.row - _perPageCount) % _realImageCount;
    if (index < 0) {
        index = _realImageCount - _perPageCount + indexPath.row;
    }
    
    if (self.configBlock) {
        self.configBlock(cell,index);
    }
    
    if ([self.delegate respondsToSelector:@selector(circleView:configCustomCell:AtIndex:)]) {
        // 自定义cell配置
        if (!self.cellClass) {
            NSAssert(0, @"必须先设置self.cellClass_继承自MSCircleBaseCell类");
            return cell;
        }
        [self.delegate circleView:self configCustomCell:cell AtIndex:index];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 处理点击所在下标
    NSInteger index = (indexPath.row - _perPageCount) % _realImageCount;
    if (index < 0) {
        index = _realImageCount - _perPageCount + indexPath.row;
    }
    
    if (self.block) {
        self.block(index);
    }
    
    if ([self.delegate respondsToSelector:@selector(circleView:clickedAtIndex:)]) {
        [self.delegate circleView:self clickedAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if (x == 0) {
        [self scrollToLastPage];
    } else if (x == (_totalPage - 1) * _collectionView.frame.size.width) {
        [self scrollToFirstPage];
    } else {
        NSInteger pageIndex = _collectionView.contentOffset.x / self.frame.size.width;
        if (self.pageScrollBlock) {
            self.pageScrollBlock(pageIndex - 1);
        }
    }
}

// autoScroll
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll ) {
        [self stopScroll];
    }
}

// 滑动完全停止后再启动自动播放
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self startScroll];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.autoScroll ) {
        [self stopScroll];
    }
    // 按图片宽度分页
    if (self.scrollByItem) {
        CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    }
}

// 参考 http://www.cocoachina.com/ios/20141216/10645.html 模仿分页功能 可以连续滑动
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = _collectionView.frame.size.width / _perPageCount;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

#pragma mark - Scroll
- (void)scrollToLastPage {
    CGFloat x = (_totalPage - 2 ) * _collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(x, 0) animated:NO];
}

- (void)scrollToFirstPage {
    CGFloat x = _collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(x, 0) animated:NO];
}

#pragma - mark 自动播放
- (void)startScroll
{
    //    NSLog(@"开始播放");
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval == 0 ? 2.5 : self.interval target:self selector:@selector(scrollToNextGroupOrItem) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopScroll
{
    if (_timer) {
        //        NSLog(@"停止了");
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollToNextGroupOrItem
{
    // 如果在播放时点击了图片，可能会使分割出现偏差 需要修正当前x
    //    NSInteger currentIndex = roundf(_collectionView.contentOffset.x / _flowLayout.itemSize.width);
    NSInteger currentIndex = _collectionView.contentOffset.x / _flowLayout.itemSize.width;
    CGFloat amendX = currentIndex * _flowLayout.itemSize.width;
    
    if (self.scrollByItem) {
        CGFloat targetX = amendX + _flowLayout.itemSize.width;
        [self stopScroll];
        [_collectionView setContentOffset:CGPointMake(targetX, 0) animated:YES];
        [self startScroll];
    } else {
        [self stopScroll];
        CGFloat targetX = amendX + _collectionView.frame.size.width;
        [_collectionView setContentOffset:CGPointMake(targetX, 0) animated:YES];
        [self startScroll];
    }
}

#pragma mark - property
- (void)setScrollByItem:(BOOL)scrollByItem
{
    _scrollByItem = scrollByItem;
    _collectionView.pagingEnabled = !scrollByItem;
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    if (autoScroll) {
        [self startScroll];
    }
}

- (void)setCellClass:(Class)cellClass
{
    
    if ([cellClass isSubclassOfClass:[MSCircleBaseCell class]]) {
        _cellClass = cellClass;
        [_collectionView registerClass:self.cellClass  forCellWithReuseIdentifier:kCellIdentifier];
    } else {
        NSAssert(0, @"cellClass 必须是 MSCircleBaseCell子类");
        return;
    }
    
}

#pragma mark - block
- (void)addTapBlock:(CircleViewTapBlock)block
{
    _block = [block copy];
}

- (void)configCustomCell:(CircleViewCustomCellConfigBlock)configBlock
{
    if (!self.cellClass) {
        NSAssert(0, @"必须先设置self.cellClass_继承自MSCircleBaseCell类");
        return;
    }
    self.configBlock = configBlock;
}

- (void)addPageScrollBlock:(CircleViewPageScrollBlock)pageScrollBlock {
    _pageScrollBlock = [pageScrollBlock copy];
}

#pragma mark - LifeCirlce
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    NSLog(@"circle dealloc");
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow) {
        //        NSLog(@"在显示中");
        if (self.autoScroll && _timer == nil) {
            [self startScroll];
        }
    }else {
        //        NSLog(@"不在显示");
        [_timer invalidate];
        _timer = nil;
    }
}

@end
