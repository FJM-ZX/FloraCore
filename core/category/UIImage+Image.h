//
//  UIImage+Image.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Image)
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor borderLineDash:(double *)lineDash borderLineDashCount:(int)lineDashCount;
@end

NS_ASSUME_NONNULL_END
