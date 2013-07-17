#import "AFIncrementalStore.h"
#import "AFRestClient.h"


#define CH_API_KEY @"e3c9vgt3bqk3USQRGXZLYN9RCUHtU6"

@interface CHAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (CHAPIClient *)sharedClient;
+ (NSString*)base64stringFromImage:(UIImage*)image;
@end
