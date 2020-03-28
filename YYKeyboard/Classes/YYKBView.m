//
//  YYKBView.m
//  FBSnapshotTestCase
//
//  Created by 王玉 on 2020/3/28.
//

#import "YYKBView.h"
#import "YYKBEmojiManager.h"

//#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface YYKBView ()<UIScrollViewDelegate>
/**test*/
@property (nonatomic, strong)YYTextSimpleEmoticonParser *parser;
/**pageControl*/
@property (nonatomic, strong)UIPageControl *pageControl;
@end

@implementation YYKBView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        
    }
    return self;
}

- (void)createUI{
    NSDictionary *dict = [[YYKBEmojiManager sharedManager] imageMapper];
    __block NSArray *emojiArr = [dict allKeys];
    __block UIScrollView *scrllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, floor((kScreenWidth - 8)/8) * 4 + 20)];
    scrllView.contentSize = CGSizeMake(kScreenWidth * (emojiArr.count/32 + 1), floor((kScreenWidth - 8)/8) * 4 + 20);
    [self addSubview:scrllView];
    scrllView.backgroundColor = self.backgroundColor;
    scrllView.pagingEnabled = YES;
    scrllView.showsHorizontalScrollIndicator = NO;
    scrllView.delegate = self;
    [self addSubview:self.pageControl];
    _pageControl.bottom = scrllView.height;
    _pageControl.left = 0;
    _pageControl.numberOfPages = 5;
    /** test */
    for (int i = 0; i < (emojiArr.count/32 + 1); i ++) {
        YYLabel *label = [[YYLabel alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, floor((kScreenWidth - 8)/8) * 4 + 20)];
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = floor((kScreenWidth - 8)/8);
        label.textParser = self.parser;
        label.linePositionModifier = mod;
        label.font = [UIFont systemFontOfSize:floor((kScreenWidth - 8)/8)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textVerticalAlignment = YYTextVerticalAlignmentTop;
        label.backgroundColor = [UIColor whiteColor];
        label.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        label.numberOfLines = 0;
        [scrllView addSubview:label];
        
        NSArray *reslutArr = [emojiArr subarrayWithRange:NSMakeRange(32 * i, 32 * i + 32  < emojiArr.count ?32 : emojiArr.count - 32*i)];
        
        
        NSMutableAttributedString *lastStr = [[NSMutableAttributedString alloc] initWithString:@""];
        for (NSString *emojiStr in reslutArr) {
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:emojiStr];
            [attriStr setTextHighlightRange:NSMakeRange(0, emojiStr.length) color:[UIColor whiteColor] backgroundColor:self.backgroundColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSInteger page = scrllView.contentOffset.x/kScreenWidth;
                NSString *emojiStr = emojiArr[page * 32 + range.location];
                NSLog(@"%@", emojiStr);
                if (self.keyboardClick) {
                    self.keyboardClick(emojiStr);
                }
            }];
            
            [lastStr appendAttributedString:attriStr];
        }
        
        
        
        
        [lastStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:floor((kScreenWidth - 8)/8)],NSKernAttributeName:@(20),NSBackgroundColorAttributeName:[UIColor redColor]} range:lastStr.rangeOfAll];
        lastStr.maximumLineHeight = floor((kScreenWidth - 8 -  35)/8);
        lastStr.minimumLineHeight = floor((kScreenWidth - 8 - 35)/8);
        
        //
        
        
        //           NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:las attributes:@{NSKernAttributeName:@(5)}];
        //           NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //           [lastStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lastStr length])];
        //           label.attributedText = attributedString;
        
        
        //        NSString *emojiStr = [reslutArr componentsJoinedByString:@""];
        //        label.text = emojiStr;
        label.attributedText = lastStr;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

#pragma mark ------------ lazy ------------

- (YYTextSimpleEmoticonParser *)parser {
    if (nil == _parser) {
        _parser = [YYTextSimpleEmoticonParser new];
        _parser.emoticonMapper = [[YYKBEmojiManager sharedManager] imageMapper];
    }
    return _parser;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _pageControl.backgroundColor = [UIColor orangeColor];
    }
    return _pageControl;
}

@end
