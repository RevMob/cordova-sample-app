package com.revmob.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.*;
import java.io.*;

import android.util.DisplayMetrics;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.view.Gravity;
import android.app.Activity;
import android.content.Context;

import com.revmob.RevMob;
import com.revmob.RevMobAdsListener;
import com.revmob.RevMobTestingMode;
import com.revmob.ads.interstitial.RevMobFullscreen;
import com.revmob.client.RevMobClient;
import com.revmob.ads.link.RevMobLink;
import com.revmob.ads.banner.RevMobBanner;

public class RevMobPlugin extends CordovaPlugin {
	private RevMob revmob;
  private RevMobLink link;

	private static RelativeLayout bannerLayout;
	private static RelativeLayout customBannerLayout;

	private static RevMobBanner customBannerAd;
	private static RevMobBanner bannerAd;
	private static RelativeLayout.LayoutParams bannerParams;
	private static Activity customBannerActivity;
	private static Activity bannerActivity;

	private RevMobFullscreen video, fullscreen, rewardedVideo;
	private CallbackContext lastCallbackContext = null;

	@Override
	public boolean execute(String action, final JSONArray args, CallbackContext callbackContext) throws JSONException {
		Log.i("[RevMobPlugin]", action);
		if (action.equals("startSession")) {
			setCallbackContext(callbackContext);
      startSession(args.getString(0));
			return true;
		}
		if (revmob == null) {
			return error(callbackContext, "Session has not been started. Call the startSession method.");
		}
		if (action.equals("showFullscreen")) {
			setCallbackContext(callbackContext);
			showFullscreen();
			return true;
		}
		if (action.equals("loadFullscreen")) {
			setCallbackContext(callbackContext);
			loadFullscreen();
			return true;
		}
		if (action.equals("showLoadedFullscreen")) {
			setCallbackContext(callbackContext);
			showLoadedFullscreen();
			return true;
		}
		if (action.equals("showBanner")) {
			setCallbackContext(callbackContext);
			showBanner();
			return true;
		}
		if (action.equals("showCustomBannerPos")) {
 			setCallbackContext(callbackContext);
      cordova.getActivity().runOnUiThread(new Runnable() {
      	public void run() {
      		showCustomBannerPos(args);
      	}
      });
 			return true;
 		}
		if (action.equals("hideBanner")) {
			setCallbackContext(callbackContext);
			hideBanner();
			return true;
		}
		if (action.equals("hideCustomBanner")) {
			setCallbackContext(callbackContext);
			hideCustomBanner();
			return true;
		}
		if (action.equals("openLink")) {
			setCallbackContext(callbackContext);
			openLink();
			return true;
		}
		if (action.equals("loadAdLink")) {
			setCallbackContext(callbackContext);
			loadAdLink();
			return true;
		}
		if (action.equals("openLoadedAdLink")) {
			setCallbackContext(callbackContext);
			openLoadedAdLink();
			return true;
		}
		if (action.equals("printEnvironmentInformation")) {
			printEnvironmentInformation();
			return success(callbackContext);
		}
		if (action.equals("setTimeoutInSeconds")) {
			setTimeoutInSeconds(args.getInt(0));
			return success(callbackContext);
		}
		if (action.equals("showVideo")) {
			setCallbackContext(callbackContext);
			showVideo();
			return true;
		}
		if (action.equals("loadVideo")) {
			setCallbackContext(callbackContext);
			loadVideo();
			return true;
		}
		if (action.equals("loadRewardedVideo")) {
			setCallbackContext(callbackContext);
			loadRewardedVideo();
			return true;
		}
		if (action.equals("showRewardedVideo")) {
			setCallbackContext(callbackContext);
			showRewardedVideo();
			return true;
		}
		if (action.equals("setUserAgeRangeMin")) {
			setCallbackContext(callbackContext);
			cordova.getActivity().runOnUiThread(new Runnable() {
      	public void run() {
					setUserAgeRangeMin(args);
      	}
      });
 			return true;
		}
		return error(callbackContext, "Invalid method call: " + action);
	}

