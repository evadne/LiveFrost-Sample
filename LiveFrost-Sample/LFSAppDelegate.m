#import "LFSAppDelegate.h"
#import "LFSCollectionViewController.h"
#import "LFSMoviePlayerViewController.h"

@interface LFSAppDelegate () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, readonly, strong) UIPageViewController *pageViewController;
@property (nonatomic, readonly, strong) NSArray *viewControllers;
@end

@implementation LFSAppDelegate
@synthesize pageViewController = _pageViewController;
@synthesize viewControllers = _viewControllers;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self.window makeKeyAndVisible];
	return YES;
}

- (UIPageViewController *) pageViewController {
	if (!_pageViewController) {
		_pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{
			UIPageViewControllerOptionInterPageSpacingKey: @(32.0f)
		}];
		_pageViewController.dataSource = self;
		_pageViewController.delegate = self;
		[_pageViewController setViewControllers:@[
			self.viewControllers[0]
		] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	}
	return _pageViewController;
}

- (NSArray *) viewControllers {
	if (!_viewControllers) {
		_viewControllers = @[
			[[LFSCollectionViewController alloc] initWithNibName:@"LFSCollectionViewController" bundle:nil],
			[LFSMoviePlayerViewController new]
		];
	}
	return _viewControllers;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSArray *vcs = self.viewControllers;
	NSUInteger idx = [vcs indexOfObject:viewController];
	return (idx > 0) ? vcs[idx - 1] : nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSArray *vcs = self.viewControllers;
	NSUInteger idx = [vcs indexOfObject:viewController];
	return (vcs.count > (idx + 1)) ? vcs[idx + 1] : nil;
}

- (UIWindow *) window {
	if (!_window) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_window.backgroundColor = [UIColor blackColor];
		_window.rootViewController = self.pageViewController;
	}
	return _window;
}

@end
