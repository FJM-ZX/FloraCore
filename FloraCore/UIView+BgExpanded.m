//
//  UIView+BgExpanded.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/17.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "UIView+BgExpanded.h"
#import <objc/runtime.h>
@implementation FJMView
//- (void)drawRect:(CGRect)rect{
//     NSLog(@"%s  %@", __func__, self.class);
//}
@end



static const char radiusKey;
static const char borderWKey;
static const char borderColorKey;
@implementation FJMView (BgExpanded)
+ (void)load{
    [super load];
    static dispatch_once_t onceKey;
    dispatch_once(&onceKey, ^{
        Class class = [self class];
        SEL originalSelector = @selector(drawRect:);
        SEL swizzledSelector = @selector(__drawRect:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
}



-(void)setBorderWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor{
    objc_setAssociatedObject(self, &radiusKey, [NSNumber numberWithFloat:radius], OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &borderWKey, [NSNumber numberWithFloat:borderW], OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &borderColorKey, borderColor, OBJC_ASSOCIATION_RETAIN);
    self.backgroundColor = [UIColor yellowColor];
}
- (void)__drawRect:(CGRect)rect{
    NSLog(@"%s  %@", __func__, self.class);
    NSNumber *radius = objc_getAssociatedObject(self, &radiusKey);
    NSNumber *borderW = objc_getAssociatedObject(self, &borderWKey);
    UIColor *borderColor = objc_getAssociatedObject(self, &borderColorKey);
    if (borderW.floatValue>0 && borderColor) {
        CGFloat rd = [radius floatValue];
        rd = rd>0?rd:0;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        {
            CGRect rect = self.frame;
            rect.origin.x = rect.origin.y = 0;
            UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rd];
            [borderColor setStroke];
            [rectanglePath stroke];
        }
        CGContextRestoreGState(context);
    }
    [self __drawRect:rect];
}
@end
