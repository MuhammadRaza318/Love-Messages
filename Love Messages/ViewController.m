//
//  ViewController.m
//  Love Messages
//
//  Created by Muhammad Luqman on 1/10/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "DetailViewController.h"
#import "SingletonClass.h"
#import "Constante.h"

@interface ViewController (){
    
    SingletonClass *singleton;
    
    NSMutableArray* arrayForID;
    NSMutableArray* arrayForTitleOfCell;
    NSMutableArray* arrayForDetailCell;
    NSArray*cellIconImages;
    NSMutableArray*arrayForItemCounter;
    NSMutableArray *arrayForAllMessageData;
    
}

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrayForCatagory;
@property (nonatomic, strong) NSArray *arrayForMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    if (!flagForInterstitialLoad) {
        [self interstitialLoad];
        flagForInterstitialLoad = YES;
    }
    [self bannerViewLoad];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(loadBanner) userInfo:nil repeats:YES];

    singleton = [SingletonClass SingletonClass];
    cellIconImages = [NSArray arrayWithObjects:@"breakup_sms.png",@"brokenheart_sms.png",@"love_sms.png",@"miss_you.png",@"love_sayings.png",@"romantic_sms.png",@"sad_sms.png",@"crush_sms.png",@"ilu_sms.png",@"love_sayings.png",@"birthday.png",@"romantic_sms.png",@"love_sms.png", nil];
    
    arrayForID = [[NSMutableArray alloc] init];
    arrayForTitleOfCell = [[NSMutableArray alloc] init];
    arrayForDetailCell = [[NSMutableArray alloc] init];
    arrayForItemCounter = [[NSMutableArray alloc] init];
    arrayForAllMessageData = [[NSMutableArray alloc] init];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.db"];
    
    [self loadDataFromDB];
    [self calculateTotalMessage];
    
    self.view.userInteractionEnabled = NO;
    [self.activityIndicater startAnimating];
    self.imagesForActivity.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetMethod) userInfo:nil repeats:NO];
    
    [super viewDidLoad];
}

-(void)targetMethod{
    
    self.view.userInteractionEnabled = YES;
    [self.activityIndicater stopAnimating];
    self.imagesForActivity.hidden = YES;
}
-(void)loadDataFromDB{
    //Messages //Category
    
    NSString *Category = @"select * from Category";
    
    if (self.arrayForCatagory != nil) {
        self.arrayForCatagory = nil;
    }
    
    self.arrayForCatagory = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:Category]];
    
    for (int i = 0; i< self.arrayForCatagory.count; i++) {
        
        NSArray*tempArray = _arrayForCatagory[i];
        [arrayForID addObject:tempArray[0]];
        [arrayForTitleOfCell addObject:tempArray[1]];
        [arrayForDetailCell addObject:tempArray[2]];
    }
}

-(void)calculateTotalMessage{
    
    for (int i = 0; i<[arrayForID count]; i++) {
        
        NSString *Messages = [NSString stringWithFormat:@"select * from Messages where Category=%ld",(long)[arrayForID[i] integerValue]];
        self.arrayForMessage = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:Messages]];
        
        if (self.arrayForMessage != nil) {
            self.arrayForMessage = nil;
        }
        self.arrayForMessage = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:Messages]];
        [arrayForAllMessageData addObject:self.arrayForMessage];
        [arrayForItemCounter addObject:[NSString stringWithFormat:@"%li",_arrayForMessage.count]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIView setAnimationDelegate:self.myTableView];
    [UIView setAnimationDidStopSelector:@selector(reloadData)];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayForTitleOfCell count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MainTableViewCell";
    
    MainTableViewCell *mainMenueTableViewcell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (mainMenueTableViewcell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        mainMenueTableViewcell = [nib objectAtIndex:0];
    }
    
    UIImage *imageRecord =[UIImage imageNamed:[NSString stringWithFormat:@"%@",cellIconImages[indexPath.row]]];
    mainMenueTableViewcell.imagesForCellIcon.image = imageRecord;
    mainMenueTableViewcell.labelForTitleCell.text = [NSString stringWithFormat:@"%@",arrayForTitleOfCell[indexPath.row]];
    mainMenueTableViewcell.labelForDelailCel.text = [NSString stringWithFormat:@"%@",arrayForDetailCell[indexPath.row]];
    mainMenueTableViewcell.labelForCounterItem.text = [NSString stringWithFormat:@"(%@)",arrayForItemCounter[indexPath.row]];
    mainMenueTableViewcell.labelForDelailCel.textAlignment = NSTextAlignmentLeft;
    
    mainMenueTableViewcell.labelForCounterItem.adjustsFontSizeToFitWidth=YES;
    mainMenueTableViewcell.labelForCounterItem.minimumScaleFactor= 0;
    mainMenueTableViewcell.labelForTitleCell.adjustsFontSizeToFitWidth=YES;
    mainMenueTableViewcell.labelForTitleCell.minimumScaleFactor= 0;
    
    return mainMenueTableViewcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[singleton arrayForOneMessageData] removeAllObjects];
    
    NSArray *tempArrayForOneMessage = arrayForAllMessageData[indexPath.row];
    
    for (int i = 0; i<[tempArrayForOneMessage count]; i++) {
        [[singleton arrayForOneMessageData] addObject:tempArrayForOneMessage[i]];
    }
    
    singleton.ArrayIndex = [arrayForID[indexPath.row] integerValue];
    [self loadNextViewController:indexPath.row];
}

-(void)loadNextViewController :(NSInteger)index{
    
    DetailViewController *AddNotesViewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    AddNotesViewCont.indexOfCell = index;
    AddNotesViewCont.cellTitle = arrayForTitleOfCell[index];
    
    [self.navigationController pushViewController:AddNotesViewCont animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
