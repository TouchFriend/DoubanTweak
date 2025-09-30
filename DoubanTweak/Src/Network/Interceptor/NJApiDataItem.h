//
//  NJApiDataItem.h
//  DoubanTweak
//
//  Created by touchWorld on 2025/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJApiDataItem : NSObject

/// 请求任务
@property (nonatomic, strong) NSURLSessionTask *task;


+ (NSString *)url;

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
    didReceiveData:(NSData *)data
         origBlock:(void(^)(NSURLSession *,
                            NSURLSessionDataTask *,
                            NSData *))origBlock;

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
         origBlock:(void(^)(NSURLSession *,
                            NSURLSessionTask *,
                            NSError *))origBlock
didReceiveDataBlock:(void(^)(NSURLSession *,
                             NSURLSessionDataTask *,
                             NSData *))didReceiveDataBlock;

- (NSData *)handleWithData:(NSData *)data
                   session:(NSURLSession *)session
                      task:(NSURLSessionTask *)task;

@end

NS_ASSUME_NONNULL_END
