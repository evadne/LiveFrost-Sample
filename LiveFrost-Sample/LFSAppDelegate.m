#import "LFSAppDelegate.h"
#import "LFSRootViewController.h"

@implementation LFSAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self.window makeKeyAndVisible];
	return YES;
}

- (UIWindow *) window {
	if (!_window) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_window.backgroundColor = [UIColor blackColor];
		_window.rootViewController = ((^{
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[LFSRootViewController alloc] initWithNibName:@"LFSRootViewController" bundle:nil]];
			navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			[navigationController setNavigationBarHidden:YES animated:NO];
			return navigationController;
		})());
	}
	return _window;
}

@end
