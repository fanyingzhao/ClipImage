//
//  FYClipView.m
//  FFKit
//
//  Created by fan on 16/7/27.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYClipView.h"

#define CLIP_MARGIN     0

@interface FYClipView ()<UIScrollViewDelegate> {
    CGRect _clipRect;
}
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) FYClipMaskView* clipView;

@end

@implementation FYClipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _clipRect = ({
            CGRect rect;
            rect.size = self.clipSize;
            rect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect)) / 2;
            rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
    }
    return self;
}

- (void)didMoveToWindow {
    [self addUI];
}

#pragma mark - ui
- (void)addUI {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self addSubview:self.clipView];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    self.scrollView.contentSize = ({
        CGSize size;
        size.width = MAX(_imageView.frame.size.width, CGRectGetWidth(self.bounds) + 1);
        size.height = MAX(CGRectGetMaxY(_imageView.frame) + CGRectGetHeight(self.bounds) - CGRectGetMaxY(_clipRect), CGRectGetHeight(self.bounds) + 1);
        size;
    });

    return self.imageView;
}

#pragma mark - tools
- (CGSize)reCalculateImageSize {
    CGSize resSize;
    
    CGSize size = self.image.size;
    // 计算以哪条边为基准
    CGFloat horizon = size.width / self.clipSize.width;
    CGFloat vetical = size.height / self.clipSize.height;
    if (horizon > vetical) {
        resSize.width = self.clipSize.height * (size.width / size.height);
        resSize.height = self.clipSize.height + 1;
    }else {
        resSize.height = self.clipSize.width * (size.height / size.width);
        resSize.width = self.clipSize.width + 1;
    }
    
    return resSize;
}

- (CGRect)getReallyRectInImage {
    CGRect resRect;
    CGRect rect = [self convertRect:_clipRect toView:self.scrollView];
    CGFloat horizonMin = CGRectGetMinX(rect) / self.imageView.bounds.size.width / self.scrollView.zoomScale;
    CGFloat horizonMax = CGRectGetMaxX(rect) / self.imageView.bounds.size.width / self.scrollView.zoomScale;
    CGFloat voticalMin = self.scrollView.contentOffset.y  / self.imageView.bounds.size.height / self.scrollView.zoomScale;
    CGFloat voticalMax = (self.scrollView.contentOffset.y + CGRectGetHeight(rect)) / self.imageView.bounds.size.height / self.scrollView.zoomScale;
    
    resRect = ({
        CGRect rect;
        rect.origin.x = self.image.size.width * horizonMin;
        rect.origin.y = self.image.size.height * voticalMin;
        rect.size.width = self.image.size.width * (horizonMax - horizonMin);
        rect.size.height = self.image.size.height * (voticalMax - voticalMin);
        rect;
    });
    return resRect;
}

#pragma mark - funcs
- (UIImage *)clip {
    CGRect rect = [self getReallyRectInImage];
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, rect);
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    
    if (self.clipType == ClipTypeCircle) {
        CGRect rect = CGRectMake(0, 0, self.clipSize.width, self.clipSize.height);
        UIGraphicsBeginImageContext(self.clipSize);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextAddArc(context, CGRectGetWidth(_clipRect) / 2, CGRectGetHeight(_clipRect) / 2, CGRectGetWidth(_clipRect) / 2, 0, 2 * M_PI, YES);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextTranslateCTM(context, 0, self.clipSize.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, rect, imageRef);

        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - setter
- (void)setClipType:(ClipType)clipType {
    self.clipView.clipType = _clipType = clipType;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.clipView.lineWidth = _lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor {
    self.clipView.lineColor = _lineColor = lineColor;
}

- (void)setMaskColor:(UIColor *)maskColor {
    self.clipView.maskColor = _maskColor = maskColor;
}

#pragma mark - getter
- (FYClipMaskView *)clipView {
    if (!_clipView) {
        _clipView = [[FYClipMaskView alloc] initWithFrame:self.bounds];
        _clipView.clipRect = _clipRect;
    }
    return _clipView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.maximumZoomScale = 2.0f;
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:({
            CGRect rect;
            rect.size = [self reCalculateImageSize];
            rect.origin.x = 0;
            rect.origin.y = CGRectGetMinY(_clipRect);
            rect;
        })];
        _imageView.image = self.image;
        self.scrollView.contentSize = ({
            CGSize size;
            size.width = MAX(_imageView.bounds.size.width, CGRectGetWidth(self.bounds) + 1);
            size.height = MAX(CGRectGetMaxY(_imageView.frame) + CGRectGetHeight(self.bounds) - CGRectGetMaxY(_clipRect), CGRectGetHeight(self.bounds) + 1);
            size;
        });
    }
    return _imageView;
}

- (CGSize)clipSize {
    if (CGSizeEqualToSize(_clipSize, CGSizeZero)) {
        return ({
            CGSize size;
            size.width = CGRectGetWidth(self.bounds) - CLIP_MARGIN * 2;
            size.height = size.width;
            size;
        });
    }
    
    return _clipSize;
}

@end
