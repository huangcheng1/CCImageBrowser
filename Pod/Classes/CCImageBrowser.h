//
//  CCImageBrowser.h
//  Pods
//
//  Created by 黄成 on 15/8/24.
//
//

#import <UIKit/UIKit.h>

@class CCImageBrowser;

@protocol CCImageBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(CCImageBrowser *)browser placeholderImageForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(CCImageBrowser *)browser imageURLForIndex:(NSInteger)index;

- (void)favoriteImageBrowser:(CCImageBrowser*)browser OnIndex:(NSInteger)index;
@end

@interface CCImageBrowser : UIViewController

@property (nonatomic,weak) UIView *sourceImagesContainerView;
@property (nonatomic,assign) int currentImageIndex;
@property (nonatomic,assign) NSInteger imageCount;

@property (nonatomic,weak) id<CCImageBrowserDelegate>delegate;


@end
