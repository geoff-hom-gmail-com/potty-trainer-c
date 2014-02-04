//
//  GGKInAppPurchaseObserver.m
//  Perfect Potty
//
//  Created by Geoff Hom on 3/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKInAppPurchaseObserver.h"

#import "GGKPerfectPottyAppDelegate.h"

@interface GGKInAppPurchaseObserver ()

@property (strong, nonatomic) GGKPerfectPottyModel *perfectPottyModel;

// Store the products bought.
- (void)storeThePurchase:(SKPaymentTransaction *)theTransaction;

@end

@implementation GGKInAppPurchaseObserver

- (void)handleCompletedTransaction:(SKPaymentTransaction *)theTransaction {
    
    [self storeThePurchase:theTransaction];
    [ [SKPaymentQueue defaultQueue] finishTransaction:theTransaction ];
    
    // Notify user.
    UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:@"Purchase Complete" message:@"Thank you!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [anAlertView show];
    
    [self.delegate inAppPurchaseObserverDidHandleUpdatedTransactions:self];
}

- (void)handleFailedTransaction:(SKPaymentTransaction *)theTransaction {
    
    // If the transaction failed not because the user cancelled, then notify the user.
    if (theTransaction.error.code != SKErrorPaymentCancelled) {
        
        UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Error" message:theTransaction.error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alertView show];
    }
    [ [SKPaymentQueue defaultQueue] finishTransaction:theTransaction ];
    [self.delegate inAppPurchaseObserverDidHandleUpdatedTransactions:self];
}

- (id)init
{
    self = [super init];
    if (self) {

        GGKPerfectPottyAppDelegate *theAppDelegate = (GGKPerfectPottyAppDelegate *)[UIApplication sharedApplication].delegate;
        self.perfectPottyModel = theAppDelegate.perfectPottyModel;
    }
    return self;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)theTransactions {
    
    for (SKPaymentTransaction *aTransaction in theTransactions) {
        
        switch (aTransaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                
                NSLog(@"IAPO: transaction completed: yay");
                [self handleCompletedTransaction:aTransaction];
                break;
            case SKPaymentTransactionStateFailed:
                
                NSLog(@"IAPO: transaction failed");
                [self handleFailedTransaction:aTransaction];
                break;
            case SKPaymentTransactionStateRestored:
                
//                NSLog(@"IAPO: transaction restored");
//                [self handleRestoredTransaction:aTransaction];
                break;
            default:
                
                break;
        }
    }
}

- (void)storeThePurchase:(SKPaymentTransaction *)theTransaction;
{
//    NSNumber *theNumberOfStarsPurchasedNumber = [[NSUserDefaults standardUserDefaults] objectForKey:GGKNumberOfStarsPurchasedNumberKeyString];
//    if (theNumberOfStarsPurchasedNumber == nil) {
//        
//        theNumberOfStarsPurchasedNumber = @0;
//    }
//    NSInteger theNumberOfStarsPurchasedInteger = [theNumberOfStarsPurchasedNumber integerValue];
//    NSInteger theNumberOfStarsPurchasedInteger = self.perfectPottyModel.numberOfStarsPurchasedInteger;

    if ([theTransaction.payment.productIdentifier isEqualToString:GGKGiveDollarProductIDString]) {
        
        self.perfectPottyModel.numberOfStarsPurchasedInteger++;
        [self.perfectPottyModel saveNumberOfStarsPurchased];
//        theNumberOfStarsPurchasedInteger++;
    }
    
//    theNumberOfStarsPurchasedNumber = [NSNumber numberWithInteger:theNumberOfStarsPurchasedInteger];
//    [[NSUserDefaults standardUserDefaults] setObject:theNumberOfStarsPurchasedNumber forKey:GGKNumberOfStarsPurchasedNumberKeyString];
}

@end
