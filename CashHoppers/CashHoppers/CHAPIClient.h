#import "AFIncrementalStore.h"
#import "AFRestClient.h"


#define CH_API_KEY @"123"

@interface CHAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (CHAPIClient *)sharedClient;
+ (NSString*)base64stringFromImage:(UIImage*)image;
@end
