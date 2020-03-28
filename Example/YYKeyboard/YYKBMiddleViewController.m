//
//  YYKBMiddleViewController.m
//  YYKeyboard_Example
//
//  Created by 王玉 on 2020/3/28.
//  Copyright © 2020 wangyu1001@live.cn. All rights reserved.
//

#import "YYKBMiddleViewController.h"
#import "YYKBViewController.h"

@interface YYKBMiddleViewController ()

@end

@implementation YYKBMiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Tap me !";
    [self.view addSubview:label];
    label.textColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    YYKBViewController *vc = [[YYKBViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
