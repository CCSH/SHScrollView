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
    
    NSArray *contentArr = @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F29%2F20200329042030_uCcGM.thumb.400_0.gif&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1649492559&t=d503fa816b5a0dd8f9d7a2e64a293e9f",
                          @"1.gif",
                            @"Image",
                          @"http://d.hiphotos.baidu.com/image/h%3D200/sign=8663264274f082023292963f7bfbfb8a/f3d3572c11dfa9eca13b947665d0f703918fc1be.jpg",
                          lab,
                          @"http://img.zcool.cn/community/01690955496f930000019ae92f3a4e.jpg@2o.jpg",
                          @"我是str",
                            @[[UIImage imageNamed:@"Image"],
                              [UIImage imageNamed:@"Image-1"]]];
    
    SHScrollView *view = [[SHScrollView alloc]init];
    view.animationDuration = 2;
    view.animationRepeatCount = 1;
    view.frame = CGRectMake((self.view.frame.size.width - 300)/2, 100, 300, 150);
    [self.view addSubview:view];
    
    //设置数据源
    view.contentArr = contentArr;
//    view.timeInterval = 5;
    //内容
    view.contentView = ^UIView *(id obj, NSInteger currentIndex) {
        if (currentIndex == 3) {
            UILabel *lab = [UILabel new];
            lab.frame = CGRectMake(0, 0, 200, 150);
            lab.text = [NSString stringWithFormat:@"啦啦啦啦啦%ld",(long)currentIndex];
            return lab;
        }
        return nil;
    };
    
    //回调
    view.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        self.lab.text = [NSString stringWithFormat:@"- %ld -",(long)currentIndex];
        if (isClick) {
            NSLog(@"点击了 === %ld",(long)currentIndex);
        }
    };


    [view reloadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
