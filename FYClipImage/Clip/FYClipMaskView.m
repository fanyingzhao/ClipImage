//
//  FYClipMaskView.m
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#define UICOLOR_HEX_ALPHA(hex, a)             [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 \
blue:((float)(hex & 0xFF))/255.0 alpha:a]

#import "FYClipMaskView.h"

@implementation FYClipMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);

    [self.lineColor set];
    if (self.clipType == ClipTypeCircle) {
        CGContextAddArc(context, CGRectGetMidX(self.clipRect), CGRectGetMidY(self.clipRect), (CGRectGetWidth(self.clipRect) - self.lineWidth) / 2, 0, 2 * M_PI, YES);
        CGContextStrokePath(context);
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
        CGContextAddArc(context, CGRectGetMidX(self.clipRect), CGRectGetMidY(self.clipRect), (CGRectGetWidth(self.clipRect) - self.lineWidth * 2) / 2, 0, 2 * M_PI, YES);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextDrawPath(context, kCGPathFillStroke);
    }else if (self.clipType == ClipTypeSquare) {
        CGRect rect = ({
            CGRect rect;
            rect.size.width = self.clipRect.size.width - self.lineWidth;
            rect.size.height = self.clipRect.size.height;
            rect.origin.x = self.lineWidth / 2;
            rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2;
            rect;
        });
        CGContextClearRect(context, rect);
        CGContextAddRect(context, rect);
        CGContextStrokePath(context);
    }
}

#pragma mark - init
- (void)setUp {
    self.backgroundColor = self.maskColor;
    self.userInteractionEnabled = NO;
}

#pragma mark - getter
- (CGFloat)lineWidth {
    if (!_lineWidth) {
        _lineWidth = 2.f;
    }
    return _lineWidth;
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor whiteColor];
    }
    return _lineColor;
}

- (UIColor *)maskColor {
    if (!_maskColor) {
        _maskColor = UICOLOR_HEX_ALPHA(0x000000, 0.7);
    }
    return _maskColor;
}
@end
