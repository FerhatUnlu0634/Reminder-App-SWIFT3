//
//#import "MKStoreManager.h"
//#import "Global.h"
//#import "Flurry.h"
//#import "GameConstants.h"
//#import "SoundManager.h"
//#import <UserVOD/UserVOD.h>
//
//@implementation MKStoreManager
//
//@synthesize purchasableObjects;
//@synthesize storeObserver;
//
//// all your features should be managed one and only by StoreManager
////static NSString *featureAId = @"com.paperbomber.300Coins";
////static NSString *featureBId = @"com.paperbomber.400Coins";
////static NSString *featureCId = @"com.paperbomber.consumable1";
//
//static NSString *featureAId = @"slotbonanzacoinpack1";
//static NSString *featureBId = @"slotbonanzacoinpack2";
//static NSString *featureCId = @"slotbonanzacoinpack3";
//static NSString *featureDId = @"slotbonanzacoinpack4";
//static NSString *featureEId = @"slotbonanzacoinpack5";
//
//static NSString *featureAId_iPad = @"slotbonanzahdcoinpack1";
//static NSString *featureBId_iPad = @"slotbonanzahdcoinpack2";
//static NSString *featureCId_iPad = @"slotbonanzahdcoinpack3";
//static NSString *featureDId_iPad = @"slotbonanzahdcoinpack4";
//static NSString *featureEId_iPad = @"slotbonanzahdcoinpack5";
//
//
//BOOL featureAPurchased;
//BOOL featureBPurchased;
//BOOL featureCPurchased;
//BOOL featureDPurchased;
//BOOL featureEPurchased;
//
//static MKStoreManager* _sharedStoreManager; // self
//
//- (void)dealloc 
//{	
//	[_sharedStoreManager release];
//	[storeObserver release];
//	[super dealloc];
//}
//
//+ (BOOL) featureAPurchased
//{
//   return featureAPurchased;
//}
//
//+ (BOOL) featureBPurchased 
//{	
//	return featureBPurchased;
//}
//
//+ (BOOL) featureCPurchased
//{
//    return featureCPurchased;
//}
//
//+ (BOOL) featureDPurchased 
//{
//	return featureDPurchased;
//}
//
//+ (BOOL) featureEPurchased
//{
//    return featureEPurchased;
//}
//
//+ (MKStoreManager*)sharedManager
//{
//	@synchronized(self) 
//    {		
//        if (_sharedStoreManager == nil) 
//        {
//            [[self alloc] init]; // assignment not done here
//			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
//			[_sharedStoreManager requestProductData];
//			
//			[MKStoreManager loadPurchases];
//			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
//			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
//        }
//    }
//    
//    return _sharedStoreManager;
//}
//
//#pragma mark Singleton Methods
//
//+ (id)allocWithZone:(NSZone *)zone
//{	
//    @synchronized(self) 
//    {
//		
//        if (_sharedStoreManager == nil) 
//        {			
//            _sharedStoreManager = [super allocWithZone:zone];			
//            return _sharedStoreManager;  // assignment and return on first allocation
//        }
//    }
//	
//    return nil; //on subsequent allocation attempts return nil	
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;	
//}
//
//- (id)retain
//{	
//    return self;	
//}
//
//- (unsigned)retainCount
//{
//    return UINT_MAX;  //denotes an object that cannot be released
//}
//
////- (void)release
////{
////    //do nothing
////}
//
//- (id)autorelease
//{
//    return self;	
//}
//
//- (void) requestProductData
//{
//	SKProductsRequest *request;
//    
//    if (IS_IPAD())
//        request = [[SKProductsRequest alloc] initWithProductIdentifiers:
//                   [NSSet setWithObjects: featureAId_iPad, featureBId_iPad, featureCId_iPad, featureDId_iPad, featureEId_iPad, nil]]; // add any other product here
//        
//    else
//        request = [[SKProductsRequest alloc] initWithProductIdentifiers:
//                   [NSSet setWithObjects: featureAId, featureBId, featureCId, featureDId, featureEId, nil]]; // add any other product here
//	request.delegate = self;
//	[request start];
//}
//
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//	[purchasableObjects addObjectsFromArray:response.products];
//	// populate your UI Controls here
//	for(int i=0;i<[purchasableObjects count];i++)
//	{
//		
//		SKProduct *product = [purchasableObjects objectAtIndex:i];
//		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
//			  [[product price] doubleValue], [product productIdentifier]);
//	}
//	
//	[request autorelease];
//}
//
//- (void) buyFeature:(NSString*) featureId
//{
//    [UserVOD addEvent:@"PressedToBuy"];
//	if ([SKPaymentQueue canMakePayments])
//	{
//		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
//		[[SKPaymentQueue defaultQueue] addPayment:payment];
//	}
//	else
//	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Slot Bonanza" message:@"You are not authorized to purchase from AppStore"
//													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
//	}
//}
//
//- (void) buyFeatureA
//{
//    if (IS_IPAD())
//        [self buyFeature:featureAId_iPad];
//    else
//        [self buyFeature:featureAId];
//}
//
//- (void) buyFeatureB
//{
//    if (IS_IPAD())
//        [self buyFeature:featureBId_iPad];
//    else
//        [self buyFeature:featureBId];
//}
//
//- (void) buyFeatureC
//{
//    if (IS_IPAD())
//        [self buyFeature:featureCId_iPad];
//    else
//        [self buyFeature:featureCId];
//}
//
//- (void) buyFeatureD
//{
//    if (IS_IPAD())
//        [self buyFeature:featureDId_iPad];
//    else
//        [self buyFeature:featureDId];
//}
//
//- (void) buyFeatureE
//{
//    if (IS_IPAD())
//        [self buyFeature:featureEId_iPad];
//    else
//        [self buyFeature:featureEId];
//}
//
//- (void) failedTransaction: (SKPaymentTransaction *)transaction
//{
//    [UserVOD addEvent:@"Transaction Failed"];
//	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
//												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//	[alert show];
//    alert.delegate = self;
//	[alert release];
//}
//
//-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}
//
//-(void) provideContent: (NSString*) productIdentifier
//{
//    [UserVOD addEvent:@"Completed in-app purchase" withParameter:productIdentifier];
//    [Flurry logEvent:[NSString stringWithFormat:@"In App Completed-%@",productIdentifier]];
//    int nNum = 0;
//    
//    if (IS_IPAD())
//    {
//        if([productIdentifier isEqualToString:featureAId_iPad])
//        {
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:0];
//        }
//        else if([productIdentifier isEqualToString:featureBId_iPad])
//        {
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:1];
//        }
//        else if([productIdentifier isEqualToString:featureCId_iPad])
//        {
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:2];
//        }
//        else if([productIdentifier isEqualToString:featureDId_iPad])
//        {
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:3];
//        }
//        else if([productIdentifier isEqualToString:featureEId_iPad])
//        {
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:4];
//        }    
//        else 
//        {
//            return;
//        }
//    }
//	else
//    {
//        if([productIdentifier isEqualToString:featureAId])
//        {
//            //		featureAPurchased = YES;
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:0];
//
//        }
//        else if([productIdentifier isEqualToString:featureBId])
//        {
//            //		featureBPurchased = YES;
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:1];
//            
//
//        }
//        else if([productIdentifier isEqualToString:featureCId])
//        {
//            //		featureCPurchased = YES;
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:2];
//        }
//        else if([productIdentifier isEqualToString:featureDId])
//        {
//            //		featureFPurchased = YES;
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:3];
//        }
//        else if([productIdentifier isEqualToString:featureEId])
//        {
//            //		featureFPurchased = YES;
//            nNum += [[GameConstants sharedGameConstants] returnStoreTotalCoins:4];
//        }    
//        else 
//        {
//            return;
//        }
//    }
//    
//    [[SoundManager sharedSoundManager] playEffect:BUY_COIN_SOUND];
//    
//
//    g_nTmpCoinNum += nNum;
//    

////    g_nTempCoinNum += nNum;
////    
////    g_nCoinNum = g_nTempCoinNum;
////	[MKStoreManager updatePurchases];
//}
//
//+(void) loadPurchases 
//{
////	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	
////    featureAPurchased = [userDefaults boolForKey:featureAId];
////	featureBPurchased = [userDefaults boolForKey:featureBId];
////    featureCPurchased = [userDefaults boolForKey:featureCId];
////    featureFPurchased = [userDefaults boolForKey:featureFId];
//    
////    featureDPurchased = [userDefaults boolForKey:featureDId];
////    featureEPurchased = [userDefaults boolForKey:featureEId];
//}
//
//+(void) updatePurchases
//{
////	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
////	[userDefaults setBool:featureAPurchased forKey:featureAId];
////	[userDefaults setBool:featureBPurchased forKey:featureBId];
////    [userDefaults setBool:featureCPurchased forKey:featureCId];
////    [userDefaults setBool:featureFPurchased forKey:featureFId];
////    
////    [userDefaults setBool:featureDPurchased forKey:featureDId];
////    [userDefaults setBool:featureEPurchased forKey:featureEId];
//}
//
//@end
