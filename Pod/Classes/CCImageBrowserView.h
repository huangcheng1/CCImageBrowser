//
//  CCImageBrowserView.h
//  Pods
//
//  Created by 黄成 on 15/8/24.
//
//

#import <UIKit/UIKit.h>

typedef void (^SingleTapBlock)(UITapGestureRecognizer *recognizer);
typedef void (^LongPressBlock)(UILongPressGestureRecognizer *recognizer);

@interface CCImageBrowserView : UIView

@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) BOOL beginLoading;

@property (nonatomic,strong) SingleTapBlock tapBlock;
@property (nonatomic,strong) LongPressBlock longPressBlock;

- (void)setImageWithUrl:(NSURL*)url placeHolderImage:(UIImage *)placeHolder;

@end
