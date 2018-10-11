//
//  AdaptiveContainerView.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/9/29.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdaptiveContainerView : UIView
/**
 显示视图, 显示后，再次点击屏幕消失
 @param forView  需要添加的 View  eg.: 点击按钮button，则此处forView 传 button。
 @param content 内容
 */
+ (void)addTipsForView:(UIView *)forView
               content:(NSString *)content;

/**
 显示视图，显示后，再次点击屏幕消失 或 一段时间后消失
 @param forView  需要添加的 View eg.: 点击按钮button，则此处forView 传 button。
 @param content 内容
 @param delay 时间
 */
+ (void)addTipsForView:(UIView *)forView
               content:(NSString *)content
            afterDelay:(NSTimeInterval )delay;

/**
 显示视图，显示后，再次点击屏幕消失 或 一段时间后消失
 @param forView  需要添加的 View eg.: 点击按钮button，则此处forView 传 button。
 @param contentView 内容View
 */
+ (void)addTipsViewForView:(UIView *)forView contentView:(UIView *)contentView;

/**
 显示视图，显示后，再次点击屏幕消失 或 一段时间后消失
 @param forView  需要添加的 View eg.: 点击按钮button，则此处forView 传 button。
 @param contentView 内容View
 @param delay 时间
 */
+ (void)addTipsViewForView:(UIView *)forView contentView:(UIView *)contentView  afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
