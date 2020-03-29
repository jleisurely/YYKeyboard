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
#import "PPTextBackedString.h"

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
    _keyboard.keyboardClick = ^(NSString * _Nonnull emoji) {
        if (!emoji) {
            return;
        }
        NSRange selectedRange = weakSelf.textView.selectedRange;
        if ([emoji isEqualToString:@"[/back]"]) {
            
           NSRange selectedRange = weakSelf.textView.selectedRange;
            if (selectedRange.location == 0 && selectedRange.length == 0) {
                return;
            }

            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.textView.attributedText];
            if (selectedRange.length > 0) {
                [attributedText deleteCharactersInRange:selectedRange];
                weakSelf.textView.attributedText = attributedText;
                weakSelf.textView.selectedRange = NSMakeRange(selectedRange.location, 0);
            } else {
                NSUInteger deleteCharactersCount = 1;
                
                // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情，以确认删除按钮将要删除的是否是 emoji。这个正则匹配可以匹配绝大部分的 emoji，得到该 emoji 的正确的 length 值；不过会将某些 combined emoji（如 👨‍👩‍👧‍👦 👨‍👩‍👧‍👦 👨‍👨‍👧‍👧），这种几个 emoji 拼在一起的 combined emoji 则会被匹配成几个个体，删除时会把 combine emoji 拆成个体。瑕不掩瑜，大部分情况下表现正确，至少也不会出现删除 emoji 时崩溃的问题了。
                NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
                NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
                NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
                NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
                NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
                NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
                for (NSTextCheckingResult *match in matches) {
                    if (match.range.location + match.range.length == selectedRange.location) {
                        deleteCharactersCount = match.range.length;
                        break;
                    }
                }
                
                [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
                self.textView.attributedText = attributedText;
                self.textView.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
            }

            [self textViewDidChange:self.textView];
            return;
        }
        
        NSString *emojiString = emoji;
        NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.textView.attributedText];
        [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
        weakSelf.textView.attributedText = attributedText;
        weakSelf.textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0);
        
        [weakSelf textViewDidChange:weakSelf.textView];
    
    };
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshTextUI];

    
}

- (void)refreshTextUI
{
    if (!self.textView.text.length) {
        return;
    }

    UITextRange *markedTextRange = [self.textView markedTextRange];
    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
    if (position) {
        return;     // 正处于输入拼音还未点确定的中间状态
    }

    NSRange selectedRange = self.textView.selectedRange;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:[self pp_plainTextForRange:NSMakeRange(0, self.textView.attributedText.length)] attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:self.textView.font.pointSize], NSForegroundColorAttributeName: [UIColor redColor] }];

    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;

    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}

- (NSString *)pp_plainTextForRange:(NSRange)range
{
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return nil;
    }

    NSMutableString *result = [[NSMutableString alloc] init];
    if (range.length == 0) {
        return result;
    }

    NSString *string = self.textView.text;
    NSAttributedString *attriString = [[NSAttributedString alloc]initWithString:string];
    [attriString enumerateAttribute:PPTextBackedStringAttributeName inRange:range options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        PPTextBackedString *backed = value;
        if (backed && backed.string) {
            [result appendString:backed.string];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result;
}


-(NSRange)rangeOfString:(NSString*)subString inString:(NSString*)string atOccurrence:(NSInteger)occurrence
{
    int currentOccurrence = 0;
    NSRange    rangeToSearchWithin = NSMakeRange(0, [string length]);
    
    while (YES)
    {
        currentOccurrence++;
        NSRange searchResult = [string rangeOfString:subString options:1 range:rangeToSearchWithin];
        
        if (searchResult.location == NSNotFound)
        {
            return searchResult;
        }
        if (currentOccurrence == occurrence)
        {
            return searchResult;
        }
        
        NSInteger newLocationToStartAt = searchResult.location + searchResult.length;
        rangeToSearchWithin = NSMakeRange(newLocationToStartAt, string.length - newLocationToStartAt);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)emojiBtnClicked:(UIButton *)sender {
//    if (_keyboard.isHidden) {
//        [self.textView resignFirstResponder];
//    }
//    [UIView animateWithDuration:1 animations:^{
    if (self.textView.isFirstResponder == NO) {
        return;
    }
    
        _keyboard.hidden = !_keyboard.isHidden;
//    }];
    if (_keyboard.isHidden) {
        self.textView.inputView = nil;
    }else{
        self.textView.inputView = _keyboard;
    }
    [self.textView reloadInputViews];
}

- (void)textViewDidBeginEditing:(YYTextView *)textView{
    self.keyboard.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

//这里进行你需要的东西

    return YES;

}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
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
