//
//  DMProgressHUD.m
//  DMProgressHUDDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "DMProgressHUD.h"

static const CGFloat kMargin = 20.0;    // The screen distance is greater than or equal to 20.f.
static const CGFloat kMarginTop = 10.0;     // Distance between Image to Label.
static const NSTimeInterval kAnimationDuration = 0.2;

@interface DMProgressHUD ()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIImageView *ivIcon;

@property (nonatomic, strong) CAShapeLayer *layerCircle;     // Defaule cycle
@property (nonatomic, strong) CAShapeLayer *layerProgress;  // Progress cycle
@property (nonatomic, strong) UILabel *labProgress;         // Progress lable

@property (nonatomic, assign) CGFloat customWidth;
@property (nonatomic, assign) CGFloat customHeight;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) DMProgressHUDAnimation animation; // Animation type

@property (nonatomic, assign) DMProgressHUDMaskType maskType;   // Mask type

@property (nonatomic, assign, getter=isShowHUD) BOOL showHUD;

@property (nonatomic, copy) DMProgressHUDDismissCompletion dismissCompletion;

@property (nonatomic, copy) DMProgressHUDMaskTapHandle maskTapHandle;

@end

@implementation DMProgressHUD

#pragma mark - Life cycle
/// Easy-call
+ (instancetype)showLoadingHUDAddedTo:(UIView *)view {

    DMProgressHUD *hud = [self showHUDAddedTo:view];
    hud.mode = DMProgressHUDModeLoading;
    return hud;
}

+ (instancetype)showProgressHUDAddedTo:(UIView *)view {

    DMProgressHUD *hud = [self showHUDAddedTo:view];
    hud.mode = DMProgressHUDModeProgress;
    return hud;
}

+ (instancetype)showStatusHUDAddedTo:(UIView *)view statusType:(DMProgressHUDStatusType)type {

    DMProgressHUD *hud = [self showHUDAddedTo:view];
    hud.mode = DMProgressHUDModeStatus;
    
    if (type == DMProgressHUDStatusTypeSuccess) {
        
        hud.statusType = DMProgressHUDStatusTypeSuccess;
    } else if (type == DMProgressHUDStatusTypeFail) {
    
        hud.statusType = DMProgressHUDStatusTypeFail;
    } else if (type == DMProgressHUDStatusTypeWarning) {
    
        hud.statusType = DMProgressHUDStatusTypeWarning;
    }
    
    return hud;
}

+ (instancetype)showTextHUDAddedTo:(UIView *)view {

    DMProgressHUD *hud = [self showHUDAddedTo:view];
    hud.mode = DMProgressHUDModeText;
    return hud;
}

