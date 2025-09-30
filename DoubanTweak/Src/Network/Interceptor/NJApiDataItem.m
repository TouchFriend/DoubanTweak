//
//  NJApiDataItem.m
//  DoubanTweak
//
//  Created by touchWorld on 2025/9/30.
//

#import "NJApiDataItem.h"
#import "NSURLSessionTask+NJDataInterceptor.h"

@interface NJApiDataItem ()

/// <#Desription#>
@property (nonatomic, strong) NSMutableData *receiveData;


@end

@implementation NJApiDataItem

#pragma mark - Life Cycle Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

#pragma mark - Do Init

- (void)doInit {
    self.receiveData = [[NSMutableData alloc] init];
}

#pragma mark - Override Methods

#pragma mark - Public Methods

+ (NSString *)url {
    return @"";
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
    didReceiveData:(NSData *)data
         origBlock:(void(^)(NSURLSession *,
                            NSURLSessionDataTask *,
                            NSData *))origBlock {
    if (data) {
        [self.receiveData appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
         origBlock:(void(^)(NSURLSession *,
                            NSURLSessionTask *,
                            NSError *))origBlock
didReceiveDataBlock:(void(^)(NSURLSession *,
                             NSURLSessionDataTask *,
                             NSData *))didReceiveDataBlock {
    // 处理错误
    if (error) {
        if (origBlock) origBlock(session, task, error);
        return;
    }
    
    // 处理数据
    NSData *dataHandled = [self handleWithData:self.receiveData
                                       session:session
                                          task:task];
    // 传递数据
    if (didReceiveDataBlock) {
        // 添加拦截标志
        task.nj_interceptData = NJ_INTERCEPT_DATA_FLAG;
        didReceiveDataBlock(session,
                            (NSURLSessionDataTask *)task,
                            dataHandled);
    }
    // 调用原方法
    if (origBlock) origBlock(session, task, error);
}

- (NSData *)handleWithData:(NSData *)data
                   session:(NSURLSession *)session
                      task:(NSURLSessionTask *)task {
    return data;
}


#pragma mark - Private Methods

#pragma mark - Property Methods


@end
