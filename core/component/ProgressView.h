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
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *backLabelColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIView *progressBar;
@property (nonatomic, strong) UIView *progressBackground;
@property (nonatomic, assign) BOOL isScaleBar;
@property (nonatomic, assign) CGFloat roundCornerRadius;
@property (nonatomic, assign) BOOL isRoundCornerBar;

- (void)setProgressBackgroundColor:(UIColor *)color;

-(void)updateProgress:(CGFloat)progress;
-(void)updateProgress:(CGFloat)progress isAnimation:(BOOL)isAnim;

-(void)setProgressLabel:(NSString*)label;
@end

NS_ASSUME_NONNULL_END
