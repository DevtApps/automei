import 'package:automei/app/api/Api.dart';
import 'package:automei/app/main/fragments/perfil/PerfilFragmentView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class PerfilFragmentModel extends State<PerfilFragmentView>
    with UserStateModel {
  ScrollController scrollController = ScrollController();

  var isTop = false;

  Size size = Size(0, 0);

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.offset >= size.height * 0.1 && !isTop) {
        setState(() {
          isTop = true;
        });
      } else if (scrollController.offset < size.height * 0.1 && isTop) {
        setState(() {
          isTop = false;
        });
      }
    });
  }

  void dayFree() {
    RewardedAd.load(
        adUnitId: ADMOB_REWARD_TEST,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            ad.show(onUserEarnedReward: (ad, item) {});
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }
}
