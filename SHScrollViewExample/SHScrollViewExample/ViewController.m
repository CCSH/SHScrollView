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
    

    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(10, 10, 100, 100);
    lab.backgroundColor = [UIColor redColor];
    lab.text = @"我是lab";
    lab.textAlignment = NSTextAlignmentCenter;
    
    NSArray *imageArr = @[@"http://txt25-2.book118.com/2017/0420/book99787/99786555.jpg",
                          @"http://pic23.nipic.com/20120816/10691507_162853344170_2.jpg",
                          @"http://d.hiphotos.baidu.com/image/h%3D200/sign=8663264274f082023292963f7bfbfb8a/f3d3572c11dfa9eca13b947665d0f703918fc1be.jpg",
                          lab,
                          @"http://img.zcool.cn/community/01690955496f930000019ae92f3a4e.jpg@2o.jpg",
                          @"我是str"];
    
    
    SHScrollView *view = [[SHScrollView alloc]init];
    view.frame = CGRectMake((self.view.frame.size.width - 300)/2, 100, 300, 150);
    view.backgroundColor = [UIColor orangeColor];

    [self.view addSubview:view];
    
    //回调
    view.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        self.lab.text = [NSString stringWithFormat:@"- %ld -",(long)currentIndex];
    };
    view.rollingBlock = ^(CGFloat offset) {
        NSLog(@"滚动中====%f",offset);
    };
    
    //设置数据源
    view.contentArr = imageArr;
    view.timeInterval = 3;

    [view reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
