#import <Foundation/Foundation.h>
#import <RevMobAds/RevMobAds.h>
#import <Cordova/CDVPlugin.h>
#import <RevMobAds/RevMobAdsDelegate.h>


@interface RevMobPlugin : CDVPlugin <RevMobAdsDelegate>

@property (nonatomic, strong)RevMobBannerView *banner;
@property (nonatomic, strong)RevMobBanner *bannerWindow;
@property (nonatomic, strong)RevMobBanner *customBannerWindow;
@property (nonatomic, strong)RevMobFullscreen *fullscreenAd;
@property (nonatomic, strong)RevMobFullscreen *video;
@property (nonatomic, strong)RevMobFullscreen *rewardedVideo;
@property (nonatomic, strong)RevMobAdLink *adLink;

- (void) startSession:(CDVInvokedUrlCommand*)command;

- (void) openLink:(CDVInvokedUrlCommand*)command;

- (void) loadAdLink:(CDVInvokedUrlCommand*)command;

- (void) openLoadedAdLink:(CDVInvokedUrlCommand*)command;

- (void) showBanner:(CDVInvokedUrlCommand*)command;

- (void) hideBanner:(CDVInvokedUrlCommand*)command;

- (void)showCustomBannerPos:(CDVInvokedUrlCommand*)command;

- (void)hideCustomBanner:(CDVInvokedUrlCommand*)command;

- (void) loadFullscreen:(CDVInvokedUrlCommand*)command;

- (void) showFullscreen:(CDVInvokedUrlCommand*)command;

- (void) showLoadedFullscreen:(CDVInvokedUrlCommand*)command;

- (void) loadVideo:(CDVInvokedUrlCommand*)command;

- (void) showVideo:(CDVInvokedUrlCommand*)command;

- (void) loadRewardedVideo:(CDVInvokedUrlCommand*)command;

- (void) showRewardedVideo:(CDVInvokedUrlCommand*)command;

- (void) printEnvironmentInformation:(CDVInvokedUrlCommand*)command;

- (void) setTimeoutInSeconds:(CDVInvokedUrlCommand*)command;

- (void) setUserAgeRangeMin:(CDVInvokedUrlCommand*)command;

@property (nonatomic, strong)CDVInvokedUrlCommand *sessionCommand;

@end
