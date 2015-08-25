//
//  CCIndicatorView.m
//  Pods
//
//  Created by 黄成 on 15/8/24.
//
//

#import "CCIndicatorView.h"
#import "CCBrowser.h"

@implementation CCIndicatorView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = kIndicatorBackgroundColor;
        self.clipsToBounds = YES;
        self.viewModel = CCIndicatorCiewModelLoopDiagram;
    }return self;
}

- (void)setProgress:(CGFloat)progress{
    if (progress >=1) {
        [self removeFromSuperview];
    }else{
        _progress = progress;
        [self setNeedsDisplay];
    }
    
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = 42;
    frame.size.height = 42;
    self.layer.cornerRadius = 21;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    [[UIColor whiteColor]set];
    
    switch (self.viewModel) {
        case CCIndicatorCiewModelLoopDiagram:{
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - kIndicatorViewItemMargin;
            
            CGFloat w = radius * 2 + kIndicatorViewItemMargin;
            CGFloat h = w;
            CGFloat x = (rect.size.width - w) * 0.5;
            CGFloat y = (rect.size.height- h) * 0.5;
            
            CGContextAddEllipseInRect(context, CGRectMake(x, y, w, h));
            CGContextFillPath(context);
            
            [kIndicatorBackgroundColor set];
            CGContextMoveToPoint(context, xCenter, yCenter);
            CGContextAddLineToPoint(context, xCenter, 0);
            CGFloat to = -M_PI * 0.5 + self.progress *M_PI * 2 + 0.001;
            CGContextAddArc(context, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
        }break;
        default:
        {
            CGContextSetLineWidth(context, 4);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - kIndicatorViewItemMargin;
            CGContextAddArc(context, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(context);
        }break;
    }
}
@end
