//
//  YYKBView.h
//  FBSnapshotTestCase
//
//  Created by 王玉 on 2020/3/28.
//

#import <UIKit/UIKit.h>




NS_ASSUME_NONNULL_BEGIN

@interface YYKBView :UIView
/** 点击键盘回调 */
@property(nonatomic, copy) void(^keyboardClick)(NSString *code);
@end

NS_ASSUME_NONNULL_END
