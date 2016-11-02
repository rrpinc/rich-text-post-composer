
@class RemoteImageViewModel;

@protocol ImagePickerDelegateProtocol <NSObject>

- (void)imageSelected:(RemoteImageViewModel*)remoteImage;

@end

@protocol ImagePickerProtocol <NSObject>

+ (id<ImagePickerProtocol>)imagePickerWithDelegate:(id<ImagePickerDelegateProtocol>)delegate;

@end
