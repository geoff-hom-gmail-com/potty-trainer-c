//
//  GGKAboutUsViewController.m
//  Perfect Potty Pal
//
//  Created by Geoff Hom on 3/5/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKAboutUsViewController.h"
#import "GGKPottyTrainerAppDelegate.h"

@interface GGKAboutUsViewController ()

// For letting the player know when the app is busy/waiting (purchasing something).
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

// For storing the give-a-dollar product available for in-app purchase.
@property (strong, nonatomic) SKProduct *giveADollarProduct;

// For playing sound.
@property (strong, nonatomic) GGKSoundModel *soundModel;

// Create payment object and add to queue. Return whether the payment was added.
- (BOOL)buyProductWithID:(NSString *)theProductID;

// Ask Apple for info on available products.
- (void)requestProductData;

//// Start an activity indicator spinning to show the user that the app's working/waiting and the user should wait.
//- (void)startActivityIndicator;
//
//// Stop the activity indicator so the user knows she can do stuff.
//- (void)stopActivityIndicator;

// Show the number of stars purchased. (One star per dollar given.)
- (void)updateStars;

@end

@implementation GGKAboutUsViewController

- (BOOL)buyProductWithID:(NSString *)theProductID
{    
    BOOL thePaymentWasAdded;
    if ([SKPaymentQueue canMakePayments]) {
        
        SKPayment *thePayment = [SKPayment paymentWithProduct:self.giveADollarProduct];
//        [self startActivityIndicator];
        [ [SKPaymentQueue defaultQueue] addPayment:thePayment ];
        thePaymentWasAdded = YES;
    } else {
        
        // Warn user that purchases are disabled.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't Purchase" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.message = [ NSString stringWithFormat:@"I'm sorry, but you can't purchase this because in-app purchases on this device are currently disabled. You can change this in the device Settings under General -> Restrictions -> In-App Purchases."];
        [alertView show];
        thePaymentWasAdded = NO;
    }
    return thePaymentWasAdded;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)giveADollar
{
    BOOL thePaymentWasAdded = [self buyProductWithID:self.giveADollarProduct.productIdentifier];
    if (thePaymentWasAdded) {
        
        self.view.window.userInteractionEnabled = NO;
        [self.giveADollarButton setTitle:@"Giving…" forState:UIControlStateDisabled];
        self.giveADollarButton.enabled = NO;        
    }
}

- (void)inAppPurchaseObserverDidHandleUpdatedTransactions:(id)sender
{    
//    NSLog(@"STVC iAPODHUT");
    self.giveADollarButton.enabled = YES;
    NSString *theNormalTitle = [self.giveADollarButton titleForState:UIControlStateNormal];
    [self.giveADollarButton setTitle:theNormalTitle forState:UIControlStateDisabled];
    
    [self updateStars];
    
    self.view.window.userInteractionEnabled = YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playButtonSound
{
    [self.soundModel playButtonTapSound];
}

- (void)productsRequest:(SKProductsRequest *)theRequest didReceiveResponse:(SKProductsResponse *)theResponse
{
    NSLog(@"AUVC pR dRR");
    
    // We're not checking specifically for an Internet connection. If there's no Internet, then an empty products array will be here.
    // Do something only if we have a product.
    if (theResponse.products.count >= 1) {
        
//        NSLog(@"AUVC pR dRR: 1+ products found");
        SKProduct *aProduct = theResponse.products[0];
        if ([aProduct.productIdentifier isEqualToString:GGKGiveDollarProductIDString]) {
            
            // Show the price in local currency. Enable the purchase button.
            NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
            [aNumberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [aNumberFormatter setLocale:aProduct.priceLocale];
            NSString *aFormattedString = [aNumberFormatter stringFromNumber:aProduct.price];
//            NSLog(@"the price is:%@", aFormattedString);
            
            NSString *aString = [NSString stringWithFormat:@"Give $1 (actually %@) via the App Store. We'll really appreciate it!", aFormattedString];
            self.giveADollar1Label.text = aString;
            self.giveADollarButton.enabled = YES;
            self.giveADollarProduct = aProduct;
        }
    }
}

- (IBAction)rateOrReview
{
    NSLog(@"AUVC rateOrReview");
    
    // Go to the App Store, to this app and the section for "Ratings and Reviews." Note that the app ID won't work prior to the app's first release, but one can test by using the ID of an app that has already been released.
    // App ID for Color Fever: 585564245
    // App ID for Perfect Potty: 615088461
    // App ID for Text Memory: 490464898
    NSString *theAppIDString = @"615088461";
    NSString *theITunesURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", theAppIDString];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:theITunesURL]];
}

- (void)requestProductData
{
    NSSet *productIDsSet = [NSSet setWithObject:GGKGiveDollarProductIDString];
    SKProductsRequest *productsRequest= [[SKProductsRequest alloc] initWithProductIdentifiers:productIDsSet];
    productsRequest.delegate = self;
    [productsRequest start];
    NSLog(@"AUVC rPD");
}

//- (void)startActivityIndicator
//{
//    if (self.activityIndicatorView == nil) {
//        
//        UIActivityIndicatorView *anActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        anActivityIndicatorView.color = [UIColor blackColor];
//        [self.view addSubview:anActivityIndicatorView];
//        self.activityIndicatorView = anActivityIndicatorView;
//    }
//    
//    self.activityIndicatorView.center = self.view.center;
//    [self.activityIndicatorView startAnimating];
//}
//
//- (void)stopActivityIndicator
//{
//    ;
//}

- (void)updateStars
{
    NSNumber *theNumberOfStarsPurchasedNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfStarsPurchasedNumberKeyString];
    
    //testing
//    theNumberOfStarsPurchasedNumber = @12;
    
    if (theNumberOfStarsPurchasedNumber != nil) {
        
        NSInteger theNumberOfStarsPurchasedInteger = [theNumberOfStarsPurchasedNumber integerValue];
        
        // Unicode star.
        NSString *aStarString = @"\u2605";
        
        NSMutableString *aMutableString = [[NSMutableString alloc] initWithCapacity:10];
        for (int i = 0; i < theNumberOfStarsPurchasedInteger; i++) {
            
            [aMutableString appendString:aStarString];
        }
        self.starsLabel.text = aMutableString;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Height should match size of scroll view in the storyboard.
    self.scrollView.contentSize = CGSizeMake(320, 673);
    
    self.soundModel = [[GGKSoundModel alloc] init];
    
    // Listen for when a purchase is done.
    GGKPottyTrainerAppDelegate *thePottyTrainerAppDelegate = (GGKPottyTrainerAppDelegate *)[UIApplication sharedApplication].delegate;
    thePottyTrainerAppDelegate.inAppPurchaseObserver.delegate = self;
    
    // Update number of give-dollar stars purchased.
    [self updateStars];
    
    // Get info on in-app purchase.
    self.giveADollarButton.enabled = NO;
    [self requestProductData];
}

@end
