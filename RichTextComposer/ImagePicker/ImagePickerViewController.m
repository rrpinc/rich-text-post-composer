
#import "ImagePickerViewController.h"
#import "ImagePickerCollectionViewDataProvider.h"
#import "RemoteImageCollectionViewCell.h"
#import "RemoteImageViewModel.h"

static NSString* const RemoteImageCollectionViewCellKey = @"RemoteImageCollectionViewCell";
static NSString* const ReuseIdentifier = @"ReuseIdent";
static NSString* const Title = @"My Drive";

@interface ImagePickerViewController ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) id<ImagePickerDelegateProtocol> delegate;
@property (nonatomic, strong) ImagePickerCollectionViewDataProvider* dataProvider;

@end

@implementation ImagePickerViewController

+ (ImagePickerViewController*)imagePickerWithDelegate:(id<ImagePickerDelegateProtocol>)delegate
{
    ImagePickerViewController* imagePicker = [ImagePickerViewController new];
    imagePicker.delegate = delegate;
    return imagePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = Title;
    self.dataProvider = [ImagePickerCollectionViewDataProvider dataProviderWithCollectionView:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self.dataProvider;
    [self.collectionView registerNib:[UINib nibWithNibName:RemoteImageCollectionViewCellKey bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    
    [self.dataProvider loadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RemoteImageViewModel* model = [self.dataProvider itemAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate imageSelected:model];
    
}

@end