	private boolean error(CallbackContext callbackContext, String message) {
		Log.e("[RevMobPlugin]", message);
		if (callbackContext != null) {
			callbackContext.error(message);
		}
		return false;
	}

	private boolean success(CallbackContext callbackContext) {
		if (callbackContext != null) {
			callbackContext.success();
		}
		return true;
	}

	private void startSession(String appId) {
		revmob = RevMob.startWithListenerForWrapper(cordova.getActivity(), appId, new RevMobAdsListener() {

			public void onRevMobSessionIsStarted() {
				eventCallbackSuccess("SESSION_STARTED");
			}
			public void onRevMobSessionNotStarted(String message) {
				eventCallbackError("SESSION_NOT_STARTED - With error: "+message);
			}
		});
	}

	private void showFullscreen() {
		revmob.showFullscreen(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdReceived() {
				eventCallbackSuccess("FULLSCREEN_RECEIVED");
			}
			public void onRevMobAdDismissed() {
				eventCallbackSuccess("FULLSCREEN_DISMISSED");
			}
			public void onRevMobAdClicked() {
				eventCallbackSuccess("FULLSCREEN_CLICKED");
			}
			public void onRevMobAdDisplayed() {
				eventCallbackSuccess("FULLSCREEN_DISPLAYED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("FULLSCREEN_NOT_RECEIVED - With error: "+message);
			}
		});
	}

	private void loadFullscreen() {
		fullscreen = revmob.createFullscreen(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdReceived() {
				eventCallbackSuccess("LOAD_FULLSCREEN_RECEIVED");
			}
			public void onRevMobAdDismissed() {
				eventCallbackSuccess("LOAD_FULLSCREEN_DISMISSED");
			}
			public void onRevMobAdClicked() {
				eventCallbackSuccess("LOAD_FULLSCREEN_CLICKED");
			}
			public void onRevMobAdDisplayed() {
				eventCallbackSuccess("LOAD_FULLSCREEN_DISPLAYED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("LOAD_FULLSCREEN_NOT_RECEIVED - With error: "+message);
			}
		});
	}

	private void showLoadedFullscreen() {
		if(fullscreen != null)
			fullscreen.show();
	}

	private void loadVideo() {
		video = revmob.createVideo(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdDismissed() {
				eventCallbackSuccess("VIDEO_DID_CLOSE_VIDEO");
			}
			public void onRevMobAdClicked() {
				eventCallbackSuccess("VIDEO_DID_CLICK_ON_VIDEO");
			}
			public void onRevMobVideoLoaded() {
				eventCallbackSuccess("VIDEO_LOADED");
			}
			public void onRevMobVideoStarted() {
				eventCallbackSuccess("VIDEO_DID_START");
			}
			public void onRevMobVideoFinished() {
				eventCallbackSuccess("VIDEO_DID_FINISH");
			}
			public void onRevMobVideoNotCompletelyLoaded() {
				eventCallbackError("VIDEO_NOT_COMPLETELY_LOADED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("VIDEO_DID_FAIL_WITH_ERROR - With error: "+message);
			}
		});
	}

	private void showVideo() {
		if(video != null)
			video.showVideo();
	}

	private void loadRewardedVideo() {
		rewardedVideo = revmob.createRewardedVideo(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobRewardedVideoLoaded() {
				eventCallbackSuccess("REWARDED_VIDEO_LOADED");
			}
			public void onRevMobRewardedVideoStarted() {
				eventCallbackSuccess("REWARDED_VIDEO_STARTED");
			}
			public void onRevMobRewardedVideoCompleted() {
				eventCallbackSuccess("REWARDED_VIDEO_COMPLETED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("REWARDED_VIDEO_FAILED_TO_LOAD - With error: "+message);
			}
			public void onRevMobRewardedVideoNotCompletelyLoaded() {
				eventCallbackError("REWARDED_VIDEO_NOT_COMPLETELY_LOADED");
			}
		});
	}

	private void showRewardedVideo() {
		if(rewardedVideo != null)
			rewardedVideo.showRewardedVideo();
	}

