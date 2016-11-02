
@protocol TextComposerTextViewDelegateProtocol <UITextViewDelegate>

@property (nonatomic, assign) BOOL loadingAttachment;

+ (id<TextComposerTextViewDelegateProtocol>)delegateWithTextView:(UITextView*)textView;
- (void)keyboardIsUp:(NSNotification*)notification;
- (void)editRequestedWithBold:(NSNumber*)bold andItalic:(NSNumber*)italic;
- (void)applyAttributeToTypingAttribute:(id)attribute forKey:(NSString*)key;
- (void)indentRequested:(BOOL)rightIndent;

@end

@interface ComposerTextViewDelegate : NSObject<TextComposerTextViewDelegateProtocol>

@property (nonatomic, assign) BOOL loadingAttachment;

@end
