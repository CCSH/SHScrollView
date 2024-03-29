//
//  SHScrollView.h
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHScrollView : UIView

#pragma mark - 必传
//内容Arr (网址、UIView、UIImage、UIViewController, NSString ,NSAttributedString，本地图片，资源图片，GIF、NSArray<UIImage>)
@property (nonatomic, copy) NSArray *contentArr;

#pragma mark - 非必传
//显示位置(设置在 contentArr 之后)
@property (nonatomic, assign) NSInteger currentIndex;
//默认图片
@property (nonatomic, copy) UIImage *placeholderImage;
//图片显示模式
@property (nonatomic, assign) UIViewContentMode contentMode;
//滚动方向(默认 UICollectionViewScrollDirectionHorizontal)
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
//是否可以缩放(默认 NO) 有间距space、边距edgeInset无法缩放
@property (nonatomic, assign) BOOL isZoom;
//是否可以点击(默认 YES)
@property (nonatomic, assign) BOOL isClick;
//是否禁止拖拽(默认 NO 可以拖拽)
@property (nonatomic, assign) BOOL isDisableDrag;
//是否弹簧效果(默认 YES)
@property (nonatomic, assign) BOOL isBounces;

//内容为 NSArray<UIImage>、本地GIF时 用到的属性
//动画次数(默认 0)
@property (nonatomic, assign) NSInteger animationRepeatCount;
//动画时长(默认 0)
@property (nonatomic, assign) NSTimeInterval animationDuration;

//自动轮播时间间隔 (默认是0）
// < 0 不自动 不界面循环
// = 0 不自动 界面循环
// > 0 自动 界面循环
@property (nonatomic, assign) CGFloat timeInterval;

#pragma mark 如果自定义了 item 大小则 timeInterval isZoom失效
//内容大小(默认与视图相同)
@property (nonatomic, assign) CGSize itemSize;

#pragma mark 下方属性搭配使用
//间距
@property (nonatomic, assign) CGFloat space;
//内容边距
@property (nonatomic, assign) UIEdgeInsets edgeInset;

#pragma mark 标签样式
//如果 contentArr 有 str格式则使用uilabel展示
@property (nonatomic, strong) UIColor *labBGColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger numberOfLines;

#pragma mark - 回调
//开始
@property (nonatomic, copy) void (^startRollingBlock)(void);
//滚动中
@property (nonatomic, copy) void (^rollingBlock)(CGFloat offset);
//滚动了一页
@property (nonatomic, copy) void (^endRollingBlock)(BOOL isClick, NSInteger currentIndex);
//内容返回
@property (nonatomic, copy) UIView * (^contentView)(id obj, NSInteger index);

//刷新视图
- (void)reloadView;

@end
