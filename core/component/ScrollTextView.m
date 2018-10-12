//
//  ScrollTextView.m
//  yoogooIOS
//
//  Created by Fu Jiaming on 2018/5/31.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "ScrollTextView.h"

@interface ScrollTextView(){
    UILabel * _currentScrollLabel;
    UILabel * _standbyScrollLabel;
    NSArray * _LabelArr;
    
    NSInteger _index;
    
    UIFont  * _textFont;
    
    BOOL _needStop;
    BOOL _isRunning;
}

@end

@implementation ScrollTextView

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    _textFont = [UIFont systemFontOfSize:fontSize];
    for (UILabel*lb in _LabelArr) {
        lb.font = _textFont;
    }
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    for (UILabel*lb in _LabelArr) {
        lb.textColor = textColor;
    }
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    for (UILabel*lb in _LabelArr) {
        lb.textAlignment = textAlignment;
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitialSettings];
    }
    return self;
}
- (void)setInitialSettings{
    
    self.clipsToBounds = YES;
    
    _index = 0;
    
    _needStop  = NO;
    _isRunning = NO;
    
    _formatLLKey = nil;
    _textDataArr   = @[];
    
    _textStayTime  = 3;
    _scrollAnimationTime = 1;
    
    
    _fontSize = 12;
    _lineSpace = 3;
    _textFont      = [UIFont systemFontOfSize:_fontSize];
    _textColor     = [UIColor blackColor];
    _textAlignment = NSTextAlignmentLeft;
    
    _currentScrollLabel = nil;
    _standbyScrollLabel = nil;
    _LabelArr = @[];
}
- (void)startScrollBottomToTopWithNoSpace{
    [self stop];
    if (_isRunning) {
        [self performSelector:@selector(startScrollBottomToTopWithNoSpace) withObject:nil afterDelay:0.5f];
        return;
    }
    [self resetStateToEmpty];
    [self createScrollLabelNeedStandbyLabel];
    [self scrollWithNoSpaceByDirection:@(1)];
}
- (void)startScrollTopToBottomWithNoSpace{
    [self stop];
    if (_isRunning) {
        [self performSelector:@selector(startScrollTopToBottomWithNoSpace) withObject:nil afterDelay:0.5f];
        return;
    }
    [self resetStateToEmpty];
    [self createScrollLabelNeedStandbyLabel];
    [self scrollWithNoSpaceByDirection:@(-1)];
}
#pragma mark - Stop
- (void)stop{
    _needStop = YES;
}

- (void)resetStateToEmpty{
    for (UILabel*lb in _LabelArr) {
        [lb removeFromSuperview];
    }
    _LabelArr = @[];
    _currentScrollLabel = nil;
    _standbyScrollLabel = nil;
    
    _index = 0;
    _needStop = NO;
}
- (void)createScrollLabelNeedStandbyLabel{
    self.frame_height = self.frame_height<_fontSize?_fontSize:self.frame_height;
    int count = self.frame.size.height/_fontSize+1;
    count = count<2?2:count;
    for (int idx = 0; idx<count ; idx++) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _fontSize)];
        lb.textAlignment = _textAlignment;
        lb.textColor  = _textColor;
        lb.font = _textFont;
        [self addSubview:lb];
        _LabelArr = [_LabelArr arrayByAddingObject:lb];
    }
    _currentScrollLabel = _LabelArr[0];
    _standbyScrollLabel = _LabelArr[count-1];
}


#pragma mark - Scroll Action
- (void)scrollWithNoSpaceByDirection:(NSNumber *)direction{
    if (_textDataArr.count == 0) {
        _isRunning = NO;
        return;
    }else{
        _isRunning = YES;
    }
    NSInteger dataIdx = _index;
    for (int i=0; i<_LabelArr.count; i++,dataIdx = [self nextIndex:dataIdx]) {
        UILabel *lb = _LabelArr[i];
        if (isBlankString(_formatLLKey)) {
            lb.text = _textDataArr[dataIdx];
        }else{
            lb.text = NSLLKeyFormatString(_formatLLKey,_textDataArr[dataIdx]);
        }
        
        lb.frame_y = (lb.frame_height + _lineSpace)*direction.integerValue*i;
    }

    YGWS(weakSelf);
    [UIView animateWithDuration:_scrollAnimationTime delay:_textStayTime options:UIViewAnimationOptionLayoutSubviews animations:^{
        ScrollTextView *ws = weakSelf;
        if (ws) {
            for (UILabel *lb in ws->_LabelArr) {
                lb.frame_y = lb.frame_y - (lb.frame_height + ws->_lineSpace)*direction.integerValue;
            }
        }
    } completion:^(BOOL finished) {
        ScrollTextView *ws = weakSelf;
        if (ws) {
            ws->_index = [ws nextIndex:ws->_index];
            if (ws->_needStop) {
                ws->_isRunning = NO;
            }else{
                [ws performSelector:@selector(scrollWithNoSpaceByDirection:) withObject:direction];
            }
        }
    }];
}

- (NSInteger)nextIndex:(NSInteger)index{
    NSInteger nextIndex = index + 1;
    if (nextIndex >= _textDataArr.count) {
        nextIndex = 0;
    }
    return nextIndex;
}
@end