/// More
+ (instancetype)showHUDAddedTo:(UIView *)view {

    return [self showHUDAddedTo:view animation:DMProgressHUDAnimationGradient maskType:DMProgressHUDMaskTypeNone];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation {

    return [self showHUDAddedTo:view animation:animation maskType:DMProgressHUDMaskTypeNone];
}

+ (instancetype)showHUDAddedTo:(UIView *)view maskType:(DMProgressHUDMaskType)maskType {

    return [self showHUDAddedTo:view animation:DMProgressHUDAnimationGradient maskType:maskType];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType {

    return [self showHUDAddedTo:view animation:animation maskType:maskType maskTapHandle:nil];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType maskTapHandle:(DMProgressHUDMaskTapHandle)maskTapHandle {

    if (!view) return nil;
    
    DMProgressHUD *hud = [[self alloc] p_initWithView:view];
    hud.animation = animation;
    hud.maskType = maskType;
    hud.maskTapHandle = maskTapHandle;
    
    [view addSubview:hud];
    
    [hud p_showAnimation:animation];
    
    return hud;
}

- (id)p_initWithView:(UIView *)view {

    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self p_configCommon];
    }

    return self;
}

// Config common parameters
- (void)p_configCommon {
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    self.customWidth = 22;
    self.customHeight = 22;
    _insets = UIEdgeInsetsMake(20, 26, 20, 26);
    
    
    
    [self p_configConponents];
    [self p_configConstraints];
}

// Set up all of the conponents
- (void)p_configConponents {
    
    // Content view
    _contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.85];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    
    // Custom view
    _customView = nil;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Text label
    _label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:16.0];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.label sizeToFit];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    // UIActivityIndicatorView
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _indicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Progress
    _layerCircle = [[CAShapeLayer alloc] init];
    _layerCircle.lineWidth = 3.0;
    _layerCircle.strokeColor = [[UIColor lightGrayColor] CGColor];
    _layerCircle.fillColor = [[UIColor clearColor] CGColor];
    
    _layerProgress = [[CAShapeLayer alloc] init];
    _layerProgress.lineWidth = 3.0;
    _layerProgress.strokeColor = [[UIColor whiteColor] CGColor];
    _layerProgress.fillColor = [[UIColor clearColor] CGColor];
    _layerProgress.lineCap = @"round";
    
    _labProgress = [[UILabel alloc] init];
    _labProgress.font = [UIFont systemFontOfSize:14.0];
    _labProgress.textAlignment = NSTextAlignmentCenter;
    [_labProgress sizeToFit];
    
    // Default mode
    _customView = _indicator;
    self.loadingType = DMProgressHUDLoadingTypeIndicator;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(_customWidth*0.5, _customHeight*0.5);
    CGFloat radius = _customWidth*0.5;
    
    // Default cycle layer
    UIBezierPath *cyclePath = [UIBezierPath bezierPath];
    [cyclePath addArcWithCenter:center radius:radius startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*1 clockwise:YES];
    
    // Progress detail layer
    UIBezierPath *detailPath = [UIBezierPath bezierPath];
    
    UIColor *color = _style == DMProgressHUDStyleLight ? [UIColor blackColor] : [UIColor whiteColor];
    
    if (_progressType == DMProgressHUDProgressTypeCircle) {
        
        _layerProgress.strokeColor = [color CGColor];
        _labProgress.textColor = color;
        
        [detailPath addArcWithCenter:center radius:radius startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*_progress clockwise:YES];
        
    } else if (_progressType == DMProgressHUDProgressTypeSector) {
        
        _layerCircle.lineWidth = 1;
        _layerProgress.lineWidth = 1;
        
        _layerCircle.strokeColor = [[color colorWithAlphaComponent:0.8] CGColor];
        _layerProgress.strokeColor = [color CGColor];
        _layerProgress.fillColor = [color CGColor];
        
        [detailPath moveToPoint:center];
        [detailPath addArcWithCenter:center radius:radius-2 startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*_progress clockwise:YES];
        
        _labProgress.hidden = YES;
    }
    
    // Progress label
    self.layerCircle.path = [cyclePath CGPath];
    self.layerProgress.path = [detailPath CGPath];
    
    self.labProgress.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.5);
    self.labProgress.center = center;
    self.labProgress.text = [NSString stringWithFormat:@"%.0f%%", self.progress*100];
}

#pragma mark - Show
- (void)p_showAnimation:(DMProgressHUDAnimation)animation {
    
    _showHUD = YES;
    
    if (animation == DMProgressHUDAnimationGradient) {
        self.alpha = 0;
        [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            if (self.showCompletion) {
                self.showCompletion();
            }
        }];
        
    } else if (animation == DMProgressHUDAnimationIncrement || animation == DMProgressHUDAnimationSpring) {
        
        // Transform
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.delegate = self;
        transformAnimation.duration = kAnimationDuration/2;
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.calculationMode = kCAAnimationCubicPaced;
        transformAnimation.fillMode = kCAFillModeForwards;
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)],
                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
        
        if (animation == DMProgressHUDAnimationSpring) {
            transformAnimation.duration = kAnimationDuration+0.1;
            transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
        }
        
        // Opacity
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = transformAnimation.duration;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.fromValue = @0;
        opacityAnimation.toValue = @1;
        
        [self.contentView.layer addAnimation:transformAnimation forKey:nil];
        [self.layer addAnimation:opacityAnimation forKey:nil];
        
    }
}

#pragma mark - Dismiss
- (void)dismiss {
    
    [self dismissCompletion:nil];
}

- (void)dismissCompletion:(DMProgressHUDDismissCompletion)completion {

    _showHUD = NO;
    
    if (_animation == DMProgressHUDAnimationGradient) {
        
        [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            
            [self removeFromSuperview];
            
            if (completion) {
                completion();
            }
            
        }];
    } else if (_animation == DMProgressHUDAnimationIncrement || _animation == DMProgressHUDAnimationSpring) {
        
        _dismissCompletion = completion;
        
        // Transform
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.delegate = self;
        transformAnimation.duration = kAnimationDuration;
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.calculationMode = kCAAnimationCubicPaced;
        transformAnimation.fillMode = kCAFillModeForwards;
        transformAnimation.values = @[
                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                      
                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]
                      ];
        
        // Opacity
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = transformAnimation.duration;
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.fromValue = @1;
        opacityAnimation.toValue = @0;
        
        [self.contentView.layer addAnimation:transformAnimation forKey:nil];
        [self.layer addAnimation:opacityAnimation forKey:nil];
    }
}

