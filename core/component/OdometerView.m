//
//  OdometerView.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/6/27.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "OdometerView.h"

@interface OdometerView ()
{
    NSNumber *_lastNumber;
    NSMutableArray *_numbersText;       // 保存拆分出来的数字
    NSMutableArray *_scrollLayers;
    NSMutableArray *_scrollLabels;      // 保存label
    
    NSDictionary<NSAttributedStringKey,id> *_attributes;
    NSCache *_fontSizeCache;
}

@end

@implementation OdometerView

#pragma mark - Life Cycle

// 支持 frame 方式和 xib 方式 init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        _attributes = @{NSFontAttributeName: self.font};
        [_fontSizeCache removeAllObjects];
    }
}

#pragma mark - Public Methods

- (void)reloadView
{
    [self prepareAnimations];
}

- (void)startAnimation
{
    [self createAnimations];
}

- (void)stopAnimation
{
    for (CALayer *layer in _scrollLayers) {
        [layer removeAnimationForKey:@"NumberScrollAnimated"];
    }
}

#pragma mark - Private Methods

- (void)commonInit
{
    self.duration = 1.5;
    self.durationOffset = 0.2;
    self.density = 5;
    self.minLength = 0;
    self.isAscending = NO;
    _number = @0;
    _lastNumber = @(-1);
    
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    _numbersText = [NSMutableArray array];
    _scrollLayers = [NSMutableArray array];
    _scrollLabels = [NSMutableArray array];
}

- (void)prepareAnimations
{
    // 先删除旧数据
    for (CALayer *layer in _scrollLayers) {
        [layer removeFromSuperlayer];
    }
    [_numbersText removeAllObjects];
    [_scrollLayers removeAllObjects];
    [_scrollLabels removeAllObjects];
    
    // 配置新的数据和UI
    [self configNumbersText];
}

- (void)configNumbersText
{
    NSString *endingNumberString = [self formatterNumberString:self.number];
    NSString *startNumberString = [self formatterNumberString:_lastNumber];
    NSArray *endingNumberArr = [endingNumberString componentsSeparatedByString:@"."];
    NSArray *startNumberArr = [startNumberString componentsSeparatedByString:@"."];
    NSString *endL = endingNumberArr[0];
    NSString *startL = startNumberArr[0];
    NSString *endR = endingNumberArr.count>1?endingNumberArr[1]:@"";
    NSString *startR = startNumberArr.count>1?startNumberArr[1]:@"";
    
    if (endL.length>startL.length) {
        NSInteger fillZeroLength = endL.length - startL.length;
        for (NSUInteger i = 0; i < fillZeroLength; i++) {
            startL = [NSString stringWithFormat:@"0%@",startL];
        }
    }else if (endL.length<startL.length){
        NSInteger fillZeroLength = startL.length - endL.length;
        for (NSUInteger j = 0; j < fillZeroLength; j++) {
            endL = [NSString stringWithFormat:@"z%@",endL];
        }
    }
    if (endR.length>startR.length) {
        NSInteger fillZeroLength = endR.length - startR.length;
        for (NSUInteger i = 0; i < fillZeroLength; i++) {
            startR = [NSString stringWithFormat:@"%@0",startR];
        }
    }else if (endR.length<startR.length){
        NSInteger fillZeroLength = startR.length - endR.length;
        for (NSUInteger j = 0; j < fillZeroLength; j++) {
            endR = [NSString stringWithFormat:@"%@z",endR];
        }
    }
    if (startR.length>0 || endR.length >0) {
        startNumberString = [[NSString stringWithFormat:@"%@.%@",startL,startR] stringByReplacingOccurrencesOfString:@".z"withString:@"z"];
        endingNumberString = [[NSString stringWithFormat:@"%@.%@",endL,endR] stringByReplacingOccurrencesOfString:@".z"withString:@"z"];
    }else{
        startNumberString = startL;
        endingNumberString = endL;
    }
    
    NSLog(@"[Odometer] startNumberString:%@, endingNumberString:%@", startNumberString, endingNumberString);
    CGSize testSize = [self sizeWithText:@"8"];
    CGFloat dWidth = 0;
    NSInteger len = [endingNumberString length];
    if ([endingNumberString containsString:@"."]) {
        CGSize dSize = [self sizeWithText:@"."];
        dWidth = testSize.width - dSize.width;
    }
    CGRect lastFrame = CGRectZero;
    if (_textAlignment == NSTextAlignmentCenter) {
        lastFrame.size.width = (int)((self.frame.size.width - (testSize.width * len - dWidth))/2);
    }else if (_textAlignment == NSTextAlignmentRight) {
        lastFrame.size.width = (int)(self.frame.size.width - (testSize.width * len - dWidth));
    }
    for(NSUInteger i = 0; i < len; ++i){
        NSString *startDigitsString = [startNumberString substringWithRange:NSMakeRange(i, 1)];
        NSString *endingDigitsString = [endingNumberString substringWithRange:NSMakeRange(i, 1)];
        
        CGSize stringSize = [self sizeWithText:startDigitsString];
        CGFloat width = (int)stringSize.width;
        CGFloat height = (int)stringSize.height;
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(CGRectGetMaxX(lastFrame), CGRectGetMinY(lastFrame), width, height);
        lastFrame = layer.frame;
        [_scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
        
        [self configScrollLayer:layer withStartDigitsString:startDigitsString withEndingDigitsString:endingDigitsString];
        
        [_numbersText addObject:endingDigitsString];
    }
    _lastNumber = _number;
}

- (void)configScrollLayer:(CAScrollLayer *)layer withStartDigitsString:(NSString*)startDigitsString withEndingDigitsString:(NSString*)endingDigitsString
{
    
    NSMutableArray *scrollNumbers = [NSMutableArray array];
    BOOL isAppendSpace = NO;
    if ([endingDigitsString isEqualToString:@"z"]) {
        endingDigitsString = @"0";
        isAppendSpace = YES;
    }
    BOOL isNumber = [self isNumberOfString:startDigitsString];
    if (isNumber) {
        NSInteger numberS = [startDigitsString integerValue];
        NSInteger numberE = [endingDigitsString integerValue];
        for (NSInteger i = numberS; i != numberE; i++) {
            if (i>9) {
                i = -1;
                continue;
            }
            [scrollNumbers addObject:[NSString stringWithFormat:@"%u", (int)i]];
        }
    }
    [scrollNumbers addObject:endingDigitsString];
    if(isAppendSpace){
        [scrollNumbers addObject:@" "];
    }
    
    // 创建 scrollLayer 的内容，数字降序排序
    // 修改局部变量的值需要使用 __block 修饰符
    __block CGFloat height = 0;
    __weak typeof(self) weakSelf = self;
    [scrollNumbers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            UILabel *label = [self createLabel:text];
            label.frame = CGRectMake(0, height, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
            [layer addSublayer:label.layer];
            // 保存label，防止对象被回收
            [strongSelf->_scrollLabels addObject:label];
            // 累加高度
            height = CGRectGetMaxY(label.frame);
        }
    }];
}

