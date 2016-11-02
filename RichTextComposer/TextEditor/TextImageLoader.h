
@interface TextImageLoader : NSObject

- (void)loadImageInTextView:(UITextView*)textView withImageUrl:(NSURL*)imageUrl andCompletionBlock:(void (^)(void))completion;

@end