//
//  FYClipMaskView.h
//  FFKit
//
//  Created by fan on 16/7/28.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClipType) {
    ClipTypeSquare,
    ClipTypeCircle,
};

@interface FYClipMaskView : UIView
@property (nonatomic, assign) CGRect clipRect;
@property (nonatomic, assign) ClipType clipType;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, strong) UIColor* maskColor;

@end
