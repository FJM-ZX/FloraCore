//
//  UIView+FrameExpanded.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/12.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "UIView+FrameExpanded.h"

@implementation UIView(FrameExpanded)
-(void)setX:(CGFloat)x{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)height{
    return self.frame.size.height;
}


-(void)setLeft:(CGFloat)left{
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(left, y, width, height);
}
-(CGFloat)left{
    return self.frame.origin.x;
}


-(void)setTop:(CGFloat)top{
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, top, width, height);
}
-(CGFloat)top{
    return self.frame.origin.y;
}

-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize)size {
    return self.frame.size;
}

-(void)setCenter_x:(CGFloat)x{
    self.center = CGPointMake(x, self.center.y);
}
-(CGFloat)center_x{
    return self.center.x;
}

-(void)setCenter_y:(CGFloat)y{
    self.center = CGPointMake(self.center.x, y);
}
-(CGFloat)center_y{
    return self.center.y;
}

//获取当前view所在的controller
- (UIViewController *)controller {
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
@end
