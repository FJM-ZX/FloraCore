//
//  FunBezierRatioVIew.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/12/24.
//  Copyright © 2018 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FunBezierRatioVIew : UIView
-(void)setRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle backColor:(UIColor *)backColor ratios:(NSArray *)ratios colors:(NSArray *)colors animDuration:(CGFloat)animDuration isOverlap:(BOOL)isOverlap;
-(void)setRatios:(NSArray *)ratios;
@end

NS_ASSUME_NONNULL_END
