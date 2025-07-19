

/*
 首页推荐帖子：https://frodo.douban.com/api/v2/elendil/recommend_feed
 书影音：https://frodo.douban.com/api/v2/movie/modules
 
 */


#import <UIKit/UIKit.h>
#import "NJCommonDefine.h"
#include <mach-o/dyld.h>
#import <CydiaSubstrate/CydiaSubstrate.h>
#import <dlfcn.h>


/*
%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSLog(@"%@:dataTaskWithRequest-block-%@-%p-%s-url:%@", nj_logPrefix, NSStringFromClass([self class]), self, __FUNCTION__, request.URL);
    return %orig;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request {
    NSLog(@"%@:dataTaskWithRequest-delegate-%@-%p-%s-%@-url:%@", nj_logPrefix, NSStringFromClass([self class]), self, __FUNCTION__, self.delegate, request.URL);
    return %orig;
}


%end
 */




// ASLR的偏移量
intptr_t g_slide;

//保存模块偏移基地址的值
static void _register_func_for_add_image(const struct mach_header *header, intptr_t slide) {
    Dl_info image_info;
    int result = dladdr(header, &image_info);
    if (result == 0) {
        NSLog(@"load mach_header failed");
        return;
    }
    //获取当前的可执行文件路径
    NSString *execName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSString *execPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", execName];
    if (strcmp([execPath UTF8String], image_info.dli_fname) == 0) {
        g_slide = slide;
        NSLog(@"[cxzcxz] g_slide:0x%lx", g_slide);
    }
    
    //如果需要获取可执行文件中引入的某一个模块(如你加入的XXX.dylib)在内存中的偏移量
    //则需要判断image_info.dli_fname中是否h包含字符串XXX.dylib
    // NSString *fname = [NSString stringWithUTF8String:image_info.dli_fname];
    // if ([fname containsString:@"NJHookSwiftProject.debug.dylib"]) {
    //     g_slide = slide;
    //     NSLog(@"[cxzcxz] g_slide:%ld", g_slide);
    // }
}

static void __attribute__((constructor)) __init__() {
       _dyld_register_func_for_add_image(_register_func_for_add_image);
}











