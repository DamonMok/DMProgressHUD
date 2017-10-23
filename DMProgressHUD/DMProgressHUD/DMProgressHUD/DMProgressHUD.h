//
//  DMProgressHUD.h
//  DMProgressHUDDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (void)dismiss;


//custom view
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

//get current progressHUD
+ (DMProgressHUD *)progressHUDForView:(UIView *)view;

@end
