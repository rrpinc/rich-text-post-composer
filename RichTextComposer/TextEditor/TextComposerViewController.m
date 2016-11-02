
#import "TextComposerViewController.h"
#import "EditorActionsViewController.h"
#import "RemoteImageViewModel.h"
#import "ImagePickerViewController.h"
#import "ComposerTextViewDelegate.h"
#import "TextImageLoader.h"

@interface TextComposerViewController()<EditorActionsDelegateProtocol, ImagePickerDelegateProtocol>

@property (nonatomic, strong) id<EditorActionsProtocol> editorActions;
@property (nonatomic, strong) id<TextComposerTextViewDelegateProtocol> textViewDelegate;
@property (nonatomic, strong) ImagePickerViewController* imagePicker;
@property (nonatomic, weak) IBOutlet UITextView* textView;

@end

@implementation TextComposerViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.inputAccessoryView = [self accesoryView];
    self.textViewDelegate = [ComposerTextViewDelegate delegateWithTextView:self.textView];
    self.textView.delegate = self.textViewDelegate;
    [[NSNotificationCenter defaultCenter] addObserver:self.textViewDelegate selector:@selector(keyboardIsUp:) name:UIKeyboardDidShowNotification object:nil];
    [self addNavigationItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)addNavigationItems
{
    UIBarButtonItem* postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(postPressed)];
    self.navigationItem.rightBarButtonItem = postButton;
}

- (UIView*)accesoryView
{
    self.editorActions = [EditorActionsViewController actionsViewWithDelegate:self];
    return [self.editorActions actionsView];
}

- (void)postPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EditorActionsDelegateProtocol

- (void)boldRequested:(BOOL)selected
{
    [self.textViewDelegate editRequestedWithBold:@(selected) andItalic:nil];
}

- (void)italicRequested:(BOOL)selected
{
    [self.textViewDelegate editRequestedWithBold:nil andItalic:@(selected)];
}

- (void)indentRequested:(BOOL)rightIndent
{
    [self.textViewDelegate indentRequested:rightIndent];
}

- (void)imageRequested
{
    self.imagePicker = (ImagePickerViewController*)[ImagePickerViewController imagePickerWithDelegate:self];
    [self.navigationController pushViewController:self.imagePicker animated:YES];
}

- (void)imageSelected:(RemoteImageViewModel *)remoteImage
{
    [self performSelector:@selector(delayedImageSelection:) withObject:remoteImage afterDelay:0.01f];
}

- (void)delayedImageSelection:(RemoteImageViewModel*)remoteImage
{
    if (self.textView.selectedRange.length > 1 || !remoteImage)
        return;

    __weak TextComposerViewController* weakSelf = self;
    [self.textViewDelegate setLoadingAttachment:YES];
    TextImageLoader* imageLoader = [TextImageLoader new];
    [imageLoader loadImageInTextView:self.textView
                        withImageUrl:[NSURL URLWithString:remoteImage.fullSize]
                  andCompletionBlock:^{
                      [weakSelf.textViewDelegate setLoadingAttachment:NO];
                  }];
}

@end
