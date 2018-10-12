//
//  UIView+FrameExpanded.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/12.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(FrameExpanded)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat bottom;

@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGFloat center_x;
@property (assign, nonatomic) CGFloat center_y;

//获取当前view所在的controller
- (UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
