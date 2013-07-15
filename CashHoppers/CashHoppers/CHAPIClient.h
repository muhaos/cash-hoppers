#import "AFIncrementalStore.h"
#import "AFRestClient.h"


#define CH_API_KEY @"2WmIrFDLQmYN1KljaCik96tXVlgQ0Z"

@interface CHAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (CHAPIClient *)sharedClient;
+ (NSString*)base64stringFromImage:(UIImage*)image;
@end
