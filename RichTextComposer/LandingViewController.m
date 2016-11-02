
#import "LandingViewController.h"
#import "TextComposerViewController.h"

@interface LandingViewController()

@end

@implementation LandingViewController

- (IBAction)composePressed:(id)sender
{
    TextComposerViewController* vc = [TextComposerViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
