
#import "RemoteImageViewModel.h"

@implementation RemoteImageViewModel

+ (RemoteImageViewModel*)modelWithDictionary:(NSDictionary*)dictionary
{
    RemoteImageViewModel* vm = [RemoteImageViewModel new];
    vm.thumbnail = dictionary[@"imageThumb"];
    vm.fullSize = dictionary[@"original"];
    return vm;
}

@end
