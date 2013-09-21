#import "LFSMoviePlayerViewController.h"
#import <LiveFrost/LFGlassView.h>

@interface LFSMoviePlayerViewController ()
@property (nonatomic, readonly, strong) LFGlassView *glassView;
@property (nonatomic, readonly, strong) AVPlayer *player;
@property (nonatomic, readonly, strong) AVPlayerLayer *playerLayer;
@end

@interface LFSMoviePlayerLayer : CALayer

@end
@implementation LFSMoviePlayerLayer

- (void) renderInContext:(CGContextRef)ctx {
	NSLog(@"%s %p", __PRETTY_FUNCTION__, ctx);
	[super renderInContext:ctx];
	CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
	CGContextFillRect(ctx, (CGRect){0, 0, 512, 512 });
	for (CALayer *sublayer in self.sublayers) {
		if ([sublayer isKindOfClass:[AVPlayerLayer class]]) {
			CALayer *videoLayer = ((CALayer *)sublayer.sublayers[0]).sublayers[0];
//			NSLog(@"drawing %@", videoLayer);
			[videoLayer drawInContext:ctx];
		}
//		[layer renderInContext:ctx];
	}
}

@end

@interface LFSMoviePlayerView : UIView
@end

@implementation LFSMoviePlayerView
+ (Class) layerClass {
	return [LFSMoviePlayerLayer class];
}
@end

@implementation LFSMoviePlayerViewController
@synthesize glassView = _glassView;
@synthesize player = _player;
@synthesize playerLayer = _playerLayer;

- (void) loadView {
	self.view = [LFSMoviePlayerView new];
}

- (AVPlayer *) player {
	if (!_player) {
		_player = [[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"mov"]];
		
		for (NSString *x in @[
			AVPlayerItemTimeJumpedNotification,
			AVPlayerItemDidPlayToEndTimeNotification,
			AVPlayerItemFailedToPlayToEndTimeNotification,
			AVPlayerItemPlaybackStalledNotification,
			AVPlayerItemNewAccessLogEntryNotification,
			AVPlayerItemNewErrorLogEntryNotification
		]) {

			[[NSNotificationCenter defaultCenter] addObserverForName:x object:_player queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
				NSLog(@"%@", note);
			}];

		}
		

//		[_player play];
	}
	return _player;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	[self.view.layer addSublayer:self.playerLayer];
	[self.view setNeedsLayout];
	[self.view addSubview:self.glassView];
}

- (AVPlayerLayer *) playerLayer {
	if (!_playerLayer) {
		_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
	}
	return _playerLayer;
}

- (void) viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	self.playerLayer.frame = self.view.layer.bounds;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[self.moviePlayer play];
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
	self.glassView.center = (CGPoint){
		0.5f * self.view.bounds.size.width,
		0.5f * self.view.bounds.size.height
	};
}

@end
