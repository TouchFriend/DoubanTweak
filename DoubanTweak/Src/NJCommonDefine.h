//
//  NJCommonDefine.h
//  BiliBiliTweak
//
//  Created by touchWorld on 2025/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 NSLog(@"%@:%@-%p-%s", nj_logPrefix, NSStringFromClass([(id)self class]), self, __FUNCTION__);
 %log(nj_logPrefix);
 */
/// 日志前缀
UIKIT_EXTERN const NSString *nj_logPrefix;

/// 资源路径
#define NJAssetPath(path) @"/Library/Caches/NJDouban/" #path

NS_ASSUME_NONNULL_END
