import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Api.dart';

class AppAds {
  AppAds();
  RemoteConfig config = RemoteConfig.instance;

  getMainBanner(size) {
    switch (config.getString("driver")) {
      case "facebook":
        {
          return getFacebookBanner();
        }
      case "google":
        {
          return getAdmobBanner(size);
        }
    }
  }

  loadInterstitial() {
    switch (config.getString("driver")) {
      case "facebook":
        {
          return showFacebookIntestitial();
        }
      case "google":
        {
          return showGoogleInterstitial();
        }
    }
  }

  showFacebookIntestitial() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: kReleaseMode
          ? config.getString("facebook_interstitial")
          : F_PREFIX_DEV + "677089553262613_677102719927963",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd();
      },
    );
  }

  showGoogleInterstitial() {
    InterstitialAd.load(
        adUnitId: kReleaseMode
            ? config.getString("google_interstitial")
            : ADMOB_INTERSTITIAL_TEST,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  getNativeBanner(size) {
    switch (config.getString("driver")) {
      case "facebook":
        {
          return getNativeFacebook(size);
        }
      case "google":
        {
          return getAdmobBanner(size);
        }
    }
  }

  getFacebookBanner() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: FacebookBannerAd(
        placementId: kReleaseMode
            ? config.getString("facebook_banner")
            : F_PREFIX_DEV + "677089553262613_677091709929064",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              print("Error: $value");
              break;
            case BannerAdResult.LOADED:
              print("Loaded: $value");
              break;
            case BannerAdResult.CLICKED:
              print("Clicked: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              print("Logging Impression: $value");
              break;
          }
        },
      ),
    );
  }

  getNativeFacebook(size) {
    return FacebookNativeAd(
      placementId: kReleaseMode
          ? config.getString("facebook_native_banner")
          : F_PREFIX_DEV + "677089553262613_677112166593685",
      adType: NativeAdType.NATIVE_BANNER_AD,
      width: size.width,
      height: BannerSize.STANDARD.height.toDouble(),
      backgroundColor: Colors.indigo,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.black,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      keepAlive:
          true, //set true if you do not want adview to refresh on widget rebuild
      keepExpandedWhileLoading:
          true, // set false if you want to collapse the native ad view when the ad is loading
      expandAnimationDuraion:
          300, //in milliseconds. Expands the adview with animation when ad is loaded
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
    );
  }

  getAdmobBanner(size) {
    final BannerAd myBanner = BannerAd(
      adUnitId:
          kReleaseMode ? config.getString("google_banner") : ADMOB_BANNER_TEST,
      size:
          AdSize(width: size.width.toInt(), height: BannerSize.STANDARD.height),
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        width: size.width,
        height: AdSize.banner.height.toDouble(),
        child: AdWidget(ad: myBanner),
      ),
    );
  }
}
