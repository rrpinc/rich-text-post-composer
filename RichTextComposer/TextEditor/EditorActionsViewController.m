
#import "EditorActionsViewController.h"

@interface EditorActionsViewController ()

@property (nonatomic, weak) id<EditorActionsDelegateProtocol> actionsDelegate;
@property (weak, nonatomic) IBOutlet UIButton *bold;
@property (weak, nonatomic) IBOutlet UIButton *italic;
@property (weak, nonatomic) IBOutlet UIButton *indent;
@property (weak, nonatomic) IBOutlet UIButton *image;
@end

@implementation EditorActionsViewController

+ (id<EditorActionsProtocol>)actionsViewWithDelegate:(id<EditorActionsDelegateProtocol>)delegate
{
    EditorActionsViewController* actionsVC = [EditorActionsViewController new];
    actionsVC.actionsDelegate = delegate;
    return actionsVC;
}

- (UIView*)actionsView
{
    return self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.bold addTarget:self action:@selector(boldPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.italic addTarget:self action:@selector(italicPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.image addTarget:self action:@selector(imagePressed) forControlEvents:UIControlEventTouchUpInside];
    [self addIndentGestures];
}

- (void)addIndentGestures
{
    UITapGestureRecognizer* tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(indentPressed)];
    UITapGestureRecognizer* tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(decreaseIndentPressed)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    [self.indent addGestureRecognizer:tapOnce];
    [self.indent addGestureRecognizer:tapTwice];
}

- (void)boldPressed
{
    self.bold.selected = !self.bold.selected;
    self.bold.backgroundColor = self.bold.selected ? [self activeColor] : [self inactiveColor];
    [self.actionsDelegate boldRequested:self.bold.selected];
}

- (void)italicPressed
{
    self.italic.selected = !self.italic.selected;
    self.italic.backgroundColor = self.italic.selected ? [self activeColor] : [self inactiveColor];
    [self.actionsDelegate italicRequested:self.italic.selected];
}

- (void)indentPressed
{
    [self.actionsDelegate indentRequested:YES];
}

- (void)decreaseIndentPressed
{
    [self.actionsDelegate indentRequested:NO];
}

- (void)imagePressed
{
    [self.actionsDelegate imageRequested];
}

- (UIColor*)activeColor
{
    return [[UIColor alloc] initWithRed:210/255.0f green:1.0f blue:221 / 255.0f alpha:1.0f];
}

- (UIColor*)inactiveColor
{
    return [UIColor whiteColor];
}

@end
