//
//  DMProgressView.h
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMProgressViewMode) {

    DMProgressViewModeLoading,

    DMProgressViewModeProgress,
    
    DMProgressViewModeStatus,
    
    DMProgressViewModeText,
    
    DMProgressViewModeCustom
};

typedef NS_ENUM(NSInteger, DMProgressViewLoadingType) {

    DMProgressViewLoadingTypeIndicator,
    DMProgressViewLoadingTypeCircle
};

typedef NS_ENUM(NSInteger, DMProgressViewStatusType) {

    DMProgressViewStatusTypeSuccess,
    
    DMProgressViewStatusTypeFail,
    
    DMProgressViewStatusTypeWarning
    
};

typedef NS_ENUM(NSInteger, DMProgressViewProgressType) {

    DMProgressViewProgressTypeCircle,
    
    DMProgressViewProgressTypeSector
};

@interface DMProgressView : UIView

#warning recode
@property (nonatomic, assign) DMProgressViewMode mode;

@property (nonatomic, assign) DMProgressViewStatusType statusType;

@property (nonatomic, assign) DMProgressViewProgressType progressType;

@property (nonatomic, assign) DMProgressViewLoadingType loadingType;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong, readonly) UILabel *label;

@property (nonatomic, assign) UIEdgeInsets insets;

+ (instancetype)showProgressViewAddedTo:(UIView *)view;

- (void)dismiss;


//custom view
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

//get current progressView
+ (DMProgressView *)progressViewForView:(UIView *)view;

@end
