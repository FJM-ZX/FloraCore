//
//  UIView+BgExpanded.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/17.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface FJMView:UIView{
    
}
@end

@interface UIView (BgExpanded)
-(void)setBorderWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderW borderColor:( UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
