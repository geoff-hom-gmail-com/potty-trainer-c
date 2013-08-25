//
//  GGKInAppPurchaseObserver.h
//  Perfect Potty
//
//  Created by Geoff Hom on 3/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol GGKInAppPurchaseObserverDelegate

// Sent after transactions were completed, failed, or restored.
- (void)inAppPurchaseObserverDidHandleUpdatedTransactions:(id)sender;

@end

@interface GGKInAppPurchaseObserver : NSObject <SKPaymentTransactionObserver>

@property (weak, nonatomic) id <GGKInAppPurchaseObserverDelegate> delegate;

- (void)handleCompletedTransaction:(SKPaymentTransaction *)theTransaction;
// Store the purchase. Notify user.

- (void)handleFailedTransaction:(SKPaymentTransaction *)theTransaction;
// Usually happens because user decided not to purchase. Remove from payment queue.

// Override.
- (id)init;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
// So, handle the transactions.

@end
