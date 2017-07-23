
#import "ImagePickerCollectionViewDataProvider.h"
#import "RemoteImageCollectionViewCell.h"
#import "RemoteImageViewModel.h"

static NSString* const ReuseIdentifier = @"ReuseIdent";
static NSString* const ImagesApiUrl = @"https://s3-us-west-2.amazonaws.com/ios-homework/ios/feed.json";


@interface ImagePickerCollectionViewDataProvider()

@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* data;

@end

@implementation ImagePickerCollectionViewDataProvider

+ (ImagePickerCollectionViewDataProvider*)dataProviderWithCollectionView:(UICollectionView*)collectionView
{
    ImagePickerCollectionViewDataProvider* dataProvider = [ImagePickerCollectionViewDataProvider new];
    dataProvider.collectionView = collectionView;
    return dataProvider;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteImageCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    RemoteImageViewModel* vm = (RemoteImageViewModel*)self.data[indexPath.row];
    [cell populateWithUrl:[NSURL URLWithString:vm.thumbnail]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (RemoteImageViewModel*)itemAtIndex:(NSUInteger)index
{
    if (index >= self.data.count)
        return nil;
    
    return self.data[index];
}

//Inline HTTP requset-response handling as this is not the main focus of this project

- (void)loadData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ImagesApiUrl]];

    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      [self parseResult:data];
                                  }];
    [task resume];
}

- (void)parseResult:(NSData*)data
{
    NSError* error = nil;
    NSArray* parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!parsedData || ![parsedData isKindOfClass:[NSArray class]] || error)
        return;
    
    NSMutableArray* mutableData = [NSMutableArray new];
    [parsedData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]])
            [mutableData addObject:[RemoteImageViewModel modelWithDictionary:(NSDictionary*)obj]];
    }];
    
    self.data = mutableData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}


@end
