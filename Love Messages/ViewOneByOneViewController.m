//
//  ViewOneByOneViewController.m
//  Love Messages
//
//  Created by Muhammad Luqman on 1/11/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

#import "ViewOneByOneViewController.h"
#import "SingletonClass.h"
#import "Constante.h"
#import "DBManager.h"


@interface ViewOneByOneViewController (){
    
    SingletonClass *singleton;
    NSString*messageSend;
    NSInteger tempCounterForInterstitialLoad;
    NSMutableArray*tempArrayForOneMessageData;
    
    
}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewOneByOneViewController

@synthesize indexOfCell;
@synthesize Title;
@synthesize flagForBookmark;

- (void)viewDidLoad {
    
    [UnityAds initialize:unityID delegate:self];
    [self interstitialLoad];
    [self bannerViewLoad];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(loadBanner) userInfo:nil repeats:YES];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.db"];
    
    singleton = [SingletonClass SingletonClass];
    tempArrayForOneMessageData = [[NSMutableArray alloc] init];
    
    if (flagForBookmark == 1) {
        
        for (int i = 0;i< [[singleton arrayForOneMessageDataBookmarks] count] ; i++) {
            [tempArrayForOneMessageData addObject:[singleton arrayForOneMessageDataBookmarks][i] ];
        }
    }else{
        for (int i = 0;i< [[singleton arrayForOneMessageData] count] ; i++) {
            [tempArrayForOneMessageData addObject:[singleton arrayForOneMessageData][i] ];
        }
    }
    
    self.labelForTitle.text = Title;
    self.labelForCounter.text = [NSString stringWithFormat:@"%li/%li",indexOfCell+1,[tempArrayForOneMessageData count]];
    
    self.labelForTitle.adjustsFontSizeToFitWidth=YES;
    self.labelForTitle.minimumScaleFactor= 0;
    self.labelForCounter.adjustsFontSizeToFitWidth=YES;
    self.labelForCounter.minimumScaleFactor= 0;
    
    [self setTextOnTextView];
    
    if (indexOfCell == 0) {
        self.outletBtnBack.hidden = YES;
    }
    if (indexOfCell == [tempArrayForOneMessageData count]-1) {
        self.outletBtnNext.hidden = YES;
    }
    
    [super viewDidLoad];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (IBAction)btnNext:(id)sender {
    
    [self counterInterstitialLoad];

    [self nextMessage];
}
- (IBAction)btnBack:(id)sender {
    
    [self counterInterstitialLoad];

    [self backMessage];
}

-(void)nextMessage{
    
    self.outletBtnBack.hidden = NO;
    
    if (indexOfCell<[tempArrayForOneMessageData count]-1) {
        indexOfCell++;
        
        [self setTextOnTextView];
        [self animationViewNext];
    }
    
    if (indexOfCell == 0) {
        self.outletBtnBack.hidden = YES;
    }
    if (indexOfCell == [tempArrayForOneMessageData count]-1) {
        self.outletBtnNext.hidden = YES;
    }

}
-(void)backMessage{
    
    self.outletBtnNext.hidden = NO;
    
    if (indexOfCell>0) {
        indexOfCell--;
        
        [self setTextOnTextView];
        [self animationViewBack];
    }
    
    if (indexOfCell == 0) {
        self.outletBtnBack.hidden = YES;
    }
    if (indexOfCell == [tempArrayForOneMessageData count]-1) {
        self.outletBtnNext.hidden = YES;
    }
    
}
- (IBAction)btnFavourit:(id)sender {
    
    NSArray *tempArrayForOneMessage =  tempArrayForOneMessageData[indexOfCell];
    
    NSString* message = tempArrayForOneMessage[1];
    NSInteger bookmark = [tempArrayForOneMessage[3] integerValue];
    NSString *query;
    
    if (bookmark == 1) {
        
        UIImage *btnImage = [UIImage imageNamed:@"bookmark_inactive.png"];
        [self.outletFavourit setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        query = [NSString stringWithFormat:@"update Messages set Bookmark=%d where Description='%@'", 0,message];
    }else{
        
        UIImage *btnImage = [UIImage imageNamed:@"bookmark_active.png"];
        [self.outletFavourit setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        query = [NSString stringWithFormat:@"update Messages set Bookmark=%d where Description='%@'", 1,message];
    }
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        
        NSLog(@"Could not execute the query.");
    }
    
    NSInteger atempArrayIndex = singleton.ArrayIndex;
    [tempArrayForOneMessageData removeAllObjects];
    
    NSString *tempMessagesString = [NSString stringWithFormat:@"select * from Messages where Category=%ld",atempArrayIndex];
    NSArray *tempArrayForMessage = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:tempMessagesString]];
    
    if (flagForBookmark == 1) {
        
        for (int i = 0; i<[tempArrayForMessage count]; i++) {
            NSArray *temp = tempArrayForMessage[i];
            NSInteger bookmark = [temp[3] integerValue];
            if (bookmark == 1) {
                [tempArrayForOneMessageData addObject:tempArrayForMessage[i]];
            }
        }
            if (indexOfCell== 0) {
                
                NSInteger tempLength = [tempArrayForOneMessageData count];
                if (tempLength == 0) {
                    [[singleton arrayForOneMessageDataBookmarks] removeAllObjects];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self nextMessage];
                }
            }else if (indexOfCell == [tempArrayForOneMessageData count]) {
                [self backMessage];
            }else{
                [self nextMessage];
            }
    }
    else{
        
        for (int i = 0; i<[tempArrayForMessage count]; i++) {
            [tempArrayForOneMessageData addObject:tempArrayForMessage[i]];
        }
    }
}

