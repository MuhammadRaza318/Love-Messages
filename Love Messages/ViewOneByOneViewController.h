//
//  ViewOneByOneViewController.h
//  Love Messages
//
//  Created by Muhammad Luqman on 1/11/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

#import <GoogleMobileAds/GoogleMobileAds.h>
@import GoogleMobileAds;
@import UnityAds;

static BOOL flagForUnityLoad;
@interface ViewOneByOneViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate,GADBannerViewDelegate,GADInterstitialDelegate,UnityAdsDelegate>


- (IBAction)btnBack:(id)sender;
- (IBAction)btnNext:(id)sender;
- (IBAction)btnHome:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *labelForTextMessage;

@property (weak, nonatomic) IBOutlet UIView *viewForHeader;
@property (weak, nonatomic) IBOutlet UIView *viewFOrFooter;
@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelForCounter;

@property (weak, nonatomic) IBOutlet UIButton *outletBtnBack;
@property (weak, nonatomic) IBOutlet UIButton *outletBtnNext;

@property(nonatomic)NSInteger indexOfCell;
@property(nonatomic)NSString *Title;

@property(nonatomic)NSInteger flagForBookmark;

@property (weak, nonatomic) IBOutlet UIView *viewForTextView;

- (IBAction)btnShare:(id)sender;

- (IBAction)btnFavourit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletFavourit;


@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end
