//
//  UIViewController+ImageOperation.m
//  Pods
//
//  Created by 黄成 on 15/8/25.
//
//

#import "UIViewController+ImageOperation.h"
#import <objc/runtime.h>

static void * ImageOperationKey;
static void * SuccessBlockKey;
static void * failBlockKey;

@implementation UIViewController (ImageOperation)

- (void)saveImageWithImage:(UIImage*)image Success:(SaveStateBlock)success Error:(SaveStateBlock)failture{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    self.indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    if (success) {
        self.successBlock = success;
    }
    if (failture) {
        self.failBlock = failture;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.50f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 60);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:21];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
        if (self.successBlock) {
            self.successBlock(1);
        }
    }   else {
        label.text = @"保存成功";
        if (self.failBlock) {
            self.failBlock(0);
        }
    }
    
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


- (UIActivityIndicatorView *)indicatorView{
    return objc_getAssociatedObject(self, &ImageOperationKey);
}

- (void)setIndicatorView:(UIActivityIndicatorView *)indicatorView{
    objc_setAssociatedObject(self, &ImageOperationKey, indicatorView, OBJC_ASSOCIATION_COPY);
}

- (SaveStateBlock)successBlock{
    return objc_getAssociatedObject(self, &SuccessBlockKey);
}

- (void)setSuccessBlock:(SaveStateBlock)successBlock{
    objc_setAssociatedObject(self, &SuccessBlockKey, successBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SaveStateBlock)failBlock{
    return objc_getAssociatedObject(self, &failBlockKey);
}

- (void)setFailBlock:(SaveStateBlock)failBlock{
    objc_setAssociatedObject(self, &failBlockKey, failBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
