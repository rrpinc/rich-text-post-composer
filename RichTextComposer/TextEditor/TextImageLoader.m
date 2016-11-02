#import <SDWebImage/SDWebImageManager.h>
#import "TextImageLoader.h"
#import "UIImage+Scale.h"

@implementation TextImageLoader

- (void)loadImageInTextView:(UITextView*)textView withImageUrl:(NSURL*)imageUrl andCompletionBlock:(void (^)(void))completion
{
    NSMutableAttributedString* s = [textView.attributedText mutableCopy];
    NSTextAttachment* textAttachment = [NSTextAttachment new];
    UIImage* a = [UIImage new];
    textAttachment.image = a;
    textView.delaysContentTouches = YES;

    __block NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [s beginEditing];
    [s insertAttributedString:attrStringWithImage atIndex:textView.selectedRange.location];
    textView.attributedText = s;
    [s endEditing];
    __block NSRange rr = [self rangeOfAttachment:textAttachment inTextView:textView];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imageUrl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (!image)
            return;

        UIImage* scaledImage = [image imageScaledToMaxWidth:[[UIScreen mainScreen] nativeBounds].size.width maxHeight:[[UIScreen mainScreen] nativeBounds].size.height];
        textAttachment.image = scaledImage ?: image;
        attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSRange ss = NSMakeRange(rr.location, attrStringWithImage.length);
        rr = NSMakeRange(rr.location, ss.length);
        [s replaceCharactersInRange:rr withAttributedString:attrStringWithImage];

        NSRange r = [self rangeOfAttachment:textAttachment inTextView:textView];
        NSRange end = NSMakeRange(r.length + r.location, 0);
        textView.selectedRange = end;
        textView.attributedText = s;

        [textView setNeedsDisplay];
        [textView setNeedsLayout];
        [[textView layoutManager ]invalidateDisplayForCharacterRange:r];
        [UIView animateWithDuration:0.2f animations:^{
            [textView layoutIfNeeded];
        }];
        if (finished || error)
        {
            textView.delaysContentTouches = NO;
            [textView becomeFirstResponder];
            if (completion)
                completion();
        }
    }];
    [s endEditing];
}


- (NSRange)rangeOfAttachment:(NSTextAttachment*)attachment inTextView:(UITextView*)textView
{
    __block NSRange ret;
    [textView.textStorage enumerateAttribute:NSAttachmentAttributeName
                                          inRange:NSMakeRange(0, textView.textStorage.length)
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:^(id value, NSRange range, BOOL *stop) {
                                           if (attachment == value) {
                                               ret = range;
                                               *stop = YES;
                                           }
                                       }];
    return ret;
}

@end
