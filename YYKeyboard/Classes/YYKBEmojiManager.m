//
//  YYKBEmojiManager.m
//  FBSnapshotTestCase
//
//  Created by 王玉 on 2020/3/28.
//

#import "YYKBEmojiManager.h"

@interface YYKBEmojiManager ()
@property (nonatomic,strong) NSMutableDictionary *imageDic;
@end

@implementation YYKBEmojiManager
+ (instancetype)sharedManager {
    static YYKBEmojiManager *emojiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiManager = [[YYKBEmojiManager alloc] init];
        NSMutableDictionary *finalDic = [NSMutableDictionary dictionary];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"YYKeyboard" withExtension:@"bundle"];
        NSBundle *targetBundle = [NSBundle bundleWithURL:url];
        NSString *path = [targetBundle pathForResource:@"emojipath" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in dic.allKeys) {
            NSString *emojiStr = [NSString stringWithFormat:@"%@",[dic valueForKey:key]];
            [finalDic setValue:[self whiteBorderImageFromEmojiText:emojiStr] forKey:key];
        }
        emojiManager.imageDic = finalDic;
    });
    return emojiManager;
}
/** YYKeyboard */
+ (UIImage *)getImageWithBoudleName:(NSString *)boudleName imgName:(NSString *)imgName {
NSBundle *bundle = [NSBundle bundleForClass:[self class]];
NSURL *url = [bundle URLForResource:boudleName withExtension:@"bundle"];
NSBundle *targetBundle = [NSBundle bundleWithURL:url];
UIImage *image = [UIImage imageNamed:imgName
                            inBundle:targetBundle
       compatibleWithTraitCollection:nil];
return image;
}




+ (UIImage *)whiteBorderImageFromEmojiText:(NSString *)emojiText {

    UIImage *image = [self getImageWithBoudleName:@"YYKeyboard" imgName:emojiText];
    CGFloat borderWidth = 5;
    // 1.加载原图
    UIImage *oldImage = image;
    // 2.开启上下文
    CGFloat radiusWidth = ([UIScreen mainScreen].bounds.size.width - 7 * 5 - 20 - 8 * 10)/8;
    CGFloat imageW = radiusWidth + 2 * borderWidth;
    CGFloat imageH = radiusWidth + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.画边框(大圆)
    [[UIColor clearColor] set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
//    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, radiusWidth, radiusWidth)];
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSMutableDictionary *)imageMapper {
    
    return self.imageDic;
}
@end