-(void)setTextOnTextView{
    
    self.labelForCounter.text = [NSString stringWithFormat:@"%li/%li",indexOfCell+1,[tempArrayForOneMessageData count]];
    NSArray *tempArrayForOneMessage =  tempArrayForOneMessageData[indexOfCell];
    NSInteger bookmark = [tempArrayForOneMessage[3] integerValue];
    
    if (bookmark == 1) {
        
        UIImage *btnImage = [UIImage imageNamed:@"bookmark_active.png"];
        [self.outletFavourit setBackgroundImage:btnImage forState:UIControlStateNormal];
        
    }else{
        
        UIImage *btnImage = [UIImage imageNamed:@"bookmark_inactive.png"];
        [self.outletFavourit setBackgroundImage:btnImage forState:UIControlStateNormal];
    }
    
    NSMutableString*string1 = [[NSMutableString alloc] init];
    NSMutableString*string2 = [[NSMutableString alloc] init];
    NSMutableString*string3 = [[NSMutableString alloc] init];
    
    NSArray* p = [tempArrayForOneMessage[1] componentsSeparatedByString: @"<p>"];
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
    
    messageSend = string3;
    
    self.labelForTextMessage.text = string3;
    [self textViewDidChange:self.labelForTextMessage];
    
    if ((self.viewForTextView.frame.size.height-(self.labelForTextMessage.frame.size.height))<0){
        
        self.labelForTextMessage.scrollEnabled = YES;
        
        self.labelForTextMessage.frame = CGRectMake(self.labelForTextMessage.frame.origin.x, 0, self.labelForTextMessage.frame.size.width, self.viewForTextView.frame.size.height);
    }else{
        self.labelForTextMessage.scrollEnabled = NO;
        
        self.labelForTextMessage.frame = CGRectMake(self.labelForTextMessage.frame.origin.x, (self.viewForTextView.frame.size.height-(self.labelForTextMessage.frame.size.height))/2, self.labelForTextMessage.frame.size.width, self.labelForTextMessage.frame.size.height);
    }
}

