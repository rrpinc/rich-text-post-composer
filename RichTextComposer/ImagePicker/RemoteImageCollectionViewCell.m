
#import "RemoteImageCollectionViewCell.h"
#import "PINImageView+PINRemoteImage.h"

@implementation RemoteImageCollectionViewCell

- (void)populateWithUrl:(NSURL*)imageUrl
{
    [self.imageView setPin_updateWithProgress:YES];
    [self.imageView pin_setImageFromURL:imageUrl];
}

@end
