
@interface NSAttributedString(Paragraph)

- (NSArray *)rangeOfParagraphsFromTextRange:(NSRange)textRange;
- (NSRange)firstParagraphRangeFromTextRange:(NSRange)range;
@end
