//
//  CCImageBrowser.m
//  Pods
//
//  Created by 黄成 on 15/8/24.
//
//

#import "UIViewController+ImageOperation.h"
#import "CCImageBrowser.h"
#import "CCImageBrowserConfig.h"
#import "CCImageBrowserView.h"
#import "CCActionSheet.h"

@interface CCImageBrowser()<UIScrollViewDelegate,UIActionSheetDelegate>{
    
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL hasShowImageBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CCImageBrowser

- (void)viewDidLoad{
    [super viewDidLoad];
    _hasShowImageBrowser = NO;
    self.view.backgroundColor = kImageBrowserBackgrounColor;
    [self addScrollView];
    [self setUpFrame];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_hasShowImageBrowser) {
        [self showImageBrowser];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self setUpFrame];
}

- (void)setUpFrame{
    CGRect rect = self.view.bounds;
    rect.size.width += kImageBrowserImageViewMargin*2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5);
    
    CGFloat y = 0;
    __block CGFloat w = kScreenWidth;
    CGFloat h= kScreenHeight;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kImageBrowserImageViewMargin + idx * (kImageBrowserImageViewMargin *2 + w);
        UIView *view = obj;
        view.frame = CGRectMake(x, y , w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, kScreenHeight);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(kScreenWidth * 0.5, 30);
}

- (void)addScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        CCImageBrowserView *view = [[CCImageBrowserView alloc] init];
        view.imageview.tag = i;
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.tapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hidePhotoBrowser:recognizer];
        };
        
        view.longPressBlock = ^(UILongPressGestureRecognizer *recognizer){
            [weakSelf showToolsBar];
        };
        
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];

    
}
#pragma mark 长按图片浏览器
- (void)showToolsBar{
    CCActionSheet *sheet = [[CCActionSheet alloc]initWithDelegate:self];
    [sheet showInView:self.view];
}

#pragma mark 单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    CCImageBrowserView *view = (CCImageBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:[self getParentView:sourceView]];
    
    CGFloat appWidth;
    CGFloat appHeight;
    if (kScreenWidth < kScreenHeight) {
        appWidth = kScreenWidth;
        appHeight = kScreenHeight;
    } else {
        appWidth = kScreenHeight;
        appHeight = kScreenWidth;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * appWidth)/tempImageSizeW;
        if (tempImageViewH < appHeight) {
            tempImageView.frame = CGRectMake(0, (appHeight - tempImageViewH)*0.5, appWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, appWidth, tempImageViewH);
        }
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
        tempImageView.frame = CGRectMake(0, (appHeight - appWidth)*0.5, appWidth, appWidth);
    }
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView animateWithDuration:kImageBrowserHideDuration animations:^{
        tempImageView.frame = targetTemp;
        
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
    }];
}


- (void)showImageBrowser{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:[self getParentView:sourceView]];
    
    UIImageView *tempImageView = [[UIImageView alloc]init];
    tempImageView.frame = rect;
    tempImageView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    
    CGRect targetTemp;
    
    if (!kIsFullWidthForLandScape) {
        if (kScreenWidth < kScreenHeight) {
            CGFloat placeHolderH = (placeImageSizeH * kScreenWidth)/placeImageSizeW;
            if (placeHolderH <= kScreenHeight) {
                targetTemp = CGRectMake(0, (kScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
            } else {
                targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
            }
        } else {
            CGFloat placeHolderW = (placeImageSizeW * kScreenHeight)/placeImageSizeH;
            if (placeHolderW < kScreenWidth) {
                targetTemp = CGRectMake((kScreenWidth - placeHolderW)*0.5, 0, placeHolderW, kScreenHeight);
            } else {
                targetTemp = CGRectMake(0, 0, placeHolderW, kScreenHeight);
            }
        }
        
    } else {
        CGFloat placeHolderH = (placeImageSizeH * kScreenWidth)/placeImageSizeW;
        if (placeHolderH <= kScreenHeight) {
            targetTemp = CGRectMake(0, (kScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
        }
    }
    
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    
    [UIView animateWithDuration:kImageBrowserShowDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowImageBrowser = YES;
        [tempImageView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
    }];
    
}

- (UIView*)getParentView:(UIView*)view{
    if ([[view nextResponder]isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }return [self getParentView:view.superview];
}
#pragma mark 获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}
#pragma mark 获取高分辨率图片url
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:imageURLForIndex:)]) {
        return [self.delegate photoBrowser:self imageURLForIndex:index];
    }
    return nil;
}


#pragma mark 网络加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    CCImageBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoading) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithUrl:[self highQualityImageURLForIndex:index] placeHolderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoading = YES;
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    long left = index - 2;
    long right = index + 2;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    //预加载三张图片
    for (long i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (CCImageBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}
#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    CCImageBrowserView *currentView = _scrollView.subviews[index];
    //保存
    if (buttonIndex == 0) {
        [self saveImageWithImage:currentView.imageview.image Success:^(NSInteger status) {
            
        } Error:^(NSInteger status) {
            
        }];
    }else if (buttonIndex == 1){//收藏
        if([self.delegate respondsToSelector:@selector(favoriteImageBrowser:OnIndex:)]){
            [self.delegate favoriteImageBrowser:self OnIndex:index];
        }
    }else{//取消
        
    }
}

#pragma mark 横竖屏设置
- (BOOL)shouldAutorotate
{
    return shouldSupportLandscape;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (shouldSupportLandscape) {
        return UIInterfaceOrientationMaskAll;
    } else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc{
    NSLog(@"dealloc");
}


@end
