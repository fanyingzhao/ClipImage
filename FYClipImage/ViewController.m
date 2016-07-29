//
//  ViewController.m
//  FYClipImage
//
//  Created by fan on 16/7/29.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "ViewController.h"
#import "FYClipView.h"

@interface ViewController () {
    FYClipView* _clipView;
}
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _clipView = [[FYClipView alloc] initWithFrame:self.view.bounds];
    _clipView.image = [UIImage imageNamed:@"clipImage.jpg"];
    _clipView.clipType = ClipTypeCircle;
    [self.view addSubview:_clipView];
    [self.view addSubview:self.imageView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    self.imageView.image = [_clipView clip];
    _clipView.hidden = YES;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:({
            CGRect rect;
            rect.size.width = 200;
            rect.size.height = 200;
            rect.origin.x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = 200;
            rect;
        })];
    }
    return _imageView;
}


@end
