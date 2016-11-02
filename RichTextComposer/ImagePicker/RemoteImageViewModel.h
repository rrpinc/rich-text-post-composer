

@interface RemoteImageViewModel : NSObject

@property (nonatomic, copy) NSString* thumbnail;
@property (nonatomic, copy) NSString* fullSize;

+ (RemoteImageViewModel*)modelWithDictionary:(NSDictionary*)dictionary;

@end
