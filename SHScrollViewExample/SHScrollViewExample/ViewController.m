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
    
    NSArray *imageArr = @[@"http://d.hiphotos.baidu.com/image/h%3D200/sign=8663264274f082023292963f7bfbfb8a/f3d3572c11dfa9eca13b947665d0f703918fc1be.jpg"];
    
    
    SHScrollView *view = [[SHScrollView alloc]init];
    view.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    view.contentArr = imageArr;
    view.timeInterval = 2;
    [self.view addSubview:view];
    
    view.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lab.text = [NSString stringWithFormat:@"---%ld---",(long)currentIndex];
        });
        
    };
    
    [view reloadView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
