/**
 * SplashScreen
 * 启动屏
 * from：http://www.devio.org
 * Author:CrazyCodeBoy
 * GitHub:https://github.com/crazycodeboy
 * Email:crazycodeboy@gmail.com
 */

#import "RNSplashScreen.h"
#import <React/RCTBridge.h>

const LOADING_VIEW_ZPOSITION = 1000;

static bool addedJsLoadErrorObserver = false;
static UIView* containerView = nil;
static UIView* loadingView = nil;

@implementation RNSplashScreen
- (dispatch_queue_t)methodQueue{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE(SplashScreen)

+ (void)addJsLoadErrorObserver {
    if (!addedJsLoadErrorObserver) {
        addedJsLoadErrorObserver = true;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsLoadError:) name:RCTJavaScriptDidFailToLoadNotification object:nil];
    }
}

+ (void)showSplash:(UIView*)splashScreen inRootView:(UIView*)rootView {
    [RNSplashScreen addJsLoadErrorObserver];

    if (!loadingView) {
        containerView = rootView;
        loadingView = splashScreen;
        CGRect frame = rootView.frame;
        frame.origin = CGPointMake(0, 0);
        loadingView.frame = frame;
        loadingView.layer.zPosition = LOADING_VIEW_ZPOSITION;
    }

    [loadingView removeFromSuperview];
    [rootView addSubview:loadingView];
}

+ (void)hide {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadingView removeFromSuperview];
    });
}

+ (void)jsLoadError:(NSNotification*)notification
{
    // If there was an error loading javascript, hide the splash screen so it can be shown.  Otherwise the splash screen will remain forever, which is a hassle to debug.
    [RNSplashScreen hide];
}

RCT_EXPORT_METHOD(hide) {
    [RNSplashScreen hide];
}

RCT_EXPORT_METHOD(show) {
    [RNSplashScreen showSplash:loadingView inRootView:containerView];
}

@end
