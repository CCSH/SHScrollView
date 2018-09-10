//
//  SHScrollView.h
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHScrollView : UIView

//内容视图
@property (nonatomic, weak) UICollectionView *mainView;

//每张图片对应要显示的文字数组
@property (nonatomic, strong) NSArray *titleArr;
//内容Arr (http、path、view、image、vc)
@property (nonatomic, copy) NSArray *contentArr;
//默认图片
@property (nonatomic, copy) UIImage *placeholderImage;
//时间间隔(不设置则不进行轮播)
@property (nonatomic, assign) CGFloat timeInterval;

//开始
@property (nonatomic, copy) void (^startRollingBlock)(void);
//滚动中
@property (nonatomic, copy) void (^rollingBlock)(CGFloat offset);
//滚动了一页
@property (nonatomic, copy) void (^endRollingBlock)(BOOL isClick,NSInteger currentIndex);

//刷新界面
- (void)reloadView;

@end
