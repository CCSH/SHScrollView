//
//  SHScrollView.h
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHScrollView : UIView

//内容Arr (http、path、view、image、vc) 设置完内容就直接刷新了
@property (nonatomic, copy) NSArray *contentArr;
//显示位置(需要先设置内容在设置此属性)
@property (nonatomic, assign) NSInteger currentIndex;
//默认图片
@property (nonatomic, copy) UIImage *placeholderImage;

//自动轮播时间间隔 (默认是0）
// < 0 不自动 不界面循环
// = 0 不自动 界面循环
// > 0 自动 界面循环
@property (nonatomic, assign) CGFloat timeInterval;

//开始
@property (nonatomic, copy) void (^startRollingBlock)(void);
//滚动中
@property (nonatomic, copy) void (^rollingBlock)(CGFloat offset);
//滚动了一页
@property (nonatomic, copy) void (^endRollingBlock)(BOOL isClick,NSInteger currentIndex);


@end
