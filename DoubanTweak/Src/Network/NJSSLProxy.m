//
//  NJSSLProxy.m
//  DoubanTweak
//
//  Created by touchWorld on 2025/7/18.
//

#import "NJSSLProxy.h"
#import "NJCommonDefine.h"
#import <Security/Security.h>

@implementation NJSSLProxy

#pragma mark - Life Cycle Methods



#pragma mark - Do Init

- (void)doInit {
    
}

#pragma mark - Override Methods

#pragma mark - Public Methods

+ (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void ( ^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
         origBlock:(void(^)(void))origBlock
               log:(NSString *)log {
    NSString *logStr = [NSString stringWithFormat:@"%@:%@", @"[session challenge]", log];
    [self internalURLSession:session
         didReceiveChallenge:challenge
           completionHandler:completionHandler
                   origBlock:origBlock
                         log:logStr];
}



+ (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void ( ^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
         origBlock:(void(^)(void))origBlock
               log:(NSString *)log {
    NSString *logStr = [NSString stringWithFormat:@"%@:%@", @"[task challenge]", log];
    [self internalURLSession:session
         didReceiveChallenge:challenge
           completionHandler:completionHandler
                   origBlock:origBlock
                         log:logStr];
}



#pragma mark - Private Methods


+ (void)internalURLSession:(NSURLSession *)session
      didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
        completionHandler:(void ( ^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
                 origBlock:(void(^)(void))origBlock
                       log:(NSString *)log {
    // 检查是否为服务器信任认证挑战
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"%@:[other auth]:%@-Method:%@", nj_logPrefix, log, challenge.protectionSpace.authenticationMethod);
        if (origBlock) {
            origBlock();
        }
        return;
    }
    
    // 读取Charles证书
    static NSData *localCertData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *certPath = NJAssetPath(charles-ssl-proxying-certificate.cer);
        localCertData = [NSData dataWithContentsOfFile:certPath];
    });
    
    // 判断是否是Charles证书
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFIndex certCount = SecTrustGetCertificateCount(serverTrust);
    // 证书链
    for (CFIndex i = 0; i < certCount; i++) {
        SecCertificateRef serverCert = SecTrustGetCertificateAtIndex(serverTrust, i);
        CFDataRef serverCertDataRef = SecCertificateCopyData(serverCert);
        NSData *serverCertData = (__bridge_transfer NSData *)serverCertDataRef;
        NSLog(@"%@:%@-localCertData:%@-serverCertData:%@", nj_logPrefix, log, localCertData, serverCertData);
        // 比较本地证书与服务器返回的证书
        if ([serverCertData isEqualToData:localCertData]) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            }
            NSLog(@"%@:[charles cer]:%@", nj_logPrefix, log);
            return;
        }
    }
    
    // 其他证书，走原有逻辑
    NSLog(@"%@:[other cer]:%@:", nj_logPrefix, log);
    if (origBlock) {
        origBlock();
    }
}


#pragma mark - Property Methods

@end
