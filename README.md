# CCImageBrowser

[![CI Status](http://img.shields.io/travis/huangcheng/CCImageBrowser.svg?style=flat)](https://travis-ci.org/huangcheng/CCImageBrowser)
[![Version](https://img.shields.io/cocoapods/v/CCImageBrowser.svg?style=flat)](http://cocoapods.org/pods/CCImageBrowser)
[![License](https://img.shields.io/cocoapods/l/CCImageBrowser.svg?style=flat)](http://cocoapods.org/pods/CCImageBrowser)
[![Platform](https://img.shields.io/cocoapods/p/CCImageBrowser.svg?style=flat)](http://cocoapods.org/pods/CCImageBrowser)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CCImageBrowser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CCImageBrowser"
```

## Author

huangcheng, huangcheng@souche.com

## Use

初始化

```
    
    CCImageBrowser *browser = [[CCImageBrowser alloc]init];
    browser.delegate = self;
    browser.imageCount = [self.array count];
    browser.currentImageIndex = index;
    
    self.imageBrowser = browser;
    UIViewController *controller = [webview fintParentController];
    [controller presentViewController:self.imageBrowser animated:NO completion:nil];
```

实现协议

```
CCImageBrowserDelegate
- (UIImage *)photoBrowser:(CCImageBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return [UIImage imageNamed:CNNAucImage(kAucCarDefaultImage)];
}

- (NSURL *)photoBrowser:(CCImageBrowser *)browser imageURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:[self.array objectAtIndex:index]];
}
```

## License

CCImageBrowser is available under the MIT license. See the LICENSE file for more info.
