//
//  UIImage+CreateImage.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CreateImage)
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radious:(CGFloat) radious borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor borderLineDash:(double *)lineDash borderLineDashCount:(int)lineDashCount;

//根据渐变颜色生成图片
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat)radious startVColor:(UIColor*)startColor endVColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat)radious startVColor:(UIColor*)startColor midVColor:(UIColor*)midColor endVColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat)radious startHColor:(UIColor*)startColor endHColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat)radious startHColor:(UIColor*)startColor midHColor:(UIColor*)midColor endHColor:(UIColor*)endColor;

+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat) radious startColor:(UIColor*)startColor endColor:(UIColor*)endColor isH:(BOOL)isH;
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat) radious startColor:(UIColor*)startColor midColor:(UIColor*)midColor endColor:(UIColor*)endColor isH:(BOOL)isH;
+ (UIImage *)imageWithSize:(CGSize)size radious:(CGFloat) radious colors:(NSArray *)colors locations:(CGFloat *)locations isH:(BOOL)isH;

//裁剪圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size;
//裁剪带边框的圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
//裁剪图片自定义圆角
+ (UIImage *)ClipImageWithImage:(UIImage *)image circleSize:(CGSize)size radious:(CGFloat) radious;
//裁剪带边框的图片 可设置圆角 边框颜色
+(UIImage *)ClipImageRadiousWithImage:(UIImage *)image circleSize:(CGSize)size radious:(CGFloat)radious borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor;
//按路径裁剪带边框的图片
+(UIImage *)ClipImagePathWithImage:(UIImage *)image path:(UIBezierPath *)path borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor;

//图片缩小到固定的size
-(UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage*)mergeImage:(UIImage*)img;

//点九图通用处理（中间拉伸）
+ (UIImage *)resizeImage:(NSString *)imageName;
//图片增加文字水印
+ (UIImage *)WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary * )attributed;
//图片增加图片水印
+ (UIImage *)WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
