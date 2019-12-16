#import <Foundation/Foundation.h>
#import "Reachability.h"

#define kNotifyNetworkStatusChanged  @"_notifyNetworkStatusChanged_"
#define kNotifyNetworkIPAddrChanged  @"_notifyNetworkIPAddrChanged_"

@interface AppNetworkMonitoring : NSObject

@property (nonatomic, readonly) NetworkStatus networkStatus;
@property (nonatomic, readonly) NSString     *curIPAddress;

+ (AppNetworkMonitoring *)sharedInstance;

@end
