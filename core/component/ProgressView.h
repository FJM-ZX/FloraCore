//
//  ProgressView.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/15.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView
//进度条上面的字体颜色
@property (nonatomic, strong) UIColor *labelColor;
//进度条外面的字体反差颜色
@property (nonatomic, strong) UIColor *backLabelColor;
//进度字体
@property (nonatomic, strong) UIFont *font;
//进度条（可不设置默认是蓝色填充）
@property (nonatomic, strong) UIView *progressBar;
//进度条背景（可不设置默认是灰色填充）
@property (nonatomic, strong) UIView *progressBackground;
//进度条是缩放模式还是切割模式
@property (nonatomic, assign) BOOL isScaleBar;
//进度条圆角半径
@property (nonatomic, assign) CGFloat roundCornerRadius;
//进度条进度本身是否是圆角
@property (nonatomic, assign) BOOL isRoundCornerBar;
//进度条背景色
- (void)setProgressBackgroundColor:(UIColor *)color;

//更新进度
-(void)updateProgress:(CGFloat)progress;
//更新进度带动画的
-(void)updateProgress:(CGFloat)progress isAnimation:(BOOL)isAnim;
//更新进度文字
-(void)setProgressLabel:(NSString*)label;
@end

NS_ASSUME_NONNULL_END
