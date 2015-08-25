//
//  CCViewController.m
//  CCImageBrowser
//
//  Created by huangcheng on 08/24/2015.
//  Copyright (c) 2015 huangcheng. All rights reserved.
//

#import "CCViewController.h"
#import "CCImageBrowser.h"
#import "CCBrowser.h"
#import "UIButton+WebCache.h"

@interface CCViewController ()<CCImageBrowserDelegate>

@property (nonatomic, strong) NSArray *srcStringArray;
@property (nonatomic,strong) UIScrollView *scroll;

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    
    _srcStringArray = @[
                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
                        ];
    
    CGFloat starty = 0;
    NSInteger tag = 0;
    for (NSString *url in _srcStringArray) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, starty, 120, 120)];
        [btn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        [self.scroll addSubview:btn];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = tag;
        [btn addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
        
        
        starty = starty + 130;
        tag ++;
        
    }
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, starty + 50)];
    [self.view addSubview:self.scroll];
    
}

- (void)openBrowser:(id)sender{
    UIButton *btn = (UIButton*)sender;
    
    //启动图片浏览器
    CCImageBrowser *browserVc = [[CCImageBrowser alloc] init];
    browserVc.sourceImagesContainerView = self.scroll; // 原图的父控件
    browserVc.imageCount = self.srcStringArray.count; // 图片总数
    browserVc.currentImageIndex = (int)btn.tag;
    browserVc.delegate = self;
    [self presentViewController:browserVc animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(CCImageBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    for (UIButton *btn in self.scroll.subviews) {
        if (btn.tag == index) {
            return btn.imageView.image;
        }
    }
    return [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.srcStringArray[index]]]];
}

- (NSURL *)photoBrowser:(CCImageBrowser *)browser imageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.srcStringArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}
@end
