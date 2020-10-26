//
//  SHScrollView.m
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHScrollView.h"
#import <UIImageView+WebCache.h>

@interface SHScrollView () < UICollectionViewDataSource, UICollectionViewDelegate >

//定时器
@property (nonatomic, weak) NSTimer *timer;
//内容视图
@property (nonatomic, weak) UICollectionView *mainView;

@property (nonatomic, assign) BOOL isFull;

@end

@implementation SHScrollView

static NSString *cellId = @"SHScrollView";

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.labBGColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 懒加载
- (UICollectionView *)mainView
{
    if (!_mainView)
    {
        //UICollectionView的自动布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置滑动方向
        layout.scrollDirection = self.scrollDirection;

        //内容
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];

        mainView.backgroundColor = [UIColor clearColor];
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;

        [self addSubview:mainView];

        //注册
        [mainView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];

        _mainView = mainView;
    }

    return _mainView;
}

#pragma mark - 私有方法
#pragma mark 点击视图
- (void)tapAction
{
    if (self.endRollingBlock)
    {
        self.endRollingBlock(YES, self.currentIndex);
    }
}

#pragma mark 配置数据源
- (void)configCell:(UICollectionViewCell *)cell obj:(id)obj
{
    //移除所有子视图
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
 
    //添加视图
    UIScrollView *baseView = [[UIScrollView alloc] init];
    baseView.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
    //添加点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [baseView addGestureRecognizer:tap];
    //添加到视图
    [cell.contentView addSubview:baseView];
    
    if (self.isZoom)
    {
        baseView.delegate = self;
        baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        baseView.minimumZoomScale = 1;
        baseView.maximumZoomScale = 10;
        baseView.showsVerticalScrollIndicator = NO;
        baseView.showsHorizontalScrollIndicator = NO;
    }

    //设置默认视图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = baseView.bounds;
    imageView.contentMode = self.contentMode;

    if ([obj isKindOfClass:[NSString class]])
    { //字符串

        NSString *str = (NSString *)obj;

        if ([str hasPrefix:@"http"])
        { //网络图片

            //设置默认视图
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:self.placeholderImage];
            [baseView addSubview:imageView];
        }
        else
        { //lab

            UILabel *lab = [self getLabView];
            lab.frame = baseView.bounds;
            lab.text = str;
            [baseView addSubview:lab];
        }
    }
    else if ([obj isKindOfClass:[NSAttributedString class]])
    { //富文本

        UILabel *lab = [self getLabView];
        lab.frame = baseView.bounds;
        lab.attributedText = (NSAttributedString *)obj;
        [baseView addSubview:lab];
    }
    else if ([obj isKindOfClass:[UIImage class]])
    { //图片

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = baseView.bounds;
        imageView.contentMode = self.contentMode;
        imageView.image = (UIImage *)obj;
        [baseView addSubview:imageView];
    }
    else if ([obj isKindOfClass:[UIViewController class]])
    { //控制器

        UIViewController *vc = (UIViewController *)obj;
        vc.view.frame = baseView.bounds;
        [baseView addSubview:vc.view];
    }
    else if ([obj isKindOfClass:[UIView class]])
    { //视图

        UIView *view = obj;
        [baseView addSubview:view];
    }
    else
    { //展示默认图片

        imageView.image = self.placeholderImage;
        [baseView addSubview:imageView];
    }
}

- (UILabel *)getLabView
{
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = self.labBGColor;
    lab.textColor = self.textColor;
    lab.font = self.font;
    lab.textAlignment = self.textAlignment;
    lab.numberOfLines = self.numberOfLines;
    return lab;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.mainView)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.mainView)
    {
        if (self.timeInterval >= 0)
        {
            return 3;
        }
        else
        {
            //不循环
            return self.contentArr.count;
        }
    }
    return 0;
}

#pragma mark 实例化UICollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.mainView)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell.contentView.layer.masksToBounds = YES;

        NSInteger index = indexPath.row;

        //计算位置
        if ((self.timeInterval >= 0))
        {
            //界面循环
            index = self.currentIndex - 1 + index;
        }

        id data = self.contentArr[[self getIndex:index]];
        //配置数据源
        [self configCell:cell obj:data];

        return cell;
    }
    return nil;
}

