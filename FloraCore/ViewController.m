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
#import "ScrollTextView.h"
#import "ProgressView.h"

#import "UIImage+CreateImage.h"
#import "UIView+FrameExpanded.h"


@interface ViewController ()<ScratchViewDelegate>{
    OdometerView * odometerView;
    ProgressView *pgV;
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
    
    ScrollTextView *stv = [[ScrollTextView alloc] initWithFrame:CGRectMake(0, 100, 200, 20)];
    stv.backgroundColor = [UIColor magentaColor];
    stv.center_x = self.view.center_x;
    stv.fontSize = 18;
    stv.textColor = [UIColor blackColor];
    [self.view addSubview:stv];
    stv.textDataArr = @[@"ScrollTextView test1",@"ScrollTextView test2",@"ScrollTextView test3"];
    [stv startScrollBottomToTopWithNoSpace];
    
    UIImageView *createImg = [[UIImageView alloc] initWithImage:[UIImage ClipCircleImageWithImage:[UIImage imageWithSize:CGSizeMake(100, 100) radius:0 startHColor:[UIColor redColor] midHColor:[UIColor greenColor] endHColor:[UIColor blueColor]] circleSize:CGSizeMake(100, 100) borderWidth:4 borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]]];
    createImg.y = 130;
    createImg.center_x = self.view.center_x;
    [self.view addSubview:createImg];
    
    
    UIImage *img = [UIImage imageWithSize:CGSizeMake(100, 40) radius:0 startVColor:[UIColor redColor] endVColor:[UIColor blackColor]];
    UIImageView *createImg2 = [[UIImageView alloc] initWithImage:[UIImage ClipRoundCornerImageWithImage:img size:img.size radius:20 imageRoundCornerDirection:ImageRoundCornerTopRight|ImageRoundCornerTopLeft|ImageRoundCornerBottomRight]];
    createImg2.y = 250;
    createImg2.center_x = self.view.center_x;
    [self.view addSubview:createImg2];
    
    
    UIImage *ProgressBarImg = [UIImage imageWithSize:CGSizeMake(20, 20) radius:0 startHColor:[UIColor redColor] endHColor:[UIColor blackColor]];
    pgV = [[ProgressView alloc] initWithFrame:CGRectMake(0, 300, 300, 20)];
//    pgV.frame = CGRectMake(0, 300, 300, 20);
    pgV.center_x = self.view.center_x;
    pgV.roundCornerRadius = 10;
//    pgV.isRoundCornerBar = YES;
    pgV.isScaleBar = YES;
    pgV.progressBar = [[UIImageView alloc] initWithImage:ProgressBarImg];
    [self.view addSubview:pgV];
    [pgV updateProgress:0.0];
    [pgV setProgressLabel:@"ProgressView"];
    
    UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(0 , 330, 200, 50)];
    slider.center_x = self.view.center_x;
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.5;
    
    [slider setContinuous:YES];
    slider.minimumTrackTintColor = [UIColor redColor];
    slider.maximumTrackTintColor = [UIColor blueColor];
    slider.thumbTintColor = [UIColor yellowColor];
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)fingerTappedOV:(id)sender{
    [pgV updateProgress:0.5 isAnimation:YES];
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

-(void)sliderValueChanged:(UISlider *)slider
{
    [pgV updateProgress:slider.value isAnimation:YES];
    [pgV setProgressLabel:[NSString stringWithFormat:@"slider value%f",slider.value]];
}
@end
