//
//  DMProgressView.h
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMProgressView : UIView

//process
@property (nonatomic, assign)CGFloat process;

//---------------------进度---------------------
/**【显示】进度View*/
+ (instancetype)showProgressViewAddedTo:(UIView *)view;

/**【隐藏】进度View*/
- (void)hideProgressView;

//---------------------加载中---------------------
/**【显示】loadingView*/
+ (instancetype)showLoadingViewAddTo:(UIView *)view;

/**【隐藏】loadingView*/
- (void)hideLoadingView;

//---------------------成功提示---------------------
/**【显示】*/
+ (instancetype)showSuccessAddedTo:(UIView *)view message:(NSString *)message;


@end
