function RevMob(appId) {
	this.appId = appId;
	this.TEST_DISABLED = 0;
	this.TEST_WITH_ADS = 1;
	this.TEST_WITHOUT_ADS = 2;

	this.startSession = function(successCallback, errorCallback) {
    	cordova.exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
  	}

	this.showFullscreen = function(lockedOrientation, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showFullscreen", [lockedOrientation]);
	}

	this.loadFullscreen = function(lockedOrientation, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadFullscreen", [lockedOrientation]);
	}

	this.showLoadedFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showLoadedFullscreen", []);
	}

	this.loadVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadVideo", []);
	}

	this.showVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showVideo", []);
	}

	this.loadRewardedVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadRewardedVideo", []);
	}

	this.showRewardedVideo = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showRewardedVideo", []);
	}

	this.openLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openLink", []);
	}

	this.loadAdLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "loadAdLink", []);
	}

	this.openLoadedAdLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openLoadedAdLink", []);
	}

	this.showBanner = function(lockedOrientation, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showBanner", [lockedOrientation]);
	}

	this.hideBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideBanner", []);
	}

	this.showCustomBannerPos = function(lockedOrientation, x, y, w, h, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showCustomBannerPos", [lockedOrientation,x,y,w,h]);
	}

	this.hideCustomBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideCustomBanner", []);
	}

	this.printEnvironmentInformation = function() {
		cordova.exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
	}

	this.setTimeoutInSeconds = function(seconds) {
		cordova.exec(null, null, "RevMobPlugin", "setTimeoutInSeconds", [seconds]);
	}

	this.setUserAgeRangeMin = function(age, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "setUserAgeRangeMin", [age]);
	}

}

module.exports = RevMob
