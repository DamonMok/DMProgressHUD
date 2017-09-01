//
//  DMProgressView.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "DMProgressView.h"

@interface DMProgressView ()

@property (nonatomic, strong)DMProgressView *progressView;

@property (nonatomic, strong)CAShapeLayer *processLayer;

@property (nonatomic, strong)UILabel *processLabel;

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

- (UILabel *)processLabel {
    
    if (!_processLabel) {
        
        _processLabel = [[UILabel alloc] init];
        _processLabel.textColor = [UIColor whiteColor];
        _processLabel.textAlignment = NSTextAlignmentCenter;
        [_processLabel sizeToFit];
        
        [self.layer addSublayer:_processLabel.layer];
    }
    
    return _processLabel;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width*0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*self.process clockwise:YES];
    self.processLayer.path = [path CGPath];
    
    self.processLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.5);
    self.processLabel.center = center;
    self.processLabel.text = [NSString stringWithFormat:@"%.0f", self.process*100];
    self.processLabel.hidden = self.process>0?NO:YES;
    
}

- (void)setProcess:(CGFloat)process {
    
    _process = process;
    
    [self setNeedsDisplay];
}

+ (instancetype)showAddedTo:(UIView *)view {
    
    DMProgressView *progressView = [[DMProgressView alloc] init];
    progressView.progressView = progressView;
    progressView.backgroundColor = [UIColor clearColor];
    
    progressView.frame = CGRectMake(0, 0, 40, 40);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    
    [view addSubview:progressView];
    
    return progressView;
}

- (void)hide {
    
    [self.progressView removeFromSuperview];
}


@end
