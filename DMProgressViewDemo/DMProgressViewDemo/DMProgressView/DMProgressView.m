//
//  DMProgressView.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "DMProgressView.h"

@interface DMProgressView ()

@property (nonatomic, weak)DMProgressView *hubView;

//进度圈View
@property (nonatomic, strong)CAShapeLayer *processLayer;
@property (nonatomic, strong)UILabel *labProcess;

//加载中loadingView
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong)UILabel *labLoading;

@end

@implementation DMProgressView

- (CAShapeLayer *)processLayer {
    
    if (!_processLayer) {
        
        _processLayer = [[CAShapeLayer alloc] init];
        _processLayer.lineWidth = 2.0;
        _processLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _processLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.layer addSublayer:self.processLayer];
    }
    
    return _processLayer;
}

- (UILabel *)labProcess {
    
    if (!_labProcess) {
        
        _labProcess = [[UILabel alloc] init];
        _labProcess.textColor = [UIColor whiteColor];
        _labProcess.textAlignment = NSTextAlignmentCenter;
        [_labProcess sizeToFit];
        
        [self.layer addSublayer:_labProcess.layer];
    }
    
    return _labProcess;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width*0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*self.process clockwise:YES];
    self.processLayer.path = [path CGPath];
    
    self.labProcess.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.5);
    self.labProcess.center = center;
    self.labProcess.text = [NSString stringWithFormat:@"%.0f", self.process*100];
    
    self.labProcess.hidden = self.process>0?NO:YES;
    
}

- (void)setProcess:(CGFloat)process {
    
    _process = process;
    
    //2%预显示
    _process = _process > 0.02 ? _process : 0.02;
    
    [self setNeedsDisplay];
    
}

#pragma mark - 进度View
/**【显示】进度View*/
+ (instancetype)showProgressViewAddedTo:(UIView *)view {
    
    for (UIView *progressView in view.subviews) {
        
        if ([progressView isKindOfClass:[DMProgressView class]]) {
            
            return nil;
        }
    }
    
    DMProgressView *progressView = [[DMProgressView alloc] init];
    progressView.hubView = progressView;
    progressView.backgroundColor = [UIColor clearColor];
    
    progressView.frame = CGRectMake(0, 0, 40, 40);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    
    [view addSubview:progressView];
    
    return progressView;
}

/**【隐藏】进度View*/
- (void)hideProgressView {
    
    [self.labProcess.layer removeFromSuperlayer];
    [self.hubView removeFromSuperview];

}

#pragma mark - 加载View
/**【显示】loadingView*/
+ (instancetype)showLoadingViewAddTo:(UIView *)view {

    for (UIView *loadingView in view.subviews) {
        
        if ([loadingView isKindOfClass:[DMProgressView class]]) {
            
            return nil;
        }
    }
    
    DMProgressView *progressView = [[DMProgressView alloc] init];
    progressView.hubView = progressView;
    progressView.backgroundColor = [UIColor grayColor];
    progressView.layer.masksToBounds = YES;
    progressView.layer.cornerRadius = 5;
    progressView.alpha = 0.7;
    progressView.frame = CGRectMake(0, 0, 100, 100);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    
    //加载圈
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    progressView.activityIndicatorView = activityIndicatorView;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5-15);
    
    [activityIndicatorView startAnimating];
    
    //文字
    UILabel *labLoading = [[UILabel alloc] init];
    progressView.labLoading = labLoading;
    labLoading.text = @"正在加载...";
    labLoading.font = [UIFont systemFontOfSize:14.0];
    labLoading.textColor = [UIColor whiteColor];
    labLoading.textAlignment = NSTextAlignmentCenter;
    [labLoading sizeToFit];
    labLoading.frame = CGRectMake(0, 0, progressView.bounds.size.width, 30);
    labLoading.center = CGPointMake(view.bounds.size.width*0.5, view.center.y+30);
    
    [view addSubview:progressView];
    [view addSubview:activityIndicatorView];
    [view addSubview:labLoading];
    
    return progressView;
}


/**【隐藏】loadingView*/
- (void)hideLoadingView {

    [self.hubView removeFromSuperview];
    [self.activityIndicatorView removeFromSuperview];
    [self.labLoading removeFromSuperview];
}

- (void)dealloc {

    NSLog(@"%s", __func__);
}

@end
