//
//  ViewController.m
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/11.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import "ViewController.h"
#import "OdometerView.h"
#import "AdaptiveContainerView.h"
#import "ScratchView.h"
#import "UIImage+Image.h"

@interface ViewController ()<ScratchViewDelegate>{
    OdometerView * odometerView;
    float randomValue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@""];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    odometerView = [[OdometerView alloc] initWithFrame:CGRectMake(20, 50, 100, 20)];
    odometerView.backgroundColor = [UIColor cyanColor];
    odometerView.font = [UIFont systemFontOfSize:18];
    odometerView.textColor = [UIColor blackColor];
    odometerView.textAlignment = NSTextAlignmentCenter;
    odometerView.formatter = numberFormatter;
    [self.view addSubview:odometerView];
    [odometerView setupNumber:@100.12];
    
    UITapGestureRecognizer *singleTapOVBlock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTappedOV:)];
    [odometerView addGestureRecognizer:singleTapOVBlock];
    
}
-(void)fingerTappedOV:(id)sender{
//    [AdaptiveContainerView addTipsForView:odometerView content:@"this is odometer view!" afterDelay:3];
    
    UIView * scratchViewTV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 40)];
    msg.textColor = [UIColor blueColor];
    msg.font = [UIFont systemFontOfSize:20];
    msg.textAlignment = NSTextAlignmentCenter;
    randomValue = (arc4random() % 1000000) / 100.0;
    msg.text = [NSString stringWithFormat:@"%.2f",randomValue];
    [scratchViewTV addSubview:msg];
    
    UIImageView *coverImg = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIColor.grayColor size:CGSizeMake(200, 100)]];
    UILabel *coverTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 40)];
    coverTitle.textColor = [UIColor blackColor];
    coverTitle.font = [UIFont systemFontOfSize:20];
    coverTitle.textAlignment = NSTextAlignmentCenter;
    randomValue = (arc4random() % 1000000) / 100.0;
    coverTitle.text = @"刮一刮";
    [coverImg addSubview:coverTitle];
    
    ScratchView *scratchView = [[ScratchView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    scratchView.maxPathCount = 15;
    scratchView.pathWidth = 50.0;
    scratchView.pathCount = 6 ;
    scratchView.scratchViewDelegate = self ;
    [scratchView setCoveredView:coverImg];
    [scratchViewTV addSubview:scratchView];
    
    [AdaptiveContainerView addTipsViewForView:odometerView contentView:scratchViewTV];
}
#pragma mark --- SIScratchViewDelegate
- (void)scratchViewDidOpen:(ScratchView *)scratchView{
    [odometerView setupNumber:@(randomValue)];
}
@end
