//
//  YYKBViewController.m
//  YYKeyboard
//
//  Created by wangyu1001@live.cn on 03/28/2020.
//  Copyright (c) 2020 wangyu1001@live.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKBViewController.h"
#import <YYKBView.h>
#import <YYKit/YYKit.h>
#import <YYTextView.h>
#import "YYKBEmojiManager.h"

@interface YYKBViewController ()<YYTextViewDelegate>
/**输入框*/
@property (nonatomic, strong)YYTextView *textView;
/**emoji按钮*/
@property (nonatomic, strong)UIButton *emojiBtn;
/**keyboard*/
@property (nonatomic, strong)YYKBView *keyboard;
/**YYTextSimpleEmoticonParser*/
@property (nonatomic, strong)YYTextSimpleEmoticonParser *parser;

@end

@implementation YYKBViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    sleep(2);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.emojiBtn];
    [self.view addSubview:self.keyboard];
    __weak typeof (self) weakSelf = self;
    _keyboard.keyboardClick = ^(NSString * _Nonnull code) {
        weakSelf.textView.text = [weakSelf.textView.text stringByAppendingString:code];
    };
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)emojiBtnClicked:(UIButton *)sender {
    if (_keyboard.isHidden) {
        [self.textView resignFirstResponder];
    }
    [UIView animateWithDuration:1 animations:^{
        _keyboard.hidden = !_keyboard.isHidden;
    }];
}

- (void)textViewDidBeginEditing:(YYTextView *)textView{
    self.keyboard.hidden = YES;
}



- (YYTextView *)textView{
    if (!_textView) {
        
        _textView = [[YYTextView alloc]init];
        _textView.frame = CGRectMake(0, 100, kScreenWidth, 200);
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 25;
        _textView.font = [UIFont systemFontOfSize:25];
        _textView.textParser = self.parser;
        _textView.linePositionModifier = mod;
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor grayColor];
        _textView.text = @"";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.bounces = NO;
        
        
    }
    return _textView;
}

- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        _emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, _textView.bottom + 20, 100, 30)];
        [_emojiBtn setTitle:@"emoji" forState:UIControlStateNormal];
        [_emojiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.backgroundColor = [UIColor blueColor];
        
    }
    return _emojiBtn;
}

- (YYKBView *)keyboard{
    if (!_keyboard) {
        _keyboard = [[YYKBView alloc] initWithFrame:CGRectMake(0, _emojiBtn.bottom + 20, kScreenWidth,  floor((kScreenWidth - 8)/8) * 4 + 20)];
        _keyboard.hidden = YES;
        
        _keyboard.backgroundColor = [UIColor grayColor];
        
    }
    return _keyboard;
}

- (YYTextSimpleEmoticonParser *)parser {
    if (nil == _parser) {
        _parser = [YYTextSimpleEmoticonParser new];
        _parser.emoticonMapper = [[YYKBEmojiManager sharedManager] imageMapper];
    }
    return _parser;
}

@end