- (NSInteger)getIndex:(NSInteger)index
{
    NSInteger count = self.contentArr.count;

    BOOL isTrue = true;
    while (isTrue)
    {
        if (index >= 0 && index < count)
        {
            isTrue = false;
        }
        else
        {
            //处理
            if (index < 0)
            {
                index = count + index;
            }
            if (index >= count)
            {
                index = index - count;
            }
        }
    }

    return index;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.mainView)
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];

        if (!self.isFull)
        {
            self.currentIndex = indexPath.row;
        }

        [self tapAction];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.mainView)
    {
        return self.itemSize;
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.mainView)
    {
        return self.edgeInset;
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.mainView)
    {
        //item 主轴方向间距
        return self.space;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //item 辅轴方向间距
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mainView])
    {
        //开始滚动
        if (self.startRollingBlock)
        {
            self.startRollingBlock();
        }

        [self timeStop];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.mainView])
    {
        [self dealTime];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mainView])
    {
        if (!self.isFull)
        {
            if (self.rollingBlock)
            {
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
                {
                    self.rollingBlock(scrollView.contentOffset.x);
                }
                else
                {
                    self.rollingBlock(scrollView.contentOffset.y);
                }
            }
            return;
        }

        CGFloat index;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            index = scrollView.contentOffset.x / (scrollView.frame.size.width);
        }
        else
        {
            index = scrollView.contentOffset.y / (scrollView.frame.size.height);
        }

        if (index == (NSInteger)index)
        { //滑动了一页

            NSInteger temp = self.currentIndex;

            if (self.timeInterval < 0)
            { //界面不循环

                temp = (NSInteger)index;
            }
            else
            { //界面循环

                switch ((NSInteger)index)
                {
                    case 0: //左
                    {
                        temp -= 1;
                    }
                    break;
                    case 2: //右
                    {
                        temp += 1;
                    }
                    break;
                    default:
                        break;
                }
                //保护
                if (temp < 0)
                {
                    temp = self.contentArr.count - 1;
                }
                if (temp >= self.contentArr.count)
                {
                    temp = 0;
                }
            }

            self.currentIndex = temp;
            index = temp;
        }
        else
        { //滑动中

            if (self.timeInterval >= 0)
            { //界面循环

                NSInteger temp = 0;
                if (self.currentIndex == 0)
                {
                    temp = self.contentArr.count - 1;
                }
                else
                {
                    temp = self.currentIndex - 1;
                }

                index += temp;
            }
        }

        //滚动中
        if (self.rollingBlock)
        {
            self.rollingBlock(index);
        }
    }
}

#pragma mark 缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.mainView] && self.isZoom)
    {
        UIScrollView *scroll = [self getCurrentScroll];

        if ([scroll isEqual:scrollView])
        {
            return [scroll.subviews firstObject];
        }
    }

    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (![scrollView isEqual:self.mainView] && self.isZoom)
    {
        UIScrollView *scroll = [self getCurrentScroll];

        if ([scroll isEqual:scrollView])
        {
            [scrollView setZoomScale:scale animated:NO];
        }
    }
}

#pragma mark 获取当前Scroll
- (UIScrollView *)getCurrentScroll
{
    UICollectionViewCell *cell = [self.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:((self.timeInterval < 0) ? self.currentIndex : 1) inSection:0]];
    UIScrollView *scroll = [cell.contentView.subviews lastObject];
    return scroll;
}

#pragma mark - SET
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    //超过数组限制，不进行处理
    if (currentIndex >= self.contentArr.count)
    {
        return;
    }

    _currentIndex = currentIndex;

    //刷新内容
    [self.mainView reloadData];

    if (!self.isFull)
    {
        return;
    }

    NSInteger index = currentIndex;
    if (self.timeInterval >= 0)
    {
        //界面循环
        index = 1;
    }

    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

    //滚动了一页
    if (self.endRollingBlock)
    {
        self.endRollingBlock(NO, currentIndex);
    }
}

#pragma mark - 时间操作
#pragma mark 时间处理
- (void)dealTime
{
    //停止
    [self timeStop];

    if (self.timeInterval > 0)
    { //存在间隔时间
        //创建新的时间
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

#pragma mark 时间停止
- (void)timeStop
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 下一页
- (void)nextPage
{
    //数组为空
    if (!self.contentArr.count)
    {
        return;
    }

    //滚动到下一页
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 刷新视图
- (void)reloadView
{
    //数组为空
    if (!self.contentArr.count)
    {
        return;
    }

    //设置内容大小
    if (!(self.itemSize.width || self.itemSize.height))
    {
        self.itemSize = self.frame.size;
        self.isFull = YES;
    }

    if (self.space)
    {
        self.isFull = NO;
    }

    if (self.edgeInset.top || self.edgeInset.left || self.edgeInset.bottom || self.edgeInset.right)
    {
        self.isFull = NO;
    }

    //判断
    if (self.isFull)
    {
        //一致的时候
        self.mainView.pagingEnabled = YES;
    }
    else
    {
        //不一致的时候
        self.mainView.pagingEnabled = NO;
        self.timeInterval = -1;
        self.isZoom = NO;
    }

    if (self.timeInterval < 0)
    {
        self.mainView.bounces = YES;
    }
    else
    {
        self.mainView.bounces = NO;
    }

    //超出数组则重置
    if (!self.currentIndex || self.currentIndex >= self.contentArr.count)
    {
        self.currentIndex = 0;
    }

    //处理时间
    [self dealTime];
}

#pragma mark - 禁止拖动
- (void)disableDrag
{
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

@end
