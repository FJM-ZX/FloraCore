//
//  UIImage+Image.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    return [UIImage imageWithColor:color size:size radious:0.0f];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious{
    return [UIImage imageWithColor:color size:size radious:radious borderWidth:0.0f borderColor:[UIColor clearColor]];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat)radious borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor{
    CGFloat *p = nil;
    return [UIImage imageWithColor:color size:size radious:radious borderWidth:borderW borderColor:borderColor borderLineDash:p borderLineDashCount:0];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor borderLineDash:(CGFloat *)lineDash borderLineDashCount:(int)lineDashCount{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (borderW>0) {
        CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
        CGContextSetLineWidth(context, borderW);
        if (lineDashCount>0 && lineDash) {
            CGContextSetLineDash(context, 0, lineDash, lineDashCount);
        }
    }
    if(radious>0){
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderW/2.0, borderW/2.0, size.width - borderW, size.height - borderW) cornerRadius:radious];
        [path fill];
        if (borderW>0) [path stroke];
    }else{
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        if (borderW>0) CGContextStrokeRect(context, CGRectMake(borderW/2.0, borderW/2.0, size.width - borderW, size.height - borderW));
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    UIGraphicsEndImageContext();
    return image;
}
@end
