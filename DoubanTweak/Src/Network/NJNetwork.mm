#line 1 "/Users/touchworld/Documents/iOSDisassembler/hook/douban/DoubanTweak/DoubanTweak/Src/Network/NJNetwork.xm"









#import <UIKit/UIKit.h>
#import "NJCommonDefine.h"
#include <mach-o/dyld.h>
#import <CydiaSubstrate/CydiaSubstrate.h>
#import <dlfcn.h>
























intptr_t g_slide;


static void _register_func_for_add_image(const struct mach_header *header, intptr_t slide) {
    Dl_info image_info;
    int result = dladdr(header, &image_info);
    if (result == 0) {
        NSLog(@"load mach_header failed");
        return;
    }
    
    NSString *execName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSString *execPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@", execName];
    if (strcmp([execPath UTF8String], image_info.dli_fname) == 0) {
        g_slide = slide;
        NSLog(@"[cxzcxz] g_slide:0x%lx", g_slide);
    }
    
    
    
    
    
    
    
    
}

static void __attribute__((constructor)) __init__() {
       _dyld_register_func_for_add_image(_register_func_for_add_image);
}