	private void showBanner() {
		if (bannerAd != null) {
			hideBanner(bannerActivity);
		}

		cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					DisplayMetrics metrics = new DisplayMetrics();
					int displayWidth = cordova.getActivity().getWindowManager().getDefaultDisplay().getWidth();
					int displayHeight = cordova.getActivity().getWindowManager().getDefaultDisplay().getHeight();
					((Activity) cordova.getActivity()).getWindowManager().getDefaultDisplay().getMetrics(metrics);
					int width;
					if(displayWidth < displayHeight){
						width = (int) (displayWidth / metrics.density);
					} else {
						width = (int) (displayHeight / metrics.density);
					}
					RevMobBanner.DEFAULT_WIDTH_IN_DIP = width;

					int idealHeight = dipToPixels(cordova.getActivity(), RevMobBanner.DEFAULT_HEIGHT_IN_DIP);

					width = dipToPixels(cordova.getActivity(), width);

					bannerLayout = new RelativeLayout(cordova.getActivity());
					bannerParams = new RelativeLayout.LayoutParams(width, idealHeight);
					bannerParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
					bannerLayout.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);

					bannerAd = revmob.createBanner(cordova.getActivity(), new RevMobAdsListener() {
						public void onRevMobAdReceived() {
							eventCallbackSuccess("BANNER_RECEIVED");
						}
						public void onRevMobAdNotReceived(String message) {
							eventCallbackError("BANNER_NOT_RECEIVED - With error: "+message);
						}
						public void onRevMobAdClicked() {
							eventCallbackSuccess("BANNER_CLICKED");
						}
						public void onRevMobAdDisplayed() {
							eventCallbackSuccess("BANNER_DISPLAYED");
						}
					});

