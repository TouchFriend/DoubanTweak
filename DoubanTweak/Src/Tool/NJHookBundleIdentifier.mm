#line 1 "/Users/touchworld/Documents/iOSDisassembler/hook/douban/DoubanTweak/DoubanTweak/Src/Tool/NJHookBundleIdentifier.xm"


#import <Foundation/Foundation.h>


static NSString * const kFakeBundleID = @"com.douban.frodo";

static NSString * const kBundleIDSuffix = @".dddd";

static NSString *gMainBundlePath = nil;

static NSString *gOriginalBundleID = nil;

#pragma mark - Utils




static BOOL IsMainBundle(NSBundle *bundle)
{
    if (!bundle || !gMainBundlePath) {
        return NO;
    }

    NSString *bundlePath = bundle.bundlePath;

    if (!bundlePath) {
        return NO;
    }

    return [bundlePath isEqualToString:gMainBundlePath];
}



static BOOL ShouldHookBundle(NSBundle *bundle)
{
    if (!IsMainBundle(bundle)) {
        return NO;
    }

    if (gOriginalBundleID.length == 0) {
        return NO;
    }

    
    return [gOriginalBundleID hasSuffix:kBundleIDSuffix];
}

#pragma mark - NSBundle


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"");

@class NSBundle; 
static NSDictionary * (*_logos_orig$_ungrouped$NSBundle$infoDictionary)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSDictionary * _logos_method$_ungrouped$NSBundle$infoDictionary(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); 

#line 52 "/Users/touchworld/Documents/iOSDisassembler/hook/douban/DoubanTweak/DoubanTweak/Src/Tool/NJHookBundleIdentifier.xm"



























static NSDictionary * _logos_method$_ungrouped$NSBundle$infoDictionary(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *origDict = _logos_orig$_ungrouped$NSBundle$infoDictionary(self, _cmd);

    if (!ShouldHookBundle(self)) {
        return origDict;
    }

    NSMutableDictionary *dict = [origDict mutableCopy];

    if (dict) {
        dict[@"CFBundleIdentifier"] = kFakeBundleID;
    }



    return dict ?: origDict;
}





















#pragma mark - Constructor

static __attribute__((constructor)) void _logosLocalCtor_5ef05993(int __unused argc, char __unused **argv, char __unused **envp)
{
    @autoreleasepool {

        NSBundle *mainBundle = [NSBundle mainBundle];

        gMainBundlePath = [[mainBundle bundlePath] copy];
        gOriginalBundleID = [[mainBundle bundleIdentifier] copy];

        NSLog(@"[BundleHook] MainBundlePath: %@", gMainBundlePath);
        NSLog(@"[BundleHook] OriginalBundleID: %@", gOriginalBundleID);

        if ([gOriginalBundleID hasSuffix:kBundleIDSuffix]) {
            NSLog(@"[BundleHook] Hook Enabled");
            NSLog(@"[BundleHook] FakeBundleID: %@", kFakeBundleID);
        } else {
            NSLog(@"[BundleHook] Hook Disabled");
        }
    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSBundle = objc_getClass("NSBundle"); { MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(infoDictionary), (IMP)&_logos_method$_ungrouped$NSBundle$infoDictionary, (IMP*)&_logos_orig$_ungrouped$NSBundle$infoDictionary);}} }
#line 139 "/Users/touchworld/Documents/iOSDisassembler/hook/douban/DoubanTweak/DoubanTweak/Src/Tool/NJHookBundleIdentifier.xm"
