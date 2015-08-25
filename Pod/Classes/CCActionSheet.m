//
//  CCActionSheet.m
//  Pods
//
//  Created by 黄成 on 15/8/25.
//
//

#import "CCActionSheet.h"

@implementation CCActionSheet

- (instancetype)initWithDelegate:(id<UIActionSheetDelegate>)delegate{
    
    self = [super initWithTitle:nil delegate:delegate cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存",@"收藏", nil];
    
    if (self) {
    }
    
    return self;
}

- (void)showInView:(UIView *)view{
    [super showInView:view];
}
@end