- (IBAction)btnHome:(id)sender {
    
    if (flagForBookmark == 1){
        
        [[singleton arrayForOneMessageDataBookmarks] removeAllObjects];
        for (int i = 0; i<[tempArrayForOneMessageData count]; i++) {
            [[singleton arrayForOneMessageDataBookmarks]addObject:tempArrayForOneMessageData[i]];
        }
    }else{
        
        [[singleton arrayForOneMessageData] removeAllObjects];
        for (int i = 0; i<[tempArrayForOneMessageData count]; i++) {
            [[singleton arrayForOneMessageData]addObject:tempArrayForOneMessageData[i]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animationViewNext{
    
    self.viewForTextView.frame = CGRectMake(self.view.frame.size.width, _viewForTextView.frame.origin.y, _viewForTextView.frame.size.width, _viewForTextView.frame.size.height);
    
    [UIView animateWithDuration:0.3 delay:0.0f options: (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        
        self->_viewForTextView.frame = CGRectMake(0, self->_viewForTextView.frame.origin.y, self->_viewForTextView.frame.size.width, self->_viewForTextView.frame.size.height);
    }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)animationViewBack{
    
    self.viewForTextView.frame = CGRectMake(-self.view.frame.size.width, _viewForTextView.frame.origin.y, _viewForTextView.frame.size.width, _viewForTextView.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0.0f options: (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        self->_viewForTextView.frame = CGRectMake(0, self->_viewForTextView.frame.origin.y, self->_viewForTextView.frame.size.width, self->_viewForTextView.frame.size.height);
    }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnShare:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Share Message.!"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    UIAlertAction *Email = [UIAlertAction actionWithTitle:@"Email"
                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                        [self shareEmail];
                                                        
                                                    }];
    
    UIAlertAction *Facebook = [UIAlertAction actionWithTitle:@"Facebook"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           [self shareFacebook];
                                                           
                                                       }];
    
    UIAlertAction *Twitter = [UIAlertAction actionWithTitle:@"Twitter"
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                          [self shareTwiter];
                                                          
                                                      }];
    
    UIAlertAction *WhatsApp = [UIAlertAction actionWithTitle:@"WhatsApp"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           [self shareWhatsApp];
                                                           
                                                       }];
    
    UIAlertAction *Message = [UIAlertAction actionWithTitle:@"Message"
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                          [self shareMessage];
                                                          
                                                      }];
    
    [Email setValue:[[UIImage imageNamed:@"mail.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [Facebook setValue:[[UIImage imageNamed:@"fb.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [Twitter setValue:[[UIImage imageNamed:@"twitter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [WhatsApp setValue:[[UIImage imageNamed:@"whatsapp.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [Message setValue:[[UIImage imageNamed:@"message.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    [alert addAction:Email];
    [alert addAction:Facebook];
    [alert addAction:Twitter];
    [alert addAction:WhatsApp];
    [alert addAction:Message];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)shareEmail{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        
        [mail setSubject:[NSString stringWithFormat:@"Message"]];
        [mail setMessageBody: [NSString stringWithFormat:@"%@ \n\n%@",messageSend,URL]isHTML:NO];
        
        [mail setToRecipients:[NSArray arrayWithObjects:@"test@xprogress.com", nil]];
        [mail setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        [self AlertViewShow:@"Message" message:@"There is no active mail account.."];
    }
    
    NSLog(@"Email");
}

-(void)shareFacebook{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:[NSString stringWithFormat:@"%@",messageSend]];
        [controller addURL:[NSURL URLWithString:URL]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"UnSucess"
                                                                       message:@" Login his Account "
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    NSLog(@"Facebook");
    
}-(void)shareTwiter{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@",messageSend]];
        [tweetSheet addURL:[NSURL URLWithString:URL]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"UnSucess"
                                                                       message:@"Login his Account "
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}-(void)shareWhatsApp{
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",messageSend];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        [self AlertViewShow:@"Error" message:@"can not share with whats app"];
    }
    
    NSLog(@"WhatsApp");
}-(void)shareMessage{
    
    if(![MFMessageComposeViewController canSendText]) {
        
        [self AlertViewShow:@"Error" message:@"Your device doesn't support SMS!"];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"%@",messageSend];
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:nil];
    
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
    
    NSLog(@"Message");
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            [self AlertViewShow:@"Error" message:@"Failed to send SMS!"];
            break;
        }
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
            
        case MFMailComposeResultSent:
            [self AlertViewShow:@"Send mail" message:@"You sent the email."];
            
            break;
        case MFMailComposeResultSaved:
            [self AlertViewShow:@"Draft mail" message:@"You saved a draft of this email."];
            break;
        case MFMailComposeResultCancelled:
            [self AlertViewShow:@"Cancelled mail" message:@"You cancelled sending this email."];
            break;
        case MFMailComposeResultFailed:
            [self AlertViewShow:@"Mail failed" message:@"Mail failed:  An error occurred when trying to compose this email"];
            break;
        default:
            [self AlertViewShow:@"An error occurred " message:@"An error occurred when trying to compose this email"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)AlertViewShow:(NSString *)title message:(NSString*)message{
    
    UIAlertView  *myalert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [myalert show];
}



-(void)bannerViewLoad{
    
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

-(void)loadUnityAdd{
    if (UnityAds.isReady) {
        [UnityAds show:self];
    }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"add recieved");
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    self.bannerView.hidden = NO;
    
    self.viewForTextView.frame = CGRectMake(0, self.viewForHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.viewForHeader.frame.size.height+self.bannerView.frame.size.height+self.viewFOrFooter.frame.size.height));

    self.viewFOrFooter.frame = CGRectMake(0, self.view.frame.size.height-(self.viewForHeader.frame.size.height+self.bannerView.frame.size.height),self.viewFOrFooter.frame.size.width,self.viewFOrFooter.frame.size.height);
    
    self.bannerView.frame = CGRectMake(0, self.view.frame.size.height-(self.bannerView.frame.size.height),self.bannerView.frame.size.width,self.bannerView.frame.size.height);
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    self.bannerView.hidden = YES;
    
    self.viewForTextView.frame = CGRectMake(0, self.viewForHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.viewForHeader.frame.size.height+self.viewFOrFooter.frame.size.height));
    
    self.viewFOrFooter.frame = CGRectMake(0, self.view.frame.size.height-(self.viewFOrFooter.frame.size.height),self.viewFOrFooter.frame.size.width,self.viewFOrFooter.frame.size.height);
    
}

-(void)counterInterstitialLoad{
    
    if (tempCounterForInterstitialLoad == CounterForInterstitialLoad) {
        
        tempCounterForInterstitialLoad = 0;
        [self LoadVideoAdd];
    }else{
        
        tempCounterForInterstitialLoad++;
    }
}

-(void)LoadVideoAdd{
    if (flagForUnityLoad) {
        [self loadUnityAdd];
    }else{
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:self];
        }
    }
    flagForUnityLoad = !flagForUnityLoad;
}


- (void)unityAdsDidError:(UnityAdsError)error withMessage:(nonnull NSString *)message {
    
}

- (void)unityAdsDidFinish:(nonnull NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    [self interstitialLoad];
}

- (void)unityAdsDidStart:(nonnull NSString *)placementId {
    
}

- (void)unityAdsReady:(nonnull NSString *)placementId {
    
}


@end

