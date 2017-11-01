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

typedef NS_ENUM(NSInteger, DMProgressHUDProgressType) {
    
    DMProgressHUDProgressTypeCircle,
    
    DMProgressHUDProgressTypeSector
};

typedef NS_ENUM(NSInteger, DMProgressHUDStatusType) {

    DMProgressHUDStatusTypeSuccess,
    
    DMProgressHUDStatusTypeFail,
    
    DMProgressHUDStatusTypeWarning
    
};

typedef NS_ENUM(NSInteger, DMProgressHUDAnimation) {

    DMProgressHUDAnimationDissolve,
    
    DMProgressHUDAnimationIncrement,
    
    DMProgressHUDAnimationSpring

};

typedef NS_ENUM(NSInteger, DMProgressHUDStyle) {
    
    DMProgressHUDStyleDark = 0,
    
    DMProgressHUDStyleLight
};

typedef NS_ENUM(NSInteger, DMProgressHUDMaskType) {

    DMProgressHUDMaskTypeNone,
    
    DMProgressHUDMaskTypeClear,
    
    DMProgressHUDMaskTypeGray
};

typedef void(^DMProgressHUDDismissCompletion)();
typedef void(^DMProgressHUDShowCompletion)();

typedef void(^DMProgressHUDMaskTapHandle)(DMProgressHUD *hud);

@interface DMProgressHUD : UIView

@property (nonatomic, assign) DMProgressHUDMode mode;

@property (nonatomic, assign) DMProgressHUDLoadingType loadingType;

@property (nonatomic, assign) DMProgressHUDProgressType progressType;

@property (nonatomic, assign) DMProgressHUDStatusType statusType;

/**
 * Text label.
 */
@property (nonatomic, strong, readonly) UILabel *label;

/**
 * Use this parameter when the mode is DMProgressHUDModeProgress.
 */
@property (nonatomic, assign) CGFloat progress;

/**
 * Content insets.
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * background view of HUD.
 * Use this parameter to set backgroundColor/cornerRadius and so on.
 */
@property (nonatomic, strong, readonly) UIView *backgroundView;

/**
 * HUD style.
 */
@property (nonatomic, assign) DMProgressHUDStyle style;

/**
 * The block to be executed when the Mask is clicked.
 */
@property (nonatomic, copy) DMProgressHUDShowCompletion showCompletion;



#pragma mark - Show (Easy-call)
/**
 * Displays a HUD of type LOADING.
 *
 * NOTE: This method uses the default LoadingType/MaskType/Animation.
 *
 * @param view The view that the Loading-HUD is going to be added to.
 * @return The created HUD.
 */
+ (instancetype)showLoadingHUDAddedTo:(UIView *)view;

/**
 * Displays a HUD of type PROGRESS.
 *
 * NOTE: This method uses the default ProgressType/MaskType/Animation.
 *
 * @param view The view that the Progress-HUD is going to be added to.
 * @return The created HUD.
 */
+ (instancetype)showProgressHUDAddedTo:(UIView *)view;

/**
 * Displays a HUD of type STATUS.
 *
 * NOTE: This method uses the default StatusType/MaskType/Animation.
 *
 * @param view The view that the Status-HUD is going to be added to.
 * @return The created HUD.
 */
+ (instancetype)showStatusHUDAddedTo:(UIView *)view;

/**
 * Displays a HUD of type TEXT.
 *
 * NOTE: This method uses the default MaskType/Animation.
 *
 * @param view The view that the Text-HUD is going to be added to.
 * @return The created HUD.
 */
+ (instancetype)showTextHUDAddedTo:(UIView *)view;



#pragma mark - Show (More)
+ (instancetype)showHUDAddedTo:(UIView *)view;

+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation;

+ (instancetype)showHUDAddedTo:(UIView *)view maskType:(DMProgressHUDMaskType)maskType;

+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType;

/**
 * Displays a HUD with Animation/Mask.
 *
 * @param view The view that the HUD is going to be added to.
 * @param animation Show HUD in Animation type.
 * @param maskType The Mask type for HUD.
 * @param maskTapHandle The block to be executed when the Mask is clicked.
 * @return The created HUD.
 */
+ (instancetype)showHUDAddedTo:(UIView *)view animation:(DMProgressHUDAnimation)animation maskType:(DMProgressHUDMaskType)maskType maskTapHandle:(DMProgressHUDMaskTapHandle)maskTapHandle;



#pragma mark - Dismiss
- (void)dismiss;

- (void)dismissCompletion:(DMProgressHUDDismissCompletion)completion;

- (void)dismissAfter:(NSTimeInterval)seconds;

- (void)dismissAfter:(NSTimeInterval)seconds completion:(DMProgressHUDDismissCompletion)completion;


#pragma mark - Other
/**
 * Set the custom view of the HUD.
 *
 * NOTE: This method works only when DMProgressHUDMode is DMProgressHUDModeCustom.
 *
 * @param view The custom view.
 * @param width The width for custom view.
 * @param height The height for custom view.
 */
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

/**
 * Gets the top HUD in View.
 *
 * @param view The view that will be searched.
 * @return Returns the HUD found.
 */
+ (DMProgressHUD *)progressHUDForView:(UIView *)view;

@end

@interface DMProgressHUD (initialization)

- (instancetype)init __attribute__((unavailable("Please use the initialization method provided by DMProgressHUD")));

@end
