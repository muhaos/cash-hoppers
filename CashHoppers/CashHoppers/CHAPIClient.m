#import "CHAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "NSDataAdditions.h"

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change port in app delegate for reachability checking!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
static NSString * const kToDoAPIBaseURLString = @"https://georgi.pagekite.me/";
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@implementation CHAPIClient

+ (CHAPIClient *)sharedClient {
    static CHAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kToDoAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    return responseObject;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response 
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    [mutablePropertyValues setObject:[representation objectForKey:@"description"] forKey:@"desc"];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:[[representation objectForKey:@"creation_date"] doubleValue]];
    [mutablePropertyValues setObject:myDate forKey:@"date"];
    
    
    // Customize the response object to fit the expected attribute keys and values  
    return mutablePropertyValues;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}


- (NSMutableURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                                    withContext:(NSManagedObjectContext *)context {
    if ([fetchRequest.entityName isEqualToString:@"WDRequest"]) {
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"api/requests?auth_token=%@", aToken];
        NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
        [request setHTTPShouldHandleCookies:YES];
        return request;
    }
    return nil;
}
+(NSString*)base64stringFromImage:(UIImage*)image{
    NSData *dataObj = UIImagePNGRepresentation(image);
    return [dataObj base64Encoding];
}

@end
