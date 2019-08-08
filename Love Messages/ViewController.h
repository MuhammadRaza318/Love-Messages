//
//  ViewController.h
//  Love Messages
//
//  Created by Muhammad Luqman on 1/10/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBManager.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
@import GoogleMobileAds;

static BOOL flagForInterstitialLoad;

@interface ViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicater;
@property (weak, nonatomic) IBOutlet UIImageView *imagesForActivity;

@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *viewForHeader;

@end

