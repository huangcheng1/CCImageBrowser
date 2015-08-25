//
//  UIViewController+ImageOperation.h
//  Pods
//
//  Created by 黄成 on 15/8/25.
//
//

#import <UIKit/UIKit.h>

typedef void (^SaveStateBlock)(NSInteger status);

@interface UIViewController (ImageOperation)

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) SaveStateBlock successBlock;
@property (nonatomic,strong) SaveStateBlock failBlock;

- (void)saveImageWithImage:(UIImage*)image Success:(SaveStateBlock)success Error:(SaveStateBlock)failture;

@end
