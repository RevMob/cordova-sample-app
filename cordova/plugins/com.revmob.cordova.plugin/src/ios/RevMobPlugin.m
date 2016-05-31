#import "RevMobPlugin.h"

@interface RevMobAds ()
    + (RevMobAds *)sharedObject;
@end


@implementation RevMobPlugin
@synthesize sessionCommand;

RevMobFullscreen *fullscreenAd, *video, *rewardedVideo;
RevMobAdLink *adLink;

- (void)startSession:(CDVInvokedUrlCommand*)command {

    CDVPluginResult* pluginResult = nil;
    self.sessionCommand = command;
    @try {
        NSString* appId = [command.arguments objectAtIndex:0];
        if (appId != nil && [appId length] > 0) {
            [RevMobAds startSessionWithAppID:appId
                          withSuccessHandler:^{
                              [self eventCallbackSuccess:@"SESSION_STARTED" :command];
                          } andFailHandler:^(NSError *error) {
                              [self eventCallbackError:@"SESSION_NOT_STARTED" :command];
                          }];
        }
    } @catch (NSException* exception) {
      [self eventCallbackError:@"SESSION_NOT_STARTED" :command];
        NSLog(@"Session not started");
    }

}


- (void)showFullscreen:(CDVInvokedUrlCommand*)command {
    RevMobFullscreen *fs = [[RevMobAds session] fullscreen];
    fs.delegate = self;

    NSArray *arr = command.arguments;
    NSArray *x = [arr objectAtIndex:0];

    NSMutableArray *arrayOfOrientations = nil;
    arrayOfOrientations = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i< [x count]; i++){

        if( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortrait" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeRight" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeLeft" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];

        }
    }

    fs.supportedInterfaceOrientations = arrayOfOrientations;

    [fs loadWithSuccessHandler:^(RevMobFullscreen *fs) {
      [self eventCallbackSuccess:@"FULLSCREEN_RECEIVED" :command];
      [fs showAd];
      [self eventCallbackSuccess:@"FULLSCREEN_DISPLAYED" :command];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        [self eventCallbackError:@"FULLSCREEN_NOT_RECEIVED" :command];
    } onClickHandler:^{
        [self eventCallbackSuccess:@"FULLSCREEN_CLICKED" :command];
    } onCloseHandler:^{
        [self eventCallbackSuccess:@"FULLSCREEN_DISMISSED" :command];
    }];
}

- (void)loadFullscreen:(CDVInvokedUrlCommand*)command {
    self.fullscreenAd = [[RevMobAds session] fullscreen];
    self.fullscreenAd.delegate = self;

    NSArray *arr = command.arguments;
    NSArray *x = [arr objectAtIndex:0];

    NSMutableArray *arrayOfOrientations = nil;
    arrayOfOrientations = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i< [x count]; i++){

        if( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortrait" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeRight" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeLeft" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];

        }
    }

    self.fullscreenAd.supportedInterfaceOrientations = arrayOfOrientations;

    [self.fullscreenAd loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs loadAd];
        [self eventCallbackSuccess:@"LOAD_FULLSCREEN_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        [self eventCallbackError:@"LOAD_FULLSCREEN_NOT_RECEIVED" :command];
    } onClickHandler:^{
        [self eventCallbackSuccess:@"LOAD_FULLSCREEN_CLICKED" :command];
    } onCloseHandler:^{
        [self eventCallbackSuccess:@"LOAD_FULLSCREEN_DISMISSED" :command];
    }];

}

- (void)showLoadedFullscreen:(CDVInvokedUrlCommand*)command{
    if (self.fullscreenAd != nil){
      [self.fullscreenAd showAd];
      [self eventCallbackSuccess:@"LOAD_FULLSCREEN_DISPLAYED" :command];
    }
}

-(void) loadVideo:(CDVInvokedUrlCommand*)command {
    self.video = [[RevMobAds session] fullscreen];
    self.video.delegate = self;
    [self.video loadVideo];
  }

-(void) showVideo:(CDVInvokedUrlCommand*)command{
    if(self.video != nil) [self.video showVideo];
}

-(void) loadRewardedVideo:(CDVInvokedUrlCommand*)command {
    self.rewardedVideo = [[RevMobAds session] fullscreen];
    self.rewardedVideo.delegate = self;
    [self.rewardedVideo loadRewardedVideo];

}

-(void) showRewardedVideo:(CDVInvokedUrlCommand*)command{
    if(self.rewardedVideo != nil) [self.rewardedVideo showRewardedVideo];
}

