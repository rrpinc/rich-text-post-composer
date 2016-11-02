
#import "ImagePickerProtocols.h"
@class RemoteImageViewModel;

@interface ImagePickerCollectionViewDataProvider : NSObject<UICollectionViewDataSource>

+ (ImagePickerCollectionViewDataProvider*)dataProviderWithCollectionView:(UICollectionView*)collectionView;

- (void)loadData;
- (RemoteImageViewModel*)itemAtIndex:(NSUInteger)index;

@end
