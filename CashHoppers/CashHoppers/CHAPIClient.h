#import "AFIncrementalStore.h"
#import "AFRestClient.h"


#define CH_API_KEY @"NJ2EK8eUIBjQiAeS83M3nKvOnTuTX8"

@interface CHAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (CHAPIClient *)sharedClient;
+ (NSString*)base64stringFromImage:(UIImage*)image;
@end
