//
//  UIImage+CreateImage.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "UIImage+CreateImage.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
@implementation UIImage (CreateImage)
//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    return [UIImage imageWithColor:color size:size radius:0.0f];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat) radius{
    return [UIImage imageWithColor:color size:size radius:radius borderWidth:0.0f borderColor:[UIColor clearColor]];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor{
    return [UIImage imageWithColor:color size:size radius:radius borderWidth:borderW borderColor:borderColor borderLineDash:NULL borderLineDashCount:0];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat) radius borderWidth:(CGFloat)borderW borderColor:(UIColor *)borderColor borderLineDash:(CGFloat *)lineDash borderLineDashCount:(int)lineDashCount{
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
    if(radius>0){
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderW/2.0, borderW/2.0, size.width - borderW, size.height - borderW) cornerRadius:radius];
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

+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startVColor:(UIColor*)startColor
                 endVColor:(UIColor*)endColor{
    return [UIImage imageWithSize:size radius:radius startColor:startColor endColor:endColor isH:YES];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startHColor:(UIColor*)startColor
                 endHColor:(UIColor*)endColor{
    return [UIImage imageWithSize:size radius:radius startColor:startColor endColor:endColor isH:NO];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat)radius startColor:(UIColor*)startColor
                  endColor:(UIColor*)endColor isH:(BOOL)isH{
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) [startColor CGColor], (__bridge id) [endColor CGColor]];
    return [UIImage imageWithSize:size radius:radius colors:colors locations:locations isH:isH];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat) radius startVColor:(UIColor*)startColor midVColor:(UIColor*)midColor
                 endVColor:(UIColor*)endColor{
    return [UIImage imageWithSize:size radius:radius startColor:startColor midColor:midColor endColor:endColor isH:NO];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat) radius startHColor:(UIColor*)startColor midHColor:(UIColor*)midColor
                 endHColor:(UIColor*)endColor{
    return [UIImage imageWithSize:size radius:radius startColor:startColor midColor:midColor endColor:endColor isH:YES];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat) radius startColor:(UIColor*)startColor midColor:(UIColor*)midColor
                  endColor:(UIColor*)endColor isH:(BOOL)isH{
    CGFloat locations[] = { 0.0, 0.5, 1.0 };
    NSArray *colors = @[(__bridge id) [startColor CGColor], (__bridge id) [midColor CGColor], (__bridge id) [endColor CGColor]];
    return [UIImage imageWithSize:size radius:radius colors:colors locations:locations isH:isH];
}
+ (UIImage *)imageWithSize:(CGSize)size radius:(CGFloat) radius colors:(NSArray *)colors locations:(CGFloat *)locations isH:(BOOL)isH{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox([path CGPath]);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    if (isH) {
        startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
        endPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMaxY(pathRect));
    }
    CGContextSaveGState(context);
    CGContextAddPath(context, [path CGPath]);
    CGContextEOClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)scaleToSize:(CGSize)size{
    size = CGSizeMake(size.width  , size.height );
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, size.width , size.height )];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//裁剪圆形
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    return  [UIImage ClipImagePathWithImage:image path:path borderWith:0 borderColor:[UIColor clearColor]];
}
//裁剪带边框的圆形图片
+ (UIImage *)ClipCircleImageWithImage:(UIImage *)image circleSize:(CGSize)size borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW * 0.5 , borderW * 0.5 , size.width - borderW, size.height - borderW)];
    return  [UIImage ClipImagePathWithImage:image path:path borderWith:borderW borderColor:borderColor];
    
}
//裁剪图片 可设置圆角
+ (UIImage *)ClipRoundRectImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    return  [UIImage ClipImagePathWithImage:image path:path borderWith:0 borderColor:[UIColor clearColor]];
}
//裁剪带边框的图片 可设置圆角 边框颜色
+(UIImage *)ClipRoundRectImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderW * 0.5 , borderW * 0.5 , size.width - borderW, size.height - borderW) cornerRadius:radius];
    return  [UIImage ClipImagePathWithImage:image path:path borderWith:borderW borderColor:borderColor];
}
//裁剪图片 分别设置圆角
+ (UIImage *)ClipRoundCornerImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat) radius imageRoundCornerDirection:(ImageRoundCornerDirection)direction{
    return  [UIImage ClipRoundCornerImageWithImage:image size:size radius:radius imageRoundCornerDirection:direction borderWith:0 borderColor:[UIColor clearColor]];
}
//裁剪带边框的图片 可设置圆角 边框颜色
+(UIImage *)ClipRoundCornerImageWithImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius imageRoundCornerDirection:(ImageRoundCornerDirection)direction borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    UIBezierPath * path;
    if (direction == ImageRoundCornerNull) {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    }else{
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, size.height/2)];
        if((direction & ImageRoundCornerTopLeft) > 0) {
            [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
        }else{
            [path addLineToPoint:CGPointZero];
        }
        if((direction & ImageRoundCornerTopRight) > 0) {
            [path addArcWithCenter:CGPointMake(size.width - radius, radius) radius:radius startAngle:3*M_PI/2 endAngle:2*M_PI clockwise:YES];
        }else{
            [path addLineToPoint:CGPointMake(size.width, 0)];
        }
        if((direction & ImageRoundCornerBottomRight) > 0) {
            [path addArcWithCenter:CGPointMake(size.width - radius, size.height - radius) radius:radius startAngle:0 endAngle:M_PI/2 clockwise:YES];
        }else{
            [path addLineToPoint:CGPointMake(size.width, size.height)];
        }
        if((direction & ImageRoundCornerBottomLeft) > 0) {
            [path addArcWithCenter:CGPointMake(radius, size.height - radius) radius:radius startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
        }else{
            [path addLineToPoint:CGPointMake(0, size.height)];
        }
        [path closePath];
    }
    return  [UIImage ClipImagePathWithImage:image path:path borderWith:borderW borderColor:borderColor];
}

