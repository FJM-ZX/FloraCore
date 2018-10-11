//
//  AdaptiveContainerView.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/9/29.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "AdaptiveContainerView.h"

#define LR_CONTENT_LABEL_MIN_WIDTH (60)
#define LR_CONTENT_LABEL_MIN_HIGHT (30)
#define LR_CONTENT_LABEL_OFFSET (15)

#define LR_ARROW_HIGHT (8)

/**
 对话框箭头方向
 - LRFloatTipsArrowDirectionTopLeft:        上 -- 左
 - LRFloatTipsArrowDirectionTopCenter:      上 -- 中
 - LRFloatTipsArrowDirectionTopRight:       上 -- 右
 - LRFloatTipsArrowDirectionBottomLeft:     下 -- 左
 - LRFloatTipsArrowDirectionBottomCenter:   下 -- 中
 - LRFloatTipsArrowDirectionBottomRight:    下 -- 右
 */
typedef NS_ENUM(NSInteger, LRFloatTipsArrowDirection) {
    LRFloatTipsArrowDirectionTopLeft        = 0,
    LRFloatTipsArrowDirectionTopCenter,
    LRFloatTipsArrowDirectionTopRight,
    LRFloatTipsArrowDirectionBottomLeft,
    LRFloatTipsArrowDirectionBottomCenter,
    LRFloatTipsArrowDirectionBottomRight,
};
/**
 可设置文字内边距的 label
 */
@interface ACLabel :UILabel

@property (nonatomic, assign)UIEdgeInsets textInsets; // 控制字体与控件边界的间隙

@end


@implementation ACLabel

- (instancetype)init
{
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    _textInsets = textInsets;
    
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
@interface AdaptiveContainerView(){
    CGFloat     _screenW;       //  [UIScreen mainScreen].bounds.size.width
    CGFloat     _screenH;       //  [UIScreen mainScreen].bounds.size.height)
    
    BOOL        _isLeft;        // arrow is left?
    BOOL        _isTop;         // arrow is top ?
}
@property (nonatomic, assign)CGPoint        viewOrigin;     // 需要显示tips的View的(x,y)
@property (nonatomic, assign)CGSize         viewSize;       // 需要显示tips的View的(w,h)
@property (nonatomic, assign)CGSize         contentSize;    // tips内容大小 (w,h)
@property (nonatomic, strong)NSDictionary    *attributes;

@property (nonatomic, strong)ACLabel        *contentL;      // show tips label
@property (nonatomic, strong)UIView        *contentV;      // show tips label
@property (nonatomic, assign)LRFloatTipsArrowDirection  arrowDirection;

@end

@implementation AdaptiveContainerView
- (instancetype)initWithView:(UIView *)forView content:(NSString *)content
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        NSAssert(forView, @"toView must not be nil");
        self.backgroundColor = [UIColor clearColor];
        _screenW = [UIScreen mainScreen].bounds.size.width;
        _screenH = [UIScreen mainScreen].bounds.size.height;
        
        CGRect frame = [self getViewFrameToWindow:forView];
        self.contentSize = [self calculateContentSize:content];
        self.viewOrigin = frame.origin;
        self.viewSize = frame.size;
        [self adjustArrowDirection];
        
        self.contentV = self.contentL;
        [self addSubview:self.contentL];
        self.contentL.attributedText = [[NSAttributedString alloc] initWithString:content attributes:self.attributes];
    }
    return self;
}
- (instancetype)initWithView:(UIView *)forView contentView:(UIView *)contentView
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        NSAssert(forView, @"toView must not be nil");
        self.backgroundColor = [UIColor clearColor];
        _screenW = [UIScreen mainScreen].bounds.size.width;
        _screenH = [UIScreen mainScreen].bounds.size.height;
        
        CGRect frame = [self getViewFrameToWindow:forView];
        self.contentSize = contentView.frame.size;
        self.viewOrigin = frame.origin;
        self.viewSize = frame.size;
        [self adjustArrowDirection];
        
        self.contentV = contentView;
        [self addSubview:contentView];
        contentView.frame = [self getContentFrame];
    }
    return self;
}


#pragma mark --- Private Method

