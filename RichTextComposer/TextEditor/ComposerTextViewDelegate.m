
#import "ComposerTextViewDelegate.h"
#import "UIFont+Traits.h"
#import "ComposerTextViewDelegate+ParagraphStyling.h"

static CGFloat const IndentOffset = 15.0f;

@interface ComposerTextViewDelegate()

@property (nonatomic, weak) UITextView* textView;

@end

@implementation ComposerTextViewDelegate

+ (id<TextComposerTextViewDelegateProtocol>)delegateWithTextView:(UITextView*)textView
{
    ComposerTextViewDelegate* delegate = [ComposerTextViewDelegate new];
    delegate.textView = textView;
    return delegate;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView*)textView
{
    if (self.loadingAttachment)
        return;
    
    if (![textView.text hasSuffix:@"\n"])
    {
        [self scrollToCaretInTextView:textView animated:NO];
        return;
    }
    
    [CATransaction setCompletionBlock:^
    {
        [self scrollToCaretInTextView:textView animated:NO];
    }];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.loadingAttachment)
        return;
    [textView scrollRangeToVisible:textView.selectedRange];
}

#pragma mark - KeyboardAppearance

- (void)scrollToCaretInTextView:(UITextView*)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

- (void)keyboardIsUp:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.textView.superview convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets inset = self.textView.contentInset;
    inset.bottom = keyboardRect.size.height;
    self.textView.contentInset = inset;
    self.textView.scrollIndicatorInsets = inset;
    
    [self scrollToCaretInTextView:self.textView animated:YES];
}

- (void)editRequestedWithBold:(NSNumber*)bold andItalic:(NSNumber*)italic
{
    NSRange selectedRange = self.textView.selectedRange;
    if (!selectedRange.length)
    {
        UIFont* newFont = [UIFont fontwithBoldTrait:bold italicTrait:italic fromDictionary:self.textView.typingAttributes];
        [self applyAttributeToTypingAttribute:newFont forKey:NSFontAttributeName];
        return;
    }

    NSMutableAttributedString* attributedString = [self.textView.attributedText mutableCopy];
    [attributedString beginEditing];
    [attributedString enumerateAttributesInRange:selectedRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *dictionary, NSRange range, BOOL *stop)
    {
        UIFont* newFont = [UIFont fontwithBoldTrait:bold italicTrait:italic fromDictionary:self.textView.typingAttributes];
        [attributedString addAttributes:@{NSFontAttributeName : newFont} range:range];
    }];
    [attributedString endEditing];
    self.textView.attributedText = attributedString;
    self.textView.selectedRange = selectedRange;
}

- (void)applyAttributeToTypingAttribute:(id)attribute forKey:(NSString*)key
{
    NSMutableDictionary *dictionary = [self.textView.typingAttributes mutableCopy];
    dictionary[key] = attribute;
    self.textView.typingAttributes = dictionary;
}

- (void)indentRequested:(BOOL)rightIndent
{
    [self executeIndent:rightIndent];
}


@end
