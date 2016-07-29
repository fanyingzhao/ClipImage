//
//  FYClipView.h
//  FFKit
//
//  Created by fan on 16/7/27.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYClipMaskView.h"


@interface FYClipView : UIView

/**
 *  裁剪尺寸，默认是屏幕宽度的正方形
 */
@property (nonatomic, assign) CGSize clipSize;
/**
 *  裁剪类型，默认是正方形
 */
@property (nonatomic, assign) ClipType clipType;
/**
 *  要裁剪的图片
 */
@property (nonatomic, strong) UIImage* image;
/**
 *  线宽，默认是2
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  线的颜色,默认是白色
 */
@property (nonatomic, strong) UIColor* lineColor;
/**
 *  遮罩颜色，默认是黑色，70%透明度
 */
@property (nonatomic, strong) UIColor* maskColor;


/**
 *  裁剪图片
 *
 *  @return 裁剪后的图片
 */
- (UIImage*)clip;

@end
