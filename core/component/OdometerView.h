//
//  OdometerView.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/6/27.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OdometerView : UIView
@property (nonatomic, strong) NSNumber *number;
@property (strong, nonatomic, nullable) NSNumberFormatter *formatter;
// 样式相关
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSUInteger density;               // 滚动数字的密度
@property (nonatomic, assign) NSUInteger minLength;             // 最小显示长度，不够补零
// 动画相关
@property (nonatomic, assign) NSTimeInterval duration;          // 动画总持续时间
@property (nonatomic, assign) NSTimeInterval durationOffset;    // 相邻两个数字动画持续时间间隔
@property (nonatomic, assign) BOOL isAscending;                 // 方向，默认为NO，向下

- (void)reloadView;
- (void)startAnimation;
- (void)stopAnimation;

- (void)setupNumber:(NSNumber *)number;
@end
