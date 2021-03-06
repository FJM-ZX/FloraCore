//
//  FunBezierRatioVIew.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/12/24.
//  Copyright © 2018 Fu Jiaming. All rights reserved.
//

#import "FunBezierRatioVIew.h"

#define kDegreesToRadians(x) (M_PI*(x)/180.0)                 //把角度转换成PI的方式

@interface FunBezierRatioVIew(){
    NSMutableArray *layes;
    CGFloat startAngle;
    CGFloat endAngle;
    BOOL isOverlap;
    CGFloat animDuration;
    CGFloat radius;
}

@end

@implementation FunBezierRatioVIew

-(void)setRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle backColor:(UIColor *)backColor ratios:(NSArray *)ratios colors:(NSArray *)colors animDuration:(CGFloat)animDuration isOverlap:(BOOL)isOverlap{
    while (endAngle<startAngle) {
        endAngle += 360;
    }
    self->startAngle = startAngle;
    self->endAngle = endAngle;
    self->isOverlap = isOverlap;
    self->animDuration = animDuration;
    self->radius = radius;
    CGFloat pathAngle = endAngle - startAngle;
    if (!layes) {
        layes = [NSMutableArray array];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:kDegreesToRadians(startAngle) endAngle:kDegreesToRadians(endAngle) clockwise:YES];
        
        CAShapeLayer *backShapeLayer = [CAShapeLayer layer];
        backShapeLayer.path = path.CGPath;
        backShapeLayer.lineWidth = lineWidth;
        backShapeLayer.strokeColor = backColor.CGColor;
        backShapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:backShapeLayer];
    }else{
        for (CAShapeLayer *layer in layes) {
            [layer removeFromSuperlayer];
        }
        [layes removeAllObjects];
    }
    
    
    CABasicAnimation *animation;
    if (animDuration>0) {
        animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = animDuration;
        animation.fromValue = @0;
        animation.toValue = @1;
    }
    CGFloat proAng = startAngle;
    for (int idx = 0; idx < ratios.count && idx < colors.count; idx ++) {
        UIBezierPath *proPath;
        CGFloat ang = [ratios[idx] floatValue] * pathAngle;

        if (isOverlap) {
            proAng += ang;
            proPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:kDegreesToRadians(startAngle) endAngle:kDegreesToRadians(proAng) clockwise:YES];
        }else{
            proPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:kDegreesToRadians(proAng) endAngle:kDegreesToRadians(proAng+ang) clockwise:YES];
            proAng += ang;
        }

        CAShapeLayer *proShapeLayer = [CAShapeLayer layer];
        proShapeLayer.lineWidth = lineWidth;
        proShapeLayer.strokeColor = ((UIColor *)colors[idx]).CGColor;
        proShapeLayer.fillColor = [UIColor clearColor].CGColor;
        proShapeLayer.path = proPath.CGPath;
        [self.layer insertSublayer:proShapeLayer atIndex:1];
        if (animation) {
            [proShapeLayer addAnimation:animation forKey:nil];
        }
        [layes addObject:proShapeLayer];
    }

}
-(void)setRatios:(NSArray *)ratios{
    CGFloat pathAngle = endAngle - startAngle;
    if (layes.count != ratios.count) {
        return;
    }
    CABasicAnimation *animation;
    if (animDuration>0) {
        animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = animDuration;
        animation.fromValue = @0;
        animation.toValue = @1;
    }
    CGFloat proAng = startAngle;
    for (int idx = 0; idx < ratios.count; idx ++) {
        UIBezierPath *proPath;
        CGFloat ang = [ratios[idx] floatValue] * pathAngle;
        
        if (isOverlap) {
            proAng += ang;
            proPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:kDegreesToRadians(startAngle) endAngle:kDegreesToRadians(proAng) clockwise:YES];
        }else{
            proPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:kDegreesToRadians(proAng) endAngle:kDegreesToRadians(proAng+ang) clockwise:YES];
            proAng += ang;
        }
        CAShapeLayer *proShapeLayer = layes[idx];
        proShapeLayer.path = proPath.CGPath;
        if (animation) {
            [proShapeLayer addAnimation:animation forKey:nil];
        }
    }
}
@end