- (CGSize )calculateContentSize:(NSString *)string
{
    CGSize  strSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, LR_CONTENT_LABEL_MIN_HIGHT)  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)  attributes:self.attributes context:nil].size;
    
    CGFloat w = strSize.width + LR_CONTENT_LABEL_OFFSET; // 加上一点，为了美观
    if (w > (_screenW - 30)) {// 若计算后的文字长度超过最大长度，则以最大长度计算高度
        w = _screenW - 30;
        strSize = [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT)  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)  attributes:self.attributes context:nil].size;
    }
    
    CGFloat h = strSize.height + LR_CONTENT_LABEL_OFFSET;
    
    if (h < LR_CONTENT_LABEL_MIN_HIGHT) {
        h = LR_CONTENT_LABEL_MIN_HIGHT;
    }
    
    if (w < LR_CONTENT_LABEL_MIN_WIDTH) {
        w = LR_CONTENT_LABEL_MIN_WIDTH;
    }
    
    return CGSizeMake(w, h);
}

- (void)adjustArrowDirection
{
    CGFloat centerX = self.viewOrigin.x + self.viewSize.width*0.5;
    CGFloat centerY = self.viewOrigin.y + self.viewSize.height*0.5;
    
    if (centerY < _screenH*0.2) {
        _isTop = YES;
        CGFloat offsetR = centerX + self.contentSize.width*0.5;

        if (offsetR > (_screenW-LR_CONTENT_LABEL_OFFSET)) {
            _isLeft = NO;
            self.arrowDirection = LRFloatTipsArrowDirectionTopRight;
            return;
        }
        CGFloat offsetL = centerX - self.contentSize.width*0.5;
        if (offsetL < LR_CONTENT_LABEL_OFFSET) {
            _isLeft = YES;
            self.arrowDirection = LRFloatTipsArrowDirectionTopLeft;
            return;
        }
        self.arrowDirection = LRFloatTipsArrowDirectionTopCenter;
        return;
    }
    
    _isTop = NO;
    CGFloat offsetR = centerX + self.contentSize.width*0.5;

    if (offsetR > (_screenW-LR_CONTENT_LABEL_OFFSET)) {
        _isLeft = NO;
        self.arrowDirection = LRFloatTipsArrowDirectionBottomRight;
        return;
    }
    
    CGFloat offsetL = centerX - self.contentSize.width*0.5;
    if (offsetL < 15) {
        _isLeft = YES;
        self.arrowDirection = LRFloatTipsArrowDirectionBottomLeft;
        return;
    }
    self.arrowDirection = LRFloatTipsArrowDirectionBottomCenter;
}

- (void)dismissView
{
    if(self.contentV){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.contentV removeFromSuperview];
            [self removeFromSuperview];
            self.contentV = nil;
        }];
    }else if (self.contentL) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.contentL removeFromSuperview];
            [self removeFromSuperview];
            self.contentL = nil;
        }];
    }
}

