//
//  ScratchView.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/9/29.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScratchView ;

@protocol ScratchViewDelegate <NSObject>

/// 打开图层后的代理方法
- (void)scratchViewDidOpen:(ScratchView *)scratchView ;

@end

@interface ScratchView : UIView

/// 路径的宽度
@property (nonatomic,assign) CGFloat pathWidth ;

/// 行以及列的路径数,如果设置为3总共会分成3*3个块
@property (nonatomic,assign) NSUInteger pathCount ;

/// 最大路径数,经过多少块自动消失
@property (nonatomic,assign) NSUInteger maxPathCount ;

/// 被覆盖的View
@property (nonatomic,strong) UIView *coveredView ;

/// 代理
@property (nonatomic,weak) id<ScratchViewDelegate>scratchViewDelegate ;

@end
