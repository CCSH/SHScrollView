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
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.lab.layer.cornerRadius = 10;
//    self.lab.layer.masksToBounds = YES;
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    lab.backgroundColor = [UIColor orangeColor];
    lab.text = @"我是lab";
    lab.textAlignment = NSTextAlignmentCenter;
    
    
    NSArray *imageArr = @[@"http://txt25-2.book118.com/2017/0420/book99787/99786555.jpg",
                          lab,
                          @"http://pic.58pic.com/58pic/15/63/07/42Q58PIC42U_1024.jpg",
                          @"http://d.hiphotos.baidu.com/image/h%3D200/sign=8663264274f082023292963f7bfbfb8a/f3d3572c11dfa9eca13b947665d0f703918fc1be.jpg",
                          @"http://img.zcool.cn/community/01690955496f930000019ae92f3a4e.jpg@2o.jpg"];
    
    
    SHScrollView *view = [[SHScrollView alloc]init];
    view.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);

    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    
    view.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lab.text = [NSString stringWithFormat:@"- %ld -",(long)currentIndex];
        });
    };
    
    view.rollingBlock = ^(CGFloat offset) {

        NSLog(@"------%f",offset);
    };
    
    //设置数据源
    view.contentArr = imageArr;
    view.timeInterval = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
