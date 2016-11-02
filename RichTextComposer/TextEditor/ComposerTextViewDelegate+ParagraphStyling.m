
#import "ComposerTextViewDelegate+ParagraphStyling.h"
#import "NSAttributedString+Paragraph.h"

static CGFloat const IndentOffset = 15.0f;

@interface ComposerTextViewDelegate()

@property (nonatomic, weak) UITextView* textView;

@end

@implementation ComposerTextViewDelegate (ParagraphStyling)

- (void)executeIndent:(BOOL)rightIndent
{
    if (!self.textView.hasText && !self.textView.selectedRange.location)
    {
        [self applyAttributeToTypingAttribute:[NSParagraphStyle new] forKey:NSParagraphStyleAttributeName];
        return;
    }

    [self enumerateThroughParagraphsInRange:self.textView.selectedRange withBlock:^(NSRange paragraphRange)
    {
        NSDictionary* dictionary = [self attributesAtIndex:paragraphRange.location];
        NSMutableParagraphStyle* paragraphStyle = [dictionary[NSParagraphStyleAttributeName] mutableCopy];

        if (!paragraphStyle)
            paragraphStyle = [NSMutableParagraphStyle new];

        if (rightIndent)
        {
            paragraphStyle.headIndent += IndentOffset;
            paragraphStyle.firstLineHeadIndent += IndentOffset;
        }
        else
        {
            paragraphStyle.headIndent -= IndentOffset;
            paragraphStyle.firstLineHeadIndent -= IndentOffset;

            if (paragraphStyle.headIndent < 0)
                paragraphStyle.headIndent = 0;

            if (paragraphStyle.firstLineHeadIndent < 0)
                paragraphStyle.firstLineHeadIndent = 0;
        }

        [self applyAttributes:paragraphStyle forKey:NSParagraphStyleAttributeName atRange:paragraphRange];
    }];
}

- (void)applyAttributes:(id)attribute forKey:(NSString *)key atRange:(NSRange)range
{
    if (!range.length)
    {
        [self applyAttributeToTypingAttribute:attribute forKey:key];
        return;
    }

    NSMutableAttributedString* attributedString = [self.textView.attributedText mutableCopy];
    [attributedString addAttributes:@{key : attribute} range:range];
    self.textView.attributedText = attributedString;
    self.textView.selectedRange = range;
}

- (NSDictionary*)attributesAtIndex:(NSInteger)index
{
    if (index == self.textView.attributedText.string.length && self.textView.hasText)
        --index;

    return self.textView.hasText ?
            [self.textView.attributedText attributesAtIndex:index effectiveRange:nil]
            : self.textView.typingAttributes;
}

- (void)enumerateThroughParagraphsInRange:(NSRange)range withBlock:(void (^)(NSRange paragraphRange))block
{
    if (!self.textView.hasText)
        return;

    NSArray *rangeOfParagraphsInSelectedText = [self.textView.attributedText rangeOfParagraphsFromTextRange:self.textView.selectedRange];
    for (NSInteger i = 0 ; i < rangeOfParagraphsInSelectedText.count ; i++)
    {
        NSValue* value = rangeOfParagraphsInSelectedText[i];
        NSRange paragraphRange = [value rangeValue];
        block(paragraphRange);
    }

    NSRange fullRange = [self rangeOfMany:rangeOfParagraphsInSelectedText];
    self.textView.selectedRange = fullRange;
}

- (NSRange)rangeOfMany:(NSArray *)paragraphRanges
{
    if (!paragraphRanges.count)
        return NSMakeRange(0, 0);

    NSRange firstRange = [paragraphRanges[0] rangeValue];
    NSRange lastRange = [[paragraphRanges lastObject] rangeValue];
    return NSMakeRange(firstRange.location, lastRange.location + lastRange.length - firstRange.location);
}

@end