- (void)showView
{
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (CGRect )getContentFrame
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    switch (self.arrowDirection) {
        case LRFloatTipsArrowDirectionTopLeft:{
            x = LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionTopCenter:{
            x = self.viewOrigin.x + self.viewSize.width*0.5 - self.contentSize.width*0.5;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionTopRight:{
            x = _screenW - self.contentSize.width - LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y + self.viewSize.height + LR_ARROW_HIGHT;
            break;
        }
        case LRFloatTipsArrowDirectionBottomLeft:{
            x = LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
        case LRFloatTipsArrowDirectionBottomCenter:{
            x = self.viewOrigin.x + self.viewSize.width*0.5 - self.contentSize.width*0.5;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
        case LRFloatTipsArrowDirectionBottomRight:{
            x = _screenW - self.contentSize.width - LR_CONTENT_LABEL_OFFSET;
            y = self.viewOrigin.y - LR_ARROW_HIGHT - self.contentSize.height;
            break;
        }
    }
    
    return CGRectMake(x, y, self.contentSize.width, self.contentSize.height);
}

- (CGRect )getViewFrameToWindow:(UIView *)view
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (view.superview) {
        return [view.superview convertRect:view.frame toView:window];
    }
    
    return CGRectZero;
}
-(UIBezierPath *)getBezierPathWithRect:(CGRect)rect arrowPos:(CGPoint)pos radius:(CGFloat)radius angleWidth:(CGFloat)angleWidth{
    UIBezierPath *rectanglePath = [UIBezierPath bezierPath];
    rectanglePath.lineWidth = 1;
    rectanglePath.lineCapStyle = kCGLineCapRound;
    rectanglePath.lineJoinStyle = kCGLineJoinRound;
    CGPoint cnPos[6];
    int startAngle = 0;
    if (pos.x < rect.origin.x) {
        pos.x = rect.origin.x - angleWidth/2;
        if (pos.y<rect.origin.y+radius) {
            pos.y = rect.origin.y+radius;
        }else if (pos.y>rect.origin.y+rect.size.height-radius){
            pos.y = rect.origin.y+rect.size.height-radius;
        }
        float dy = pos.y - rect.origin.y+radius;
        float dh = rect.size.height-radius*2;
        cnPos[0] = CGPointMake(rect.origin.x, pos.y - angleWidth * dy / dh);
        cnPos[1] = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
        cnPos[2] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + radius);
        cnPos[3] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius);
        cnPos[4] = CGPointMake(rect.origin.x + radius, rect.origin.y + rect.size.height - radius);
        cnPos[5] = CGPointMake(rect.origin.x, pos.y + angleWidth * (1.0 - dy / dh));
        startAngle = 2;
    }else if (pos.x > rect.origin.x + rect.size.width) {
        pos.x =  rect.origin.x + rect.size.width + angleWidth/2;
        if (pos.y<rect.origin.y+radius) {
            pos.y = rect.origin.y+radius;
        }else if (pos.y>rect.origin.y+rect.size.height-radius){
            pos.y = rect.origin.y+rect.size.height-radius;
        }
        float dy = pos.y - rect.origin.y+radius;
        float dh = rect.size.height-radius*2;
        cnPos[0] = CGPointMake(rect.origin.x + rect.size.width, pos.y + angleWidth * (1.0 - dy / dh));
        cnPos[1] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius);
        cnPos[2] = CGPointMake(rect.origin.x + radius, rect.origin.y + rect.size.height - radius);
        cnPos[3] = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
        cnPos[4] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + radius);
        cnPos[5] = CGPointMake(rect.origin.x + rect.size.width, pos.y - angleWidth * dy / dh);
        startAngle = 0;
    }else if (pos.y < rect.origin.y) {
        pos.y = rect.origin.y - angleWidth/2;
        if (pos.x<rect.origin.x+radius) {
            pos.x = rect.origin.x+radius;
        }else if (pos.x>rect.origin.x+rect.size.width-radius){
            pos.x = rect.origin.x+rect.size.width-radius;
        }
        float dx = pos.x - rect.origin.x+radius;
        float dw = rect.size.width-radius*2;
        cnPos[0] = CGPointMake(pos.x + angleWidth * (1.0 - dx / dw), rect.origin.y);
        cnPos[1] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + radius);
        cnPos[2] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius);
        cnPos[3] = CGPointMake(rect.origin.x + radius, rect.origin.y + rect.size.height - radius);
        cnPos[4] = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
        cnPos[5] = CGPointMake(pos.x - angleWidth * dx / dw, rect.origin.y);
        startAngle = 3;
    }else if (pos.y > rect.origin.y + rect.size.height) {
        pos.y = rect.origin.y + rect.size.height + angleWidth/2;
        if (pos.x<rect.origin.x+radius) {
            pos.x = rect.origin.x+radius;
        }else if (pos.x>rect.origin.x+rect.size.width-radius){
            pos.x = rect.origin.x+rect.size.width-radius;
        }
        float dx = pos.x - rect.origin.x+radius;
        float dw = rect.size.width-radius*2;
        cnPos[0] = CGPointMake(pos.x - angleWidth * dx / dw, rect.origin.y + rect.size.height);
        cnPos[1] = CGPointMake(rect.origin.x + radius, rect.origin.y + rect.size.height - radius);
        cnPos[2] = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
        cnPos[3] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + radius);
        cnPos[4] = CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius);
        cnPos[5] = CGPointMake(pos.x + angleWidth * (1.0 - dx / dw), rect.origin.y + rect.size.height);
        startAngle = 1;
    }else{
        
    }
    [rectanglePath moveToPoint:pos];
    [rectanglePath addLineToPoint:cnPos[0]];
    [rectanglePath addArcWithCenter:cnPos[1] radius:radius startAngle:startAngle*M_PI/2 endAngle:((startAngle+1)%4)*M_PI/2 clockwise:YES];
    startAngle++;
    [rectanglePath addArcWithCenter:cnPos[2] radius:radius startAngle:startAngle*M_PI/2 endAngle:((startAngle+1)%4)*M_PI/2 clockwise:YES];
    startAngle++;
    [rectanglePath addArcWithCenter:cnPos[3] radius:radius startAngle:startAngle*M_PI/2 endAngle:((startAngle+1)%4)*M_PI/2 clockwise:YES];
    startAngle++;
    [rectanglePath addArcWithCenter:cnPos[4] radius:radius startAngle:startAngle*M_PI/2 endAngle:((startAngle+1)%4)*M_PI/2 clockwise:YES];
    [rectanglePath addLineToPoint:cnPos[5]];
    [rectanglePath closePath];
    return rectanglePath;
}
-(void)drawContent:(CGContextRef)context rect:(CGRect)rect pos:(CGPoint)pos bgClr:(UIColor *)clr alpha:(CGFloat)alpha{
    CGContextSaveGState(context);
    {
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowColor = UIColor.blackColor;
        shadow.shadowOffset = CGSizeMake(0, 0);
        shadow.shadowBlurRadius = 5;
        
        UIBezierPath *rectanglePath = [self getBezierPathWithRect:rect arrowPos:pos radius:6 angleWidth:20];
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
        
        CGContextSetAlpha(context, alpha);
        CGContextBeginTransparencyLayer(context, NULL);
        {
            UIColor* opaqueShadow = [shadow.shadowColor colorWithAlphaComponent: 0.5];
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
            [clr set];
            [rectanglePath fill];
        }
        CGContextEndTransparencyLayer(context);
    }
    CGContextRestoreGState(context);
}
#pragma mark --- System Method