//按路径裁剪带边框的图片
+(UIImage *)ClipImagePathWithImage:(UIImage *)image path:(UIBezierPath *)path borderWith:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    borderW = borderW<0 ? -borderW : borderW;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [path addClip];
    [image drawAtPoint:CGPointZero];
    if (borderW>0) {
        [borderColor setStroke];
        path.lineWidth = borderW*2.0;
        [path stroke];
    }
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)mergeImage:(UIImage*)img{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [self drawAtPoint:CGPointZero];
    CGPoint p = CGPointMake((self.size.width - img.size.width)/2, (self.size.height - img.size.height)/2);
    [img drawAtPoint:p];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:imageW topCapHeight:imageH];
}

+ (UIImage *)WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributed:(NSDictionary * )attributed{
    return [UIImage WaterImageWithImage:image text:text textRect:CGRectMake(point.x, point.y, 0, 0) attributed:attributed];
}
+ (UIImage *)WaterImageWithImage:(UIImage *)image text:(NSString *)text textRect:(CGRect)textRect attributed:(NSDictionary * )attributed{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    if (textRect.size.width <= 0 || textRect.size.height <= 0 ) {
        [text drawAtPoint:textRect.origin withAttributes:attributed];
    }else{
        [text drawInRect:textRect withAttributes:attributed];
    }
    
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}
+ (UIImage *)WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect{
    //1.获取图片
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

+ (UIImage *)CreateShadowImageWithSize:(CGSize)size color:(UIColor*)color offset:(CGSize)offset blur:(CGFloat)blur radius:(CGFloat)radius{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width+fabs(offset.width)+blur*2.0, size.height+fabs(offset.height)+blur*2.0), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGFloat x = blur-offset.width;
    x = x<0?0:x;
    CGFloat y = blur-offset.height;
    y = y<0?0:y;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, size.width, size.height) cornerRadius:radius];
    CGContextAddPath(context, [path CGPath]);
    CGContextSetShadow(context,offset,blur);
    CGContextFillPath(context);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