- (void)dismissAfter:(NSTimeInterval)seconds {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismiss];
    });
}

- (void)dismissAfter:(NSTimeInterval)seconds completion:(DMProgressHUDDismissCompletion)completion {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismissCompletion:completion];
    });
}

#pragma mark - Constraints
- (void)p_configConstraints {
    
    if (_mode == DMProgressHUDModeLoading) {
        
        [_contentView addSubview:_customView];
        [_contentView addSubview:_label];
        [_contentView removeConstraints:_contentView.constraints];
        
        self.customWidth = 32;
        self.customHeight = self.customWidth;
        
        [self p_configCustomViewContraints];
        [self p_configLabelConstraintsWithTopView:_customView];
        [self p_configContentViewWithTopView:_customView bottomView:_label];
        
    } else if (_mode == DMProgressHUDModeProgress) {
    
        self.customView = [[UIView alloc] init];
        [_customView.layer addSublayer:_layerCircle];
        [_customView.layer addSublayer:_layerProgress];
        [_customView.layer addSublayer:_labProgress.layer];
        [_contentView addSubview:_customView];
        
        self.customWidth = 40;
        self.customHeight = self.customWidth;
        
        [self p_configCustomViewContraints];
        [self p_configLabelConstraintsWithTopView:_customView];
        [self p_configContentViewWithTopView:_customView bottomView:_label];
    
    } else if (_mode == DMProgressHUDModeStatus || _mode == DMProgressHUDModeCustom) {
    
        [_contentView addSubview:_customView];
        [_contentView addSubview:_label];
        [_contentView removeConstraints:_contentView.constraints];
        [_customView removeConstraints:_customView.constraints];
        
        [self p_configCustomViewContraints];
        [self p_configLabelConstraintsWithTopView:_customView];
        [self p_configContentViewWithTopView:_customView bottomView:_label];
    
    } else if (_mode == DMProgressHUDModeText) {
    
        [_contentView addSubview:_label];
        [_customView removeFromSuperview];
        
        [self p_configLabelConstraintsWithTopView:nil];
        [self p_configContentViewWithTopView:_label bottomView:_label];
    }
}


// CustomView's contraints
- (void)p_configCustomViewContraints {
    
    NSMutableArray *cusViewConstraints = [NSMutableArray new];
    
    // Centered horizontally
    [cusViewConstraints addObject:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // Set width/height
    [_customView addConstraint:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_customWidth]];
    [_customView addConstraint:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_customHeight]];
    
    [self addConstraints:cusViewConstraints];
}

// Label's contraints
- (void)p_configLabelConstraintsWithTopView:(UIView *)topView {
    
    NSMutableArray *cusViewConstraints = [NSMutableArray new];
    
    // Centered horizontally
    [cusViewConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    // The maximum width and height allowed
    [cusViewConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*kMargin]];
    [cusViewConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-2*kMargin]];
    
    // The margin between Label and topView
    if (topView) {
        CGFloat marginTop = _label.text.length > 0 ? kMarginTop : 0;
        [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:marginTop]];
    }
    
    [self addConstraints:cusViewConstraints];
}

// ContentView's constraints
- (void)p_configContentViewWithTopView:(UIView *)topView bottomView:(UIView *)bottomView {
    
    // The maximum width and height allowed
    NSMutableArray *bgConstraints = [NSMutableArray new];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*kMargin]];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-2*kMargin]];
    [self addConstraints:bgConstraints];
    
    // Get the wider subview
    UIView *maxWidthView = topView.bounds.size.width > bottomView.bounds.size.width ? topView : bottomView;
    // Adaptive _contentView based on topView and bottomView
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:1 constant:-_insets.top]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:_insets.bottom]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:maxWidthView attribute:NSLayoutAttributeLeft multiplier:1 constant:-_insets.left]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:maxWidthView attribute:NSLayoutAttributeRight multiplier:1 constant:_insets.right]];
    
    // Centered vertically
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

+ (DMProgressHUD *)progressHUDForView:(UIView *)view {

    NSEnumerator *subViewsEnumerator = [view.subviews reverseObjectEnumerator];
    
    for (UIView *subView in subViewsEnumerator) {
        
        if ([subView isKindOfClass:self]) {
            
            return (DMProgressHUD *)subView;
        }
    }
    
    return nil;
}

#pragma mark - Setter
- (void)setMode:(DMProgressHUDMode)mode {
    
    _mode = mode;
    
    [self p_configConstraints];
}

