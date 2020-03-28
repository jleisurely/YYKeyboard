//
//  YYKBEmojiManager.h
//  FBSnapshotTestCase
//
//  Created by 王玉 on 2020/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYKBEmojiManager : NSObject

+ (instancetype)sharedManager;

- (NSMutableDictionary *)imageMapper;


@end

NS_ASSUME_NONNULL_END