- (void)showBanner:(CDVInvokedUrlCommand*)command {

    NSArray *arr = command.arguments;
    NSArray *x = [arr objectAtIndex:0];

  if(self.bannerWindow != nil){
    [self.bannerWindow showAd];
  }else{

    self.bannerWindow = [[RevMobAds session] banner];
    self.bannerWindow.delegate = self;
    NSMutableArray *arrayOfOrientations = nil;
    arrayOfOrientations = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i< [x count]; i++){

        if( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortrait" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeRight" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];

        }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeLeft" ]){
            [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];

        }
    }

    self.bannerWindow.supportedInterfaceOrientations = arrayOfOrientations;
      [self.bannerWindow loadWithSuccessHandler:^(RevMobBanner *banner) {
        [self eventCallbackSuccess:@"BANNER_RECEIVED" :command];
          [banner showAd];
        [self eventCallbackSuccess:@"BANNER_DISPLAYED" :command];
      } andLoadFailHandler:^(RevMobBanner *banner, NSError *error) {
          [self eventCallbackError:@"BANNER_NOT_RECEIVED" :command];
      } onClickHandler:^(RevMobBanner *banner) {
          [self eventCallbackSuccess:@"BANNER_CLICKED" :command];
      }];
 }
}

- (void)showCustomBannerPos:(CDVInvokedUrlCommand*)command {
  NSArray *arr = command.arguments;
    NSArray *x = [arr objectAtIndex:0];

    if(self.customBannerWindow != nil){
      [self.customBannerWindow showAd];
    }else{
    self.customBannerWindow = [[RevMobAds session] banner];
    self.customBannerWindow.delegate = self;
        NSMutableArray *arrayOfOrientations = nil;
        arrayOfOrientations = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i=0; i< [x count]; i++){

            if( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortrait" ]){
                [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];

            }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown" ]){
                [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];

            }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeRight" ]){
                [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];

            }else if ( [ [x objectAtIndex:i] isEqualToString:@"UIInterfaceOrientationLandscapeLeft" ]){
                [arrayOfOrientations addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];

            }
        }

    self.customBannerWindow.supportedInterfaceOrientations = arrayOfOrientations;
    CGFloat x = [[arr objectAtIndex:1] floatValue];
    CGFloat y = [[arr objectAtIndex:2] floatValue];
    CGFloat w = [[arr objectAtIndex:3] floatValue];
    CGFloat h = [[arr objectAtIndex:4] floatValue];
    [self.customBannerWindow setFrame:CGRectMake(x, y, w, h)];
        [self.customBannerWindow loadWithSuccessHandler:^(RevMobBanner *banner) {
          [self eventCallbackSuccess:@"CUSTOM_BANNER_RECEIVED" :command];
          [banner showAd];
          [self eventCallbackSuccess:@"CUSTOM_BANNER_DISPLAYED" :command];
        } andLoadFailHandler:^(RevMobBanner *banner, NSError *error) {
            [self eventCallbackError:@"CUSTOM_BANNER_NOT_RECEIVED" :command];
        } onClickHandler:^(RevMobBanner *banner) {
            [self eventCallbackSuccess:@"CUSTOM_BANNER_CLICKED" :command];
        }];
    }
}

- (void)hideBanner:(CDVInvokedUrlCommand*)command {
  if(self.bannerWindow != nil){
   [self.bannerWindow hideAd];
   self.bannerWindow = nil;
 }
}

- (void)hideCustomBanner:(CDVInvokedUrlCommand*)command {
  if(self.customBannerWindow != nil){
    [self.customBannerWindow hideAd];
    self.customBannerWindow = nil;
  }
}

- (void)openLink:(CDVInvokedUrlCommand *)command {
    RevMobAdLink *link = [[RevMobAds session] adLink];
    link.delegate = self;
    [link loadWithSuccessHandler:^(RevMobAdLink *link) {
        [link openLink];
        [self eventCallbackSuccess:@"NATIVE_LINK_CLICKED" :command];
    } andLoadFailHandler:^(RevMobAdLink *link, NSError *error) {
        [self eventCallbackError:@"NATIVE_LINK_NOT_RECEIVED" :command];
    }];
}

- (void)loadAdLink:(CDVInvokedUrlCommand *)command {
  self.adLink = [[RevMobAds session] adLink];
  self.adLink.delegate = self;
  [self.adLink loadWithSuccessHandler:^(RevMobAdLink *link) {
        [self eventCallbackSuccess:@"LOAD_NATIVE_LINK_RECEIVED" :command];
    } andLoadFailHandler:^(RevMobAdLink *link, NSError *error) {
        [self eventCallbackError:@"LOAD_NATIVE_LINK_NOT_RECEIVED" :command];
    }];
}

- (void)openLoadedAdLink:(CDVInvokedUrlCommand *)command {
    if (self.adLink != nil){
      [self eventCallbackSuccess:@"LOAD_NATIVE_LINK_CLICKED" :command];
      [self.adLink openLink];
    }
}

- (void)setUserAgeRangeMin:(CDVInvokedUrlCommand*)command {
      CDVPluginResult* pluginResult = nil;
      @try {
          NSUInteger age = [[command.arguments objectAtIndex:0] intValue];
          [RevMobAds session].userAgeRangeMin = age;
      } @catch (NSException* exception) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

- (void)setTimeoutInSeconds:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;

    @try {
        NSUInteger time = [[command.arguments objectAtIndex:0] intValue];
        [RevMobAds session].connectionTimeout = time;
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_JSON_EXCEPTION messageAsString:[exception reason]];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)printEnvironmentInformation:(CDVInvokedUrlCommand *)command {
    [[RevMobAds session] printEnvironmentInformation];
}

