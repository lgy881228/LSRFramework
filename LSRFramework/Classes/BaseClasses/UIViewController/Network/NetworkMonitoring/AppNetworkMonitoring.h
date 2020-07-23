#import <Foundation/Foundation.h>
#import "LSRReachability.h"

#define kNotifyNetworkStatusChanged  @"_notifyNetworkStatusChanged_"
#define kNotifyNetworkIPAddrChanged  @"_notifyNetworkIPAddrChanged_"

@interface AppNetworkMonitoring : NSObject

@property (nonatomic, readonly) LSRNetworkStatus networkStatus;
@property (nonatomic, readonly) NSString     *curIPAddress;

+ (AppNetworkMonitoring *)sharedInstance;

@end
