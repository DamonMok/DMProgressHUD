//
//  DMProgressHUD.h
//  DMProgressHUDDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMProgressHUD;

typedef NS_ENUM(NSInteger, DMProgressHUDMode) {

    DMProgressHUDModeLoading,

    DMProgressHUDModeProgress,
    
    DMProgressHUDModeStatus,
    
    DMProgressHUDModeText,
    
    DMProgressHUDModeCustom
};

typedef NS_ENUM(NSInteger, DMProgressHUDLoadingType) {

    DMProgressHUDLoadingTypeIndicator,
    
    DMProgressHUDLoadingTypeCircle
};

typedef NS_ENUM(NSInteger, DMProgressHUDStatusType) {

    DMProgressHUDStatusTypeSuccess,
    
    DMProgressHUDStatusTypeFail,
    
    DMProgressHUDStatusTypeWarning
    
};

typedef NS_ENUM(NSInteger, DMProgressHUDProgressType) {

    DMProgressHUDProgressTypeCircle,
    
    DMProgressHUDProgressTypeSector
};

typedef NS_ENUM(NSInteger, DMProgressHUDAnimation) {

    DMProgressHUDAnimationDissolve,
    
    DMProgressHUDAnimationIncrement,
    
    DMProgressHUDAnimationSpring

};

typedef NS_ENUM(NSInteger, DMProgressHUDMaskType) {

    DMProgressHUDMaskTypeNone,
    
    DMProgressHUDMaskTypeClear,
    
    DMProgressHUDMaskTypeGray
};

typedef void(^DMProgressHUDDismissCompletion)();

typedef void(^DMProgressHUDMaskTapHandle)(DMProgressHUD *hud);

@interface DMProgressHUD : UIView

@property (nonatomic, assign) DMProgressHUDMode mode;

@property (nonatomic, assign) DMProgressHUDStatusType statusType;

@property (nonatomic, assign) DMProgressHUDProgressType progressType;

@property (nonatomic, assign) DMProgressHUDLoadingType loadingType;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong, readonly) UILabel *label;

@property (nonatomic, assign) UIEdgeInsets insets;


+ (instancetype)showProgressHUDAddedTo:(UIView *)view;

+ (instancetype)showProgressHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation;

+ (instancetype)showProgressHUDAddedTo:(UIView *)view maskType:(DMProgressHUDMaskType)maskType;

+ (instancetype)showProgressHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType;

+ (instancetype)showProgressHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType maskTapHandle:(DMProgressHUDMaskTapHandle)maskTapHandle;

- (void)dismiss;

- (void)dismissCompletion:(DMProgressHUDDismissCompletion)completion;

- (void)dismissAfter:(NSTimeInterval)seconds;

- (void)dismissAfter:(NSTimeInterval)seconds completion:(DMProgressHUDDismissCompletion)completion;



//custom view
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

//get current progressHUD
+ (DMProgressHUD *)progressHUDForView:(UIView *)view;

@end

@interface DMProgressHUD (initialization)

- (instancetype)init __attribute__((unavailable("Please use the initialization method provided by DMProgressHUD")));

@end
