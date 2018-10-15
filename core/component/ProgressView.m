//
//  ProgressView.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/15.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "ProgressView.h"
@interface ProgressView(){
    UILabel *progressBackLb;
    UILabel *progressBarLb;
    UIView *progressBackgroundTmp;
    UIView *progressBarTmp;
    CGRect viewFrame;
}

@end
@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit
{
    _isScaleBar = NO;
    _roundCornerRadius = 0;
    _isRoundCornerBar = NO;
    viewFrame = self.frame;
    viewFrame.origin.x = viewFrame.origin.y = 0;
    _font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    progressBackgroundTmp = [[UIView alloc] initWithFrame:viewFrame];
    progressBackgroundTmp.backgroundColor = [UIColor grayColor];
    [self addSubview:progressBackgroundTmp];
    
    _backLabelColor = [UIColor blackColor];
    progressBackLb = [[UILabel alloc] initWithFrame:viewFrame];
    progressBackLb.textAlignment = NSTextAlignmentCenter;
    progressBackLb.textColor  = _backLabelColor;
    progressBackLb.font = _font;
    [self addSubview:progressBackLb];
    
    progressBarTmp = [[UIView alloc] initWithFrame:viewFrame];
    progressBarTmp.clipsToBounds = YES;
    [self addSubview:progressBarTmp];
    
    _progressBar = [[UIView alloc] initWithFrame:viewFrame];
    _progressBar.backgroundColor = [UIColor blueColor];
    [progressBarTmp addSubview:_progressBar];
    
    _labelColor = [UIColor whiteColor];
    progressBarLb = [[UILabel alloc] initWithFrame:viewFrame];
    progressBarLb.textAlignment = NSTextAlignmentCenter;
    progressBarLb.textColor  = _labelColor;
    progressBarLb.font = _font;
    [progressBarTmp addSubview:progressBarLb];
    
}
- (void)setRoundCornerRadius:(CGFloat)roundCornerRadius{
    _roundCornerRadius = roundCornerRadius;
    if (_roundCornerRadius>0) {
        self.layer.cornerRadius = _roundCornerRadius;
        self.layer.masksToBounds = YES;

    }else{
        _roundCornerRadius = 0;
    }
}
- (void)setFont:(UIFont *)font{
    _font = font;
    progressBackLb.font = _font;
    progressBarLb.font = _font;
}
- (void)setLabelColor:(UIColor *)labelColor{
    _labelColor = labelColor;
    progressBarLb.textColor  = _labelColor;
}
- (void)setBackLabelColor:(UIColor *)backLabelColor{
    _backLabelColor = backLabelColor;
    progressBackLb.textColor  = _backLabelColor;
}
- (void)setProgressBackground:(UIView *)progressBackground{
    if (_progressBackground && [_progressBackground superview]) {
        [_progressBackground removeFromSuperview];
    }
    _progressBackground = progressBackground;
    progressBackgroundTmp.backgroundColor = [UIColor clearColor];
    [progressBackgroundTmp addSubview:progressBackground];
    progressBackground.frame = progressBackgroundTmp.frame;
}
- (void)setProgressBar:(UIView *)progressBar{
    [_progressBar removeFromSuperview];
    _progressBar = progressBar;
    [progressBarTmp addSubview:progressBar];
    [progressBarTmp bringSubviewToFront:progressBarLb];
    if (_isScaleBar) {
        progressBar.frame = progressBarTmp.frame;
    }else{
        progressBar.frame = viewFrame;
    }
}
- (void)setIsRoundCornerBar:(BOOL)isRoundCornerBar{
    _isRoundCornerBar = isRoundCornerBar;
    if (_isRoundCornerBar) {
        progressBarTmp.layer.cornerRadius = _roundCornerRadius;
        progressBarTmp.layer.masksToBounds = YES;
    }else{
        progressBarTmp.layer.cornerRadius = 0;
        progressBarTmp.layer.masksToBounds = NO;
    }
}
- (void)setIsScaleBar:(BOOL)isScaleBar{
    _isScaleBar = isScaleBar;
    if (_isScaleBar) {
        _progressBar.frame = progressBarTmp.frame;
    }else{
        _progressBar.frame = viewFrame;
    }
}
- (void)setProgressBackgroundColor:(UIColor *)color{
    progressBackgroundTmp.backgroundColor = color;
}
-(void)updateProgress:(CGFloat)progress{
    [self updateProgress:progress isAnimation:NO];
}
-(void)updateProgress:(CGFloat)progress isAnimation:(BOOL)isAnim{
    progress = progress<0?0:progress>1?1:progress;
    __weak typeof(self) weakSelf = self;
    if (isAnim) {
        [progressBarTmp.layer removeAllAnimations];
        [_progressBar.layer removeAllAnimations];
        [UIView animateWithDuration:0.2 animations:^{
            __strong typeof(weakSelf) ws = weakSelf;
            CGRect frame = ws->progressBarTmp.frame;
            frame.size.width = ws->viewFrame.size.width * progress;
            ws->progressBarTmp.frame = frame;
            if (ws->_isScaleBar) {
                ws->_progressBar.frame = ws->progressBarTmp.frame;
            }else{
                ws->_progressBar.frame = ws.frame;
            }
        }];
    }else{
        CGRect frame = progressBarTmp.frame;
        frame.size.width =viewFrame.size.width * progress;
        progressBarTmp.frame = frame;
        if (_isScaleBar) {
            _progressBar.frame = progressBarTmp.frame;
        }else{
            _progressBar.frame = viewFrame;
        }
    }
}
-(void)setProgressLabel:(NSString*)label{
    progressBarLb.text = label?label:@"";
    progressBackLb.text = label?label:@"";
}
@end
