//
//  DetailViewController.m
//  Love Messages
//
//  Created by Muhammad Luqman on 1/11/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import "DetailViewController.h"
#import "SingletonClass.h"
#import "ViewController.h"
#import "DetailTableViewCell.h"
#import "ViewOneByOneViewController.h"
#import "DBManager.h"
#import "Constante.h"

@interface DetailViewController (){
    SingletonClass *singleton;
    BOOL tempflagforBookmark;
}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation DetailViewController

@synthesize indexOfCell;
@synthesize cellTitle;

- (void)viewDidLoad {
    
    UIImage*images = [UIImage imageNamed:@"bookmark-header.png"];
    [self.outletBtnBookmarks setBackgroundImage:images forState:UIControlStateNormal];

    
    [self bannerViewLoad];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(loadBanner) userInfo:nil repeats:YES];
    
    tempflagforBookmark = NO;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.db"];
    
    
    singleton = [SingletonClass SingletonClass];
    
    self.labelForTitle.text = cellTitle;
    self.labelForTitle.adjustsFontSizeToFitWidth=YES;
    self.labelForTitle.minimumScaleFactor= 0;
    
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tempflagforBookmark) {
        return [[singleton arrayForOneMessageDataBookmarks]count];
        
    }else{
        
        return [[singleton arrayForOneMessageData]count];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"DetailTableViewCell";
    
    DetailTableViewCell *mainMenueTableViewcell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (mainMenueTableViewcell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil];
        mainMenueTableViewcell = [nib objectAtIndex:0];
    }
    
    NSArray*tempArray;
    
    if (tempflagforBookmark) {
        
        tempArray = [singleton arrayForOneMessageDataBookmarks][indexPath.row];
    }else{
        
        tempArray = [singleton arrayForOneMessageData][indexPath.row];
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSMutableString*string1 = [[NSMutableString alloc] init];
        NSMutableString*string2 = [[NSMutableString alloc] init];
        NSMutableString*string3 = [[NSMutableString alloc] init];
        
        NSArray* p = [tempArray[1] componentsSeparatedByString: @"<p>"];
        for (int i = 0; i<[p count]; i++) {
            [string1 appendString:p[i]];
        }
        NSArray* pp = [string1 componentsSeparatedByString: @"</p>"];
        for (int i = 0; i<[pp count]; i++) {
            [string2 appendString:pp[i]];
        }
        
        NSArray* bb = [string2 componentsSeparatedByString: @"<br />"];
        for (int i = 0; i<[bb count]; i++) {
            [string3 appendString:bb[i]];
        }
        mainMenueTableViewcell.labelForTitleCell.text = string3;
        mainMenueTableViewcell.labelForCounterCell.text = [NSString stringWithFormat:@"%li:",indexPath.row+1];
        NSInteger bookmarks = [tempArray[3] integerValue];
        
        if (bookmarks == 0) {
            mainMenueTableViewcell.imagesForBookMarks.image = [UIImage imageNamed:@"bookmark_inactive.png"];
        }else{
            mainMenueTableViewcell.imagesForBookMarks.image = [UIImage imageNamed:@"bookmark_active.png"];
        }
        
    }];
    
    mainMenueTableViewcell.labelForCounterCell.adjustsFontSizeToFitWidth=YES;
    mainMenueTableViewcell.labelForCounterCell.minimumScaleFactor= 0;
    
    return mainMenueTableViewcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewOneByOneViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOneByOneViewController"];
    viewController.indexOfCell = indexPath.row;
    
    if (tempflagforBookmark) {
        viewController.flagForBookmark = 1;
    }
    else{
        viewController.flagForBookmark = 0;
    }
    
    viewController.Title = cellTitle;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnBackToHome:(id)sender {
    
    ViewController *AddNotesViewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:AddNotesViewCont animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.myTableView reloadData];

}
- (IBAction)btnBookmarks:(id)sender {
    
    NSInteger tempindex = singleton.ArrayIndex;
    NSString *Messages = [NSString stringWithFormat:@"select * from Messages where Category=%ld",tempindex];
    NSArray *arrayForMessage = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:Messages]];

    if (tempflagforBookmark) {
        
        [[singleton arrayForOneMessageData] removeAllObjects];
        for (int i = 0; i<[arrayForMessage count]; i++) {
            
                [[singleton arrayForOneMessageData] addObject:arrayForMessage[i]];
            }
        
        UIImage*images = [UIImage imageNamed:@"bookmark-header.png"];
        [self.outletBtnBookmarks setBackgroundImage:images forState:UIControlStateNormal];
        
        //[self.outletBtnBookmarks setTitle:@"Bookmarked" forState:UIControlStateNormal];
        tempflagforBookmark = NO;
    }
    
    else{
        
        UIImage*images = [UIImage imageNamed:@"category-header.png"];
        [self.outletBtnBookmarks setBackgroundImage:images forState:UIControlStateNormal];
        
        //[self.outletBtnBookmarks setTitle:@"All Categories" forState:UIControlStateNormal];
        [[singleton arrayForOneMessageDataBookmarks] removeAllObjects];
        
        tempflagforBookmark = YES;
        for (int i = 0; i<[arrayForMessage count]; i++) {
            NSArray *temp = arrayForMessage[i];
            
            NSInteger bookmark = [temp[3] integerValue];
            if (bookmark == 1) {
                [[singleton arrayForOneMessageDataBookmarks] addObject:arrayForMessage[i]];
            }
        }
    }
    
    [self.myTableView reloadData];
}


-(void)bannerViewLoad{
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    //    GADRequest *request = [GADRequest request];
    //    [request tagForChildDirectedTreatment:YES];
    self.bannerView.adUnitID = BannerID;
    self.bannerView.delegate = self;
    
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

-(void)loadBanner{
    
    [self.bannerView loadRequest:[GADRequest request]];
}

-(void)interstitialLoad{
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:IntertestialID];
    [self.interstitial presentFromRootViewController:self];
    [self.interstitial loadRequest:[GADRequest request]];
    self.interstitial.delegate = self;
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    self.bannerView.hidden = NO;
    self.myTableView.frame = CGRectMake(0, self.viewForHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.viewForHeader.frame.size.height+self.bannerView.frame.size.height));
    
    self.bannerView.frame = CGRectMake(0, self.view.frame.size.height-(self.bannerView.frame.size.height),self.bannerView.frame.size.width,self.bannerView.frame.size.height);
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    self.bannerView.hidden = YES;
    self.myTableView.frame = CGRectMake(0, self.viewForHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.viewForHeader.frame.size.height);
}

@end
