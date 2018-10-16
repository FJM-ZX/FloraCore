//
//  UIImage+CreateImage.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/*角方向
- ImageRoundCornerNull: 没有
- ImageRoundCornerTopLeft:        上 -- 左
- ImageRoundCornerTopRight:      上 -- 右
- ImageRoundCornerBottomLeft:     下 -- 左
- ImageRoundCornerBottomRight:    下 -- 右
*/
typedef NS_ENUM(NSInteger, ImageRoundCornerDirection) {
    ImageRoundCornerNull        = 0x0000,
    ImageRoundCornerTopLeft     = 0x0001,
    ImageRoundCornerTopRight    = 0x0010,
    ImageRoundCornerBottomLeft  = 0x0100,
    ImageRoundCornerBottomRight = 0x1000,
};

@interface UIImage (CreateImage)
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat) radius;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat) radius borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat) radius borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor borderLineDash:( CGFloat * _Nullable )lineDash borderLineDashCount:(int)lineDashCount;

//根据渐变颜色生成图片
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startVColor:(UIColor*)startColor endVColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startVColor:(UIColor*)startColor midVColor:(UIColor*)midColor endVColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startHColor:(UIColor*)startColor endHColor:(UIColor*)endColor;
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startHColor:(UIColor*)startColor midHColor:(UIColor*)midColor endHColor:(UIColor*)endColor;

+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startColor:(UIColor*)startColor endColor:(UIColor*)endColor isH:(BOOL)isH;
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startColor:(UIColor*)startColor midColor:(UIColor*)midColor endColor:(UIColor*)endColor isH:(BOOL)isH;
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius colors:(NSArray *)colors locations:(CGFloat *)locations isH:(BOOL)isH;

//裁剪圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size;
//裁剪带边框的圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
//裁剪图片自定义圆角
+ (UIImage *)ClipRoundRectImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius;
//裁剪带边框的图片 可设置圆角 边框颜色
+ (UIImage *)ClipRoundRectImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor;
//裁剪图片 分别设置圆角
+ (UIImage *)ClipRoundCornerImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius imageRoundCornerDirection:(ImageRoundCornerDirection)direction;
//裁剪带边框的图片 可设置圆角 边框颜色
+ (UIImage *)ClipRoundCornerImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius imageRoundCornerDirection:(ImageRoundCornerDirection)direction borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor;
//按路径裁剪带边框的图片
+ (UIImage *)ClipImagePathWithImage:(UIImage *)image path:(UIBezierPath *)path borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor;

//图片缩小到固定的size
- (UIImage*)scaleToSize:(CGSize)size;
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
