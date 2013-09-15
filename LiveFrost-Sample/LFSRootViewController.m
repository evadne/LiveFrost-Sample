#import <LiveFrost/LiveFrost.h>
#import "LFSRootViewController.h"
#import "LFSCollectionViewCell.h"

@interface LFSRootViewController ()
@property (nonatomic, readonly, strong) LFGlassView *glassView;
@end

@implementation LFSRootViewController
@dynamic collectionView;
@synthesize glassView = _glassView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = ((^(NSBundle *bundle){
			NSMutableDictionary *answer = [bundle.infoDictionary mutableCopy];
			[answer addEntriesFromDictionary:bundle.localizedInfoDictionary];
			return answer;
		})([NSBundle mainBundle]))[@"CFBundleDisplayName"] ?: @"Tiles";
	}
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	[self.collectionView registerClass:[LFSCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
	
	UICollectionViewFlowLayout *cvLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	cvLayout.minimumInteritemSpacing = 0.0f;
	cvLayout.minimumLineSpacing = 0.0f;
	cvLayout.itemSize = (CGSize){ 80.0f, 80.0f };
	
	[self.view addSubview:self.glassView];
}

- (LFGlassView *) glassView {
	if (!_glassView) {
		_glassView = [[LFGlassView alloc] initWithFrame:(CGRect){ 0, 0, 200, 200 }];
		_glassView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
		_glassView.center = (CGPoint){
			0.5f * CGRectGetWidth(self.view.bounds),
			0.5f * CGRectGetHeight(self.view.bounds)
		};
	}
	return _glassView;
}

- (void) viewDidLayoutSubviews {
	UICollectionView *cv = self.collectionView;
	CGRect cvInsetFrame = UIEdgeInsetsInsetRect(cv.frame, cv.contentInset);
	self.glassView.center = (CGPoint){
		cvInsetFrame.origin.x + 0.5f * cvInsetFrame.size.width,
		cvInsetFrame.origin.y + 0.5f * cvInsetFrame.size.height
	};
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 1048576;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor colorWithHue:0.1f + ((float_t)(arc4random() % 32) / 256.0f) saturation:0.5f + ((float_t)(arc4random() % 128) / 256.0f) brightness:0.5f + ((float_t)(arc4random() % 128) / 256.0f) alpha:1.0f];
	return cell;
}

@end