// 画箭头
- (void)drawRect:(CGRect)rect {
    
    if (self.isHidden) {
        return ;
    }
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColor.blackColor;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowBlurRadius = 5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.arrowDirection) {
        case LRFloatTipsArrowDirectionTopLeft:
        case LRFloatTipsArrowDirectionTopCenter:
        case LRFloatTipsArrowDirectionTopRight:{
            {
                CGFloat startX = self.viewOrigin.x + self.viewSize.width*0.5;
                CGFloat startY = self.viewOrigin.y + self.viewSize.height;
                [self drawContent:context rect:[self getContentFrame] pos:CGPointMake(startX, startY) bgClr:[UIColor whiteColor] alpha:1];
            }
            break;
        }
        case LRFloatTipsArrowDirectionBottomLeft:
        case LRFloatTipsArrowDirectionBottomCenter:
        case LRFloatTipsArrowDirectionBottomRight: {
            {
                CGFloat startX = self.viewOrigin.x + self.viewSize.width*0.5;
                CGFloat startY = self.viewOrigin.y;
                [self drawContent:context rect:[self getContentFrame] pos:CGPointMake(startX, startY) bgClr:[UIColor whiteColor] alpha:1];
            }
            break;
        }
    }
}

// 点击视图，退出
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint([self getContentFrame],[[touches anyObject] locationInView:self])) {
        [self dismissView];
    }
}

#pragma mark ---  Setter & Getter

- (ACLabel *)contentL
{
    if (!_contentL) {
        _contentL = [[ACLabel alloc] initWithFrame:[self getContentFrame]];
        _contentL.backgroundColor = [UIColor clearColor];
        _contentL.numberOfLines = 0;
        _contentL.textColor = [UIColor blackColor];
        _contentL.textInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _contentL.userInteractionEnabled = YES;
    }
    return _contentL;
}

- (NSDictionary *)attributes
{
    if (!_attributes) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3;// 字体的行间距
        paragraphStyle.alignment = NSTextAlignmentLeft;
        _attributes = @{
                        NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                        NSParagraphStyleAttributeName:paragraphStyle,
                        };
    }
    return _attributes;
}

#pragma mark ---  Public Method

+ (void)addTipsForView:(UIView *)forView content:(NSString *)content
{
    AdaptiveContainerView *tips = [[AdaptiveContainerView alloc] initWithView:forView content:content];
    [tips showView];
}


+ (void)addTipsForView:(UIView *)forView content:(NSString *)content afterDelay:(NSTimeInterval)delay
{
    AdaptiveContainerView *tips = [[AdaptiveContainerView alloc] initWithView:forView content:content];
    [tips showView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tips dismissView];
    });
}

+ (void)addTipsViewForView:(UIView *)forView contentView:(UIView *)contentView{
    AdaptiveContainerView *tips = [[AdaptiveContainerView alloc] initWithView:forView contentView:contentView];
    [tips showView];
}

+ (void)addTipsViewForView:(UIView *)forView contentView:(UIView *)contentView  afterDelay:(NSTimeInterval)delay{
    AdaptiveContainerView *tips = [[AdaptiveContainerView alloc] initWithView:forView contentView:contentView];
    [tips showView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tips dismissView];
    });
}
@end
