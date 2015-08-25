//
//  CCImageBrowserView.m
//  Pods
//
//  Created by 黄成 on 15/8/24.
//
//

#import "CCImageBrowserView.h"
#import "CCBrowser.h"

@interface CCImageBrowserView()<UIScrollViewDelegate>

@property (nonatomic,strong) CCIndicatorView *indicatorView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic,assign) BOOL hasLoadedImage;
@property (nonatomic,strong) NSURL *imageUrl;
@property (nonatomic,strong) UIImage *placeHolderImage;
@property (nonatomic,strong) UIButton *reloadButtons;

@end

@implementation CCImageBrowserView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.scrollview];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.longGesture];
    }
    return self;
}

- (UIScrollView*)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]init];
        _scrollview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
        _scrollview.userInteractionEnabled = YES;
        [_scrollview addSubview:self.imageview];
    }
    return _scrollview;
}

- (UIImageView*)imageview{
    if (_imageview == nil) {
        _imageview = [[UIImageView alloc]init];
        _imageview.userInteractionEnabled = YES;
        _imageview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _imageview;
}

- (UITapGestureRecognizer*)doubleTap{
    if (_doubleTap == nil) {
        _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
        [_doubleTap requireGestureRecognizerToFail:self.longGesture];
    }
    return _doubleTap;
}

-  (UITapGestureRecognizer *)singleTap{
    if (_singleTap == nil) {
        _singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.numberOfTapsRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        [_singleTap requireGestureRecognizerToFail:self.longGesture];
    }
    return _singleTap;
}

- (UILongPressGestureRecognizer*)longGesture{
    if (_longGesture == nil) {
        _longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongClick:)];
        _longGesture.allowableMovement = 2.0;
        _longGesture.minimumPressDuration = 1.0;
    }
    return _longGesture;
}

- (void)handleLongClick:(UILongPressGestureRecognizer*)longGesture{
    if (longGesture.state == UIGestureRecognizerStateBegan){
        if (self.longPressBlock) {
            self.longPressBlock(longGesture);
        }
    }
}
- (void)handleDoubleTap:(UITapGestureRecognizer*)tap{
    if (!_hasLoadedImage) {
        return;
    }
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;
        CGFloat scaleY = touchPoint.y + self.scrollview.contentOffset.y;
        [self.scrollview zoomToRect:CGRectMake(scaleX, scaleY, 10, 10) animated:YES];
    }else{
        [self.scrollview setZoomScale:1.0 animated:YES];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer*)tap{
    if (self.tapBlock) {
        self.tapBlock(tap);
    }
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _indicatorView.progress = _progress;
}

- (void)setImageWithUrl:(NSURL *)url placeHolderImage:(UIImage *)placeHolder{
    if (_reloadButtons) {
        [_reloadButtons removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeHolder;
    CCIndicatorView *indicatorView = [[CCIndicatorView alloc]init];
    indicatorView.viewModel = CCIndicatorCiewModelLoopDiagram;
    indicatorView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.indicatorView = indicatorView;
    
    [self addSubview:self.indicatorView];
    
    __weak typeof(self) weakSelf = self;
    [self.imageview sd_setImageWithURL:_imageUrl placeholderImage:_placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.indicatorView.progress = (CGFloat)receivedSize/expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [_indicatorView removeFromSuperview];
        
        if (error) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            strongSelf.reloadButtons = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200, 40);
            button.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            button.backgroundColor = kReloadImageButtongroundColor;
            [button setTitle:@"加载失败,点击重新加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            
            [strongSelf addSubview:button];
            return ;
        }
        strongSelf.hasLoadedImage = YES;
    }];
}

- (void)reloadImage{
    [self setImageWithUrl:self.imageUrl placeHolderImage:self.placeHolderImage];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _indicatorView.center = _scrollview.center;
    _scrollview.frame = self.bounds;
    _reloadButtons.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    [self adjustFrames];
}
- (void)adjustFrames{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }else{
            if (frame.size.width <= frame.size.height) {
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;

}
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}
@end
