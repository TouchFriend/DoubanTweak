//
//  NJApiDataInterceptor.h
//  DoubanTweak
//
//  Created by touchWorld on 2025/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJApiDataInterceptor : NSObject

- (instancetype)init;

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

@end

NS_ASSUME_NONNULL_END
