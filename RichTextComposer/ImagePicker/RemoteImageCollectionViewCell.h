
@interface RemoteImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)populateWithUrl:(NSURL*)imageUrl;

@end
