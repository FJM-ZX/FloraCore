//
//  ScrollTextView.h
//  yoogooIOS
//
//  Created by Fu Jiaming on 2018/5/31.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTextView : UIView
@property (nonatomic,copy)   NSArray * textDataArr;
// 文字停留时间，默认为3s。
// Text stay time，default is 3 seconds.
@property (nonatomic,assign) CGFloat textStayTime;

// 文字滚动动画时间，默认为1s。
// Text scrolling animation time，default is 1 seconds.
@property (nonatomic,assign) CGFloat scrollAnimationTime;

@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,copy)   UIColor * textColor;
@property (nonatomic)        NSTextAlignment textAlignment;
@property (nonatomic) NSString *formatLLKey;
- (void)startScrollBottomToTopWithNoSpace;
- (void)startScrollTopToBottomWithNoSpace;

- (void)stop;
@end