- (void)eventCallbackSuccess:(NSString*)event :(CDVInvokedUrlCommand*)command {
    NSDictionary* data = [self getResultString:event];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}


- (void)eventCallbackError:(NSString*)event :(CDVInvokedUrlCommand*)command {
    NSDictionary* data = [self getResultString:event];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:data];
    [pluginResult setKeepCallbackAsBool:YES];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];}

- (NSDictionary*)getResultString:(NSString*)event {
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:1];
    [data setObject:event forKey:@"RevMobAdsEvent"];
    return data;
}

#pragma mark - RevMobAdsDelegate methods


/////Session Listeners/////
- (void)revmobSessionDidStart {
    NSLog(@"[RevMob Sample App] Session started with delegate!");
}

- (void)revmobSessionDidNotStart:(NSError *)error {
    NSLog(@"[RevMob Sample App] Session not started with error: %@", error);
}

/////Native ads Listeners/////

-(void) revmobUserDidClickOnNative:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User clicked on Native.");
}
-(void) revmobNativeDidReceive:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Native loaded.");
}
-(void) revmobNativeDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Native failed: %@. ID: %@", error, placementId);
}



/////Fullscreen Listeners/////

-(void) revmobUserDidClickOnFullscreen:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User clicked in the Fullscreen.");
}
-(void) revmobFullscreenDidReceive:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen loaded.");
}
-(void) revmobFullscreenDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen failed: %@. ID: %@", error, placementId);
}
-(void) revmobFullscreenDidDisplay:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Fullscreen displayed.");
}
-(void) revmobUserDidCloseFullscreen:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User closed the fullscreen.");
}

///Banner Listeners///

-(void) revmobUserDidClickOnBanner:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] User clicked in the Banner.");
}
-(void) revmobBannerDidReceive:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner loaded.");
}
-(void) revmobBannerDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner failed: %@. ID: %@", error, placementId);
}
-(void) revmobBannerDidDisplay:(NSString *)placementId{
    NSLog(@"[RevMob Sample App] Banner displayed.");
}

/////Video Listeners/////
-(void)revmobVideoDidLoad:(NSString *)placementId {
    [self eventCallbackSuccess:@"VIDEO_LOADED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video loaded.");
}

-(void) revmobVideoDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId{
    [self eventCallbackError:@"VIDEO_DID_FAIL_WITH_ERROR" :self.sessionCommand];
    NSLog(@"[RevMob Sample App) Video failed with error: %@", error.localizedDescription);
}

-(void)revmobVideoNotCompletelyLoaded:(NSString *)placementId {
    [self eventCallbackError:@"VIDEO_NOT_COMPLETELY_LOADED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video not completely loaded.");
}

-(void)revmobVideoDidStart:(NSString *)placementId {
    [self eventCallbackSuccess:@"VIDEO_DID_START" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video started.");
}

-(void)revmobVideoDidFinish:(NSString *)placementId {
    [self eventCallbackSuccess:@"VIDEO_DID_FINISH" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video finished.");
}

-(void) revmobUserDidCloseVideo:(NSString *)placementId{
    [self eventCallbackSuccess:@"VIDEO_DID_CLOSE_VIDEO" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video closed.");
}

-(void) revmobUserDidClickOnVideo:(NSString *)placementId{
    [self eventCallbackSuccess:@"VIDEO_DID_CLICK_ON_VIDEO" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Video clicked.");
}


/////Rewarded Video Listeners/////
-(void)revmobRewardedVideoDidLoad:(NSString *)placementId {
    [self eventCallbackSuccess:@"REWARDED_VIDEO_LOADED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Rewarded Video loaded.");
}

-(void)revmobRewardedVideoDidFailWithError:(NSError *)error onPlacement:(NSString *)placementId {
    [self eventCallbackError:@"REWARDED_VIDEO_FAILED_TO_LOAD" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Rewarded Video failed to load.");
}

-(void)revmobRewardedVideoNotCompletelyLoaded:(NSString *)placementId {
    [self eventCallbackError:@"REWARDED_VIDEO_NOT_COMPLETELY_LOADED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Rewarded Video not completely loaded.");
}

-(void)revmobRewardedVideoDidStart:(NSString *)placementId {
    [self eventCallbackSuccess:@"REWARDED_VIDEO_STARTED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Rewarded Video started.");
}

-(void)revmobRewardedVideoDidComplete:(NSString *)placementId {
    [self eventCallbackSuccess:@"REWARDED_VIDEO_COMPLETED" :self.sessionCommand];
    NSLog(@"[RevMob Sample App] Rewarded Video completed.");
}



@end
