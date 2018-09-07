//
//  SHScrollView.m
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHScrollView.h"
#import "UIImageView+WebCache.h"

@interface SHScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation SHScrollView

static NSString *cellId = @"SHScrollCollectionViewCell";

#pragma mark - 懒加载
- (UICollectionView *)mainView{
    if (!_mainView) {
        
        //UICollectionView的自动布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置滑动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置水平间距（内部）
        layout.minimumInteritemSpacing = 0;
        //设置竖直间距（内部）
        layout.minimumLineSpacing = 0;
        //设置外框间距 (外部)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置内容大小
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        //内容
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        mainView.bounces = NO;
        mainView.pagingEnabled = YES;
        
        [self addSubview:mainView];
        
        [mainView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        
        _mainView = mainView;
    }
    
    return _mainView;
}

#pragma mark - 刷新界面
- (void)reloadView{
    
    [self.mainView reloadData];
    [self timeStart];
}

#pragma mark 时间开始
- (void)timeStart{
    
    if (self.timeInterval) {//存在间隔时间
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

#pragma mark 时间停止
- (void)timeStop{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 下一页
- (void)nextPage{
    
    int index = [self currentIndex] + 1;
    
    if (index >= self.contentArr.count) {//最后一个
        index = 0;
    }
    
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark 获取当前位置
- (int)currentIndex{

    int index = (self.mainView.contentOffset.x + self.mainView.frame.size.width*0.5) / self.mainView.frame.size.width;
    
    return MAX(0, index);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.contentArr.count;
}

#pragma mark 实例化UICollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    
    id obj = self.contentArr[indexPath.row];
    
    if ([obj isKindOfClass:[NSString class]]) {//字符串
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = cell.contentView.bounds;
        
        if ([obj hasPrefix:@"http"]) {//网络图片
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:self.placeholderImage];
        } else {
            
            //资源图片
            UIImage *image = [UIImage imageNamed:obj];
            
            if (!image) {//本地图片
                
                image = [UIImage imageWithContentsOfFile:obj];
            }
            if (!image) {//默认图片
                
                image = self.placeholderImage;
            }
            imageView.image = image;
        }
        
        
        [cell.contentView addSubview:imageView];
    } else if ([obj isKindOfClass:[UIImage class]]) {//图片
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = cell.contentView.bounds;
        imageView.image = (UIImage *)obj;
        [cell.contentView addSubview:imageView];
    } else if ([obj isKindOfClass:[UIViewController class]]) {//控制器
        
        UIViewController *vc = self.contentArr[indexPath.item];
        vc.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:vc.view];
    }else{//视图
        
        [cell.contentView addSubview:obj];
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (self.endRollingBlock) {
        self.endRollingBlock(YES, indexPath.row);
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始滚动
    if (self.startRollingBlock) {
        self.startRollingBlock();
    }
    
    [self timeStop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self timeStart];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动中
    if (self.rollingBlock) {
        self.rollingBlock(scrollView.contentOffset.x);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (!self.contentArr.count){
        return;
    }

    if (self.endRollingBlock) {
        self.endRollingBlock(NO, [self currentIndex]);
    }
}


@end
