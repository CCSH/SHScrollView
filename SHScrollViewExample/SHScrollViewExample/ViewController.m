//
//  ViewController.m
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageArr = @[@"http://d.hiphotos.baidu.com/image/h%3D200/sign=8663264274f082023292963f7bfbfb8a/f3d3572c11dfa9eca13b947665d0f703918fc1be.jpg",@"http://b.hiphotos.baidu.com/image/h%3D200/sign=8c8dc382d239b60052ce08b7d9513526/b58f8c5494eef01fa36ad8a4e7fe9925bc317d51.jpg",@"http://f.hiphotos.baidu.com/image/h%3D300/sign=fe7559fe29dda3cc14e4be2031e83905/b03533fa828ba61e1d90084e4634970a304e5951.jpg",@"http://img0.bdstatic.com/img/image/shouye/chongwu0214.jpg",@"http://a.hiphotos.baidu.com/image/h%3D300/sign=58f3b1720ef79052f01f413e3cf2d738/caef76094b36acaf568a549d7bd98d1001e99c6d.jpg"];
    
    
    SHScrollView *view = [[SHScrollView alloc]init];
    view.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    view.contentArr = imageArr;
    view.timeInterval = 3;
    [self.view addSubview:view];
    
    view.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        NSLog(@"当前位置-----%ld",(long)currentIndex);
    };
    
    [view reloadView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
