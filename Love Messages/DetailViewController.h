//
//  DetailViewController.h
//  Love Messages
//
//  Created by Muhammad Luqman on 1/11/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>
@import GoogleMobileAds;


@interface DetailViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate>

- (IBAction)btnBackToHome:(id)sender;
- (IBAction)btnBookmarks:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *outletBtnBookmarks;

@property(nonatomic)NSInteger indexOfCell;
@property(nonatomic)NSString *cellTitle;


@property(nonatomic, strong) GADInterstitial *interstitial;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *viewForHeader;

@end