- (UILabel *)createLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = text;
    
    return label;
}

- (void)createAnimations
{
    // 第一个 layer 的动画持续时间
    NSTimeInterval duration = self.duration - ((_numbersText.count-1) * self.durationOffset);
    for (CALayer *layer in _scrollLayers) {
        
        CGFloat maxY = [[layer.sublayers lastObject] frame].origin.y;
        // keyPath 是 sublayerTransform ，因为动画应用于 layer 的 subLayer。
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        // 滚动方向
        if (self.isAscending) {
            animation.fromValue = @0;
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        } else {
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        // 添加动画
        [layer addAnimation:animation forKey:@"MSNumberScrollAnimatedView"];
        // 累加动画持续时间
        duration += self.durationOffset;
    }
}

#pragma mark - Setter

- (void)setNumber:(NSNumber *)number
{
    if ([_lastNumber isEqualToNumber:number]) {
        return;
    }
    if ([_lastNumber isEqualToNumber:@(-1)]) {
        _lastNumber = @0;
    }
    _number = number;
    // 准备动画
    [self prepareAnimations];
}
- (void)setupNumber:(NSNumber *)number {
    if ([_lastNumber isEqualToNumber:number]) {
        return;
    }
    [self stopAnimation];
    self.number = number;
    [self startAnimation];
}

- (NSString *)formatterNumberString:(NSNumber *)aNumber {
    NSString *paddedNumber;
    if (self.formatter) {
        paddedNumber = [self.formatter stringFromNumber:aNumber];
    } else {
        paddedNumber = aNumber.stringValue;
    }
    return paddedNumber;
}
- (CGSize)sizeWithText:(NSString*)text {
    
    if ([self isNumberOfString:text]){
        text = @"8";//max width and height
    }
    
    NSValue *value = [_fontSizeCache objectForKey:text];
    if (value){
        return value.CGSizeValue;
    } else {
        CGSize size = [text sizeWithAttributes:_attributes];
        CGFloat width = ceilf(size.width*10)/10;
        CGFloat height = ceilf(size.height*10)/10;
        size.width = width;
        size.height = height;
        [_fontSizeCache setObject:[NSValue valueWithCGSize:size] forKey:text];
        return size;
    }
}
- (BOOL)isNumberOfString:(NSString*)string {
    int intNumber = 0;
    NSScanner *scanNumber = [NSScanner scannerWithString:string];
    BOOL result = [scanNumber scanInt:&intNumber] && [scanNumber isAtEnd];
    return result;
}

@end
