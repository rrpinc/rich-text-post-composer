
#import "UIFont+Traits.h"

@implementation UIFont(traits)

+ (UIFont*)fontwithBoldTrait:(NSNumber*)isBold italicTrait:(NSNumber*)isItalic fromDictionary:(NSDictionary *)dictionary
{
    UIFont* font = [dictionary objectForKey:NSFontAttributeName];
    BOOL newBold = (isBold) ? isBold.intValue : [font isTraitActive:UIFontDescriptorTraitBold];
    BOOL newItalic = (isItalic) ? isItalic.intValue : [font isTraitActive:UIFontDescriptorTraitItalic];
    
    return [font fontWithBold:newBold andItalic:newItalic];
}

- (UIFont*)fontWithBold:(BOOL)bold andItalic:(BOOL)italic
{
    UIFontDescriptorSymbolicTraits traits = 0;
    if (bold)
    {
        traits |= UIFontDescriptorTraitBold;
    }
    if (italic)
    {
        traits |= UIFontDescriptorTraitItalic;
    }
    return [UIFont fontWithDescriptor:[[[UIFont systemFontOfSize:14.0f] fontDescriptor] fontDescriptorWithSymbolicTraits:traits] size:14.0f];
}

- (BOOL)isTraitActive:(UIFontDescriptorSymbolicTraits)trait
{
    UIFontDescriptor* fontDescriptor = self.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    return (fontDescriptorSymbolicTraits & trait) != 0;
}

@end