- (void)setStatusType:(DMProgressHUDStatusType)statusType {

    _statusType = statusType;
    
    // Default width&height
    self.customWidth = 22;
    self.customHeight = self.customWidth;
    
    _ivIcon = [[UIImageView alloc] init];
    NSString *lightStyle = _style == DMProgressHUDStyleLight ? @"black_" : @"";
    
    if (statusType == DMProgressHUDStatusTypeSuccess) {
        
        _ivIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"DMProgressImgs.bundle/progress_success_%@22x22_", lightStyle]];
        
    } else if (statusType == DMProgressHUDStatusTypeFail) {
    
        _ivIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"DMProgressImgs.bundle/progress_fail_%@24x24_", lightStyle]];
        
    } else if (statusType == DMProgressHUDStatusTypeWarning) {
        
        _ivIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"DMProgressImgs.bundle/progress_warning_%@32x28_", lightStyle]];
    }
    
    self.customView = _ivIcon;
    
    [self p_configConstraints];
}

- (void)setLoadingType:(DMProgressHUDLoadingType)loadingType {

    _loadingType = loadingType;
    
    if (_loadingType == DMProgressHUDLoadingTypeIndicator) {
        
        [_indicator startAnimating];
        self.customView = _indicator;
        
    } else if (_loadingType == DMProgressHUDLoadingTypeCircle) {
    
        NSString *lightStyle = _style == DMProgressHUDStyleLight ? @"black_" : @"";
        
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"DMProgressImgs.bundle/progress_loading_%@32x32_", lightStyle]]];
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(p_showLoadingAnimation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    
    [self p_configConstraints];
}

// Custom view
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height {

    if (_mode != DMProgressHUDModeCustom || !view) return;
    
    self.customWidth = width;
    self.customHeight = height;
    
    self.customView = view;
    [self addSubview:_customView];
    
    [self p_configConstraints];
}

- (void)setCustomView:(UIView *)customView {
    
    [_customView removeFromSuperview];
    _customView = customView;
    _customView.frame = CGRectMake(0, 0, _customWidth, _customHeight);
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setText:(NSString *)text {

    _text = text;
    
    self.label.text = text;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    // Set the minimum default value to 2%
    // _progress = _progress > 0.02 ? _progress : 0.02;
    
    if (_mode == DMProgressHUDModeProgress) {
        
        [self setNeedsDisplay];
    }
}

// Limited width
- (void)setCustomWidth:(CGFloat)customWidth {
    
    CGFloat maxWidth = self.frame.size.width - 2*2*kMargin;
    _customWidth = customWidth > maxWidth ? maxWidth : customWidth;
}

// Limited height
- (void)setCustomHeight:(CGFloat)customHeight {
    
    CGFloat maxHeight = self.frame.size.height - 2*2*kMargin;
    _customHeight  = customHeight > maxHeight ? maxHeight : customHeight;
}

// Limited insets
- (void)setInsets:(UIEdgeInsets)insets {

    _insets = insets;
    
    [self p_configConstraints];
}

- (void)setStyle:(DMProgressHUDStyle)style {

    _style = style;
    
    if (_style == DMProgressHUDStyleLight) {
    
        self.contentView.backgroundColor = [UIColor colorWithRed:234/255.0 green:237/255.0 blue:239/255.0 alpha:0.95];
        self.label.textColor = [UIColor blackColor];
        
        if (_mode == DMProgressHUDModeLoading) {
            
            self.indicator.color = [UIColor blackColor];
            self.loadingType = self.loadingType;
            
        } else if (_mode == DMProgressHUDModeStatus) {
        
            self.statusType = self.statusType;
        }
    }
}

- (void)setMaskType:(DMProgressHUDMaskType)maskType {

    _maskType = maskType;
    
    self.userInteractionEnabled = maskType;
    
    if (maskType == DMProgressHUDMaskTypeClear) {
        
        self.backgroundColor = [UIColor clearColor];
        
    } else if (maskType == DMProgressHUDMaskTypeGray) {
    
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
}


- (void)p_showLoadingAnimation {

    _customView.transform = CGAffineTransformRotate(_customView.transform, 0.0006);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"text"]) {
        
        [_label sizeToFit];
        
        [self p_configConstraints];
    }
}

#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.isShowHUD) {
        
        if (self.showCompletion) {
            self.showCompletion();
        }
        
    } else {
    
        // Clean up
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        [self.contentView.layer removeAllAnimations];
        [self removeFromSuperview];
        
        if (_dismissCompletion) {
            _dismissCompletion();
        }
    }
}

#pragma mark - Touch delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.maskTapHandle) {
        self.maskTapHandle(self);
    }
}

#pragma mark - Dealloc
- (void)dealloc {

    [self.label removeObserver:self forKeyPath:@"text"];
}

@end