					cordova.getActivity().addContentView(bannerLayout, new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.FILL_PARENT,RelativeLayout.LayoutParams.FILL_PARENT));

					bannerLayout.addView(bannerAd, bannerParams);
					bannerActivity = cordova.getActivity();

				} catch (Exception e) {
				}
		}
	});
	}
	private void hideBanner(final Activity activity) {
		activity.runOnUiThread(new Runnable() {
				public void run() {
						try {
								if (bannerLayout.getParent() != null)
										((ViewGroup) bannerLayout.getParent()).removeView(bannerLayout);
								bannerLayout.removeView(bannerAd);
								bannerLayout.setVisibility(View.GONE);
								bannerLayout = null;
								bannerAd = null;
								bannerActivity = null;
						} catch (Exception e) {

						}
				}
		});
	}
	private void hideBanner() {
		cordova.getActivity().runOnUiThread(new Runnable() {
				public void run() {
						try {
								if (bannerLayout.getParent() != null)
										((ViewGroup) bannerLayout.getParent()).removeView(bannerLayout);
								bannerLayout.removeView(bannerAd);
								bannerLayout.setVisibility(View.GONE);
								bannerLayout = null;
								bannerAd = null;
								bannerActivity = null;
						} catch (Exception e) {

						}
				}
		});
	}
	private void showCustomBannerPos(final JSONArray args) {
		if (customBannerAd != null) {
			hideCustomBanner(customBannerActivity);
		}
		customBannerAd = revmob.createBanner(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdReceived() {
				eventCallbackSuccess("CUSTOM_BANNER_RECEIVED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("CUSTOM_BANNER_NOT_RECEIVED - With error: "+message);
			}
			public void onRevMobAdClicked() {
				eventCallbackSuccess("CUSTOM_BANNER_CLICKED");
			}
			public void onRevMobAdDisplayed() {
				eventCallbackSuccess("CUSTOM_BANNER_DISPLAYED");
			}
		});

		cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
						customBannerLayout = new RelativeLayout(cordova.getActivity().getApplicationContext());
						bannerParams = new RelativeLayout.LayoutParams(args.getInt(3), args.getInt(4));
						if (args.getInt(1) != 0 || args.getInt(2) != 0 || args.getInt(3) !=
						dipToPixels(cordova.getActivity(), RevMobBanner.DEFAULT_WIDTH_IN_DIP) || args.getInt(4) != dipToPixels(cordova.getActivity(), RevMobBanner.DEFAULT_HEIGHT_IN_DIP)) {
								bannerParams.leftMargin = args.getInt(1);
								bannerParams.topMargin = args.getInt(2);
								bannerParams.width = args.getInt(3);
								bannerParams.height = args.getInt(4);
						} else {
								bannerParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
								customBannerLayout.setGravity(Gravity.TOP | Gravity.CENTER_HORIZONTAL);
						}
						cordova.getActivity().addContentView(customBannerLayout, new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.FILL_PARENT,RelativeLayout.LayoutParams.FILL_PARENT));
						customBannerLayout.addView(customBannerAd, bannerParams);
						customBannerActivity = cordova.getActivity();
				} catch (Exception e) {
				}
			}
		});
	}

	private void hideCustomBanner(final Activity activity) {
		activity.runOnUiThread(new Runnable() {
				public void run() {
						try {
								if (customBannerLayout.getParent() != null)
										((ViewGroup) customBannerLayout.getParent()).removeView(customBannerLayout);
								customBannerLayout.removeView(customBannerAd);
								customBannerLayout.setVisibility(View.GONE);
								customBannerLayout = null;
								customBannerAd = null;
								customBannerActivity = null;
						} catch (Exception e) {
						}
				}
		});
	}
	private void hideCustomBanner() {
		cordova.getActivity().runOnUiThread(new Runnable() {
				public void run() {
						try {
								if (customBannerLayout.getParent() != null)
										((ViewGroup) customBannerLayout.getParent()).removeView(customBannerLayout);
								customBannerLayout.removeView(customBannerAd);
								customBannerLayout.setVisibility(View.GONE);
								customBannerLayout = null;
								customBannerAd = null;
								customBannerActivity = null;
						} catch (Exception e) {
						}
				}
		});
	}

	private void openLink() {
		revmob.openLink(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdClicked() {
				eventCallbackSuccess("NATIVE_LINK_CLICKED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("NATIVE_LINK_NOT_RECEIVED - With error: "+message);
			}
		});
	}

	private void loadAdLink() {
		link = revmob.createLink(cordova.getActivity(), new RevMobAdsListener() {
			public void onRevMobAdClicked() {
				eventCallbackSuccess("LOAD_NATIVE_LINK_CLICKED");
			}
			public void onRevMobAdReceived() {
				eventCallbackSuccess("LOAD_NATIVE_LINK_RECEIVED");
			}
			public void onRevMobAdNotReceived(String message) {
				eventCallbackError("LOAD_NATIVE_LINK_NOT_RECEIVED - With error: "+message);
			}
		});
	}

	private void openLoadedAdLink() {
		if(link != null)
			link.open();
	}

	private void printEnvironmentInformation() {
		revmob.printEnvironmentInformation(cordova.getActivity());
	}

	private void setUserAgeRangeMin(final JSONArray args) {
		cordova.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					revmob.setUserAgeRangeMin(args.getInt(0));
				} catch (Exception e) {
				}
			}
		});
	}

	private void setTimeoutInSeconds(int seconds) {
		revmob.setTimeoutInSeconds(seconds);
	}

	private JSONObject getResultString(String event) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("RevMobAdsEvent", event);
        } catch (JSONException e) {
            Log.e("[RevMobPlugin]", e.getMessage(), e);
        }
        return obj;
    }

	private void setCallbackContext(CallbackContext callbackContext) {
		PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        lastCallbackContext = callbackContext;
	}

	private void eventCallbackSuccess(String event) {
		Log.w("[RevMobPlugin]", event);
		if (lastCallbackContext != null) {
			PluginResult result = new PluginResult(PluginResult.Status.OK, getResultString(event));
	        result.setKeepCallback(true);
	        lastCallbackContext.sendPluginResult(result);
		}
	}

	private void eventCallbackError(String error) {
		Log.e("[RevMobPlugin]", error);
		if (lastCallbackContext != null) {
			PluginResult result = new PluginResult(PluginResult.Status.ERROR, getResultString(error));
	    result.setKeepCallback(true);
	    lastCallbackContext.sendPluginResult(result);
		}
	}
	public static int dipToPixels(Context context, int dip) {
			final float scale = context.getResources().getDisplayMetrics().density;
			return (int) (dip * scale + 0.5f);
	}
}
