//
//  ViewController.m
//  DMProgressHUD
//
//  Created by Damon on 2017/10/23.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressHUD.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *sgmStyle;     //Style
@property (nonatomic, assign) DMProgressHUDStyle style;     //Style-type in DMProgressHUD

@property (nonatomic, strong) UISegmentedControl *sgmText;      //Text
@property (nonatomic, copy) NSString *text;     //Text string

@property (nonatomic, strong) UISegmentedControl *sgmAnimation;     //Animation
@property (nonatomic, assign) DMProgressHUDAnimation animation;     //Animation-type in DMProgressHUD

@property (nonatomic, strong) UISegmentedControl *sgmMask;      //Mask
@property (nonatomic, assign) DMProgressHUDMaskType mark;       //Mask-type in DMProgressHUD

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray *> *arrData;

@end

@implementation ViewController

#pragma mark - Lazy load
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSMutableArray *)arrData {
    
    if (!_arrData) {
        
        NSArray *arrLoading = @[@"Indicator", @"Circle"];
        NSArray *arrProgress = @[@"Circle", @"Sector"];
        NSArray *arrStatus = [NSArray arrayWithObjects:@"Success", @"fail", @"warning", nil];
        NSArray *arrText = @[@"Text"];
        NSArray *arrCustom = @[@"Custom"];
        _arrData = [NSMutableArray arrayWithObjects:arrLoading ,arrProgress ,arrStatus, arrText,arrCustom, nil];
    }
    
    return _arrData;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
    
    self.text = @"Here's info";
    
    UILabel *labStyle = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 0, 0)];
    labStyle.text = @"Style";
    labStyle.textColor = [UIColor blackColor];
    labStyle.font = [UIFont boldSystemFontOfSize:16.0];
    [labStyle sizeToFit];
    [self.view addSubview:labStyle];
    
    UISegmentedControl *sgmStyle = [[UISegmentedControl alloc] initWithItems:@[@"Dark", @"Light"]];
    sgmStyle.selectedSegmentIndex = 0;
    [sgmStyle addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    sgmStyle.frame = CGRectMake(20, CGRectGetMaxY(labStyle.frame)+4, 100, 26);
    _sgmStyle = sgmStyle;
    [self.view addSubview:sgmStyle];
    
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sgmStyle.frame)+20, 22, 0, 0)];
    labText.text = @"Text";
    labText.textColor = [UIColor blackColor];
    labText.font = [UIFont boldSystemFontOfSize:16.0];
    [labText sizeToFit];
    [self.view addSubview:labText];
    
    UISegmentedControl *sgmText = [[UISegmentedControl alloc] initWithItems:@[@"YES", @"NO"]];
    sgmText.selectedSegmentIndex = 0;
    [sgmText addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    sgmText.frame = CGRectMake(labText.frame.origin.x, CGRectGetMaxY(labText.frame)+4, 100, 26);
    _sgmText = sgmText;
    [self.view addSubview:sgmText];
    
    UILabel *labAnimation = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sgmStyle.frame)+10, 0, 0)];
    labAnimation.text = @"Animation";
    labAnimation.textColor = [UIColor blackColor];
    labAnimation.font = [UIFont boldSystemFontOfSize:16.0];
    [labAnimation sizeToFit];
    [self.view addSubview:labAnimation];
    
    UISegmentedControl *sgmAnimation = [[UISegmentedControl alloc] initWithItems:@[@"Gradient", @"Increment", @"Spring"]];
    sgmAnimation.selectedSegmentIndex = 0;
    [sgmAnimation addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    sgmAnimation.frame = CGRectMake(20, CGRectGetMaxY(labAnimation.frame)+4, 200, 26);
    _sgmAnimation = sgmAnimation;
    [self.view addSubview:sgmAnimation];
    
    UILabel *labMask = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(sgmAnimation.frame)+10, 0, 0)];
    labMask.text = @"Mask";
    labMask.textColor = [UIColor blackColor];
    labMask.font = [UIFont boldSystemFontOfSize:16.0];
    [labMask sizeToFit];
    [self.view addSubview:labMask];
    
    UISegmentedControl *sgmMask = [[UISegmentedControl alloc] initWithItems:@[@"None", @"clear", @"gray"]];
    sgmMask.selectedSegmentIndex = 0;
    [sgmMask addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    sgmMask.frame = CGRectMake(20, CGRectGetMaxY(labMask.frame)+4, 200, 26);
    _sgmMask = sgmMask;
    [self.view addSubview:sgmMask];
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(sgmMask.frame)+10, self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(sgmMask.frame)-10);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UISegmentedControl handle
- (void)sementedControlClick:(UISegmentedControl *)sgm {

    if (sgm == _sgmStyle) {
        
        if (sgm.selectedSegmentIndex == 0) {
            
            _style = DMProgressHUDStyleDark;
        } else if (sgm.selectedSegmentIndex == 1) {
        
            _style = DMProgressHUDStyleLight;
        }
        
    } else if (sgm == _sgmText) {
    
        if (sgm.selectedSegmentIndex == 0) {
            
            _text = @"Here's Info";
        } else if (sgm.selectedSegmentIndex == 1) {
        
            _text = @"";
        }
        
    } else if (sgm == _sgmAnimation) {
    
        if (sgm.selectedSegmentIndex == 0) {
            
            _animation = DMProgressHUDAnimationGradient;
        } else if (sgm.selectedSegmentIndex == 1) {
        
            _animation = DMProgressHUDAnimationIncrement;
        } else if (sgm.selectedSegmentIndex == 2) {
        
            _animation = DMProgressHUDAnimationSpring;
        }
        
    } else if (sgm == _sgmMask) {
    
        if (sgm.selectedSegmentIndex == 0) {
            
            _mark = DMProgressHUDMaskTypeNone;
        } else if (sgm.selectedSegmentIndex == 1) {
        
            _mark = DMProgressHUDMaskTypeClear;
        } else if (sgm.selectedSegmentIndex == 2) {
        
            _mark = DMProgressHUDMaskTypeGray;
        }
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusedId = @"Hub";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:.1f alpha:0.1];
    
    NSArray *arrDetail = _arrData[indexPath.section];
    NSString *strText = arrDetail[indexPath.row];
    
    cell.textLabel.text = strText;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:!cell.selected animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self showProgressLoadingTypeIndicator];
                break;
            case 1:
                [self showProgressLoadingTypeCircle];
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressTypeCircle];
                break;
            case 1:
                [self showProgressTypeSector];
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 2) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressStatusSuccess];
                break;
            case 1:
                [self showProgressStatusFail];
                break;
            case 2:
                [self showProgressStatusWarning];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressText];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 4) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressCustom];
                break;
                
            default:
                break;
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Loading";
            break;
            
        case 1:
            return @"Progress";
            break;
            
        case 2:
            return @"Status";
            break;
        case 3:
            return @"Text";
            break;
        case 4:
            return @"Custom";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - Show HUD
- (void)showProgressLoadingTypeIndicator {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeLoading;
    hud.style = _style;
    hud.label.text = _text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismissCompletion:^{
                
                NSLog(@"dismissCompletion");
            }];
        });
    });
}

- (void)showProgressLoadingTypeCircle {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeLoading;
    hud.loadingType = DMProgressHUDLoadingTypeCircle;
    hud.style = _style;
    hud.label.text = _text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeCircle {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeProgress;
    hud.style = _style;
    hud.label.text = _text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeSector {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeProgress;
    hud.progressType = DMProgressHUDProgressTypeSector;
    hud.style = _style;
    hud.label.text = _text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}


- (void)showProgressStatusSuccess {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeSuccess;
    hud.style = _style;
    hud.label.text = _text;
    
    [hud dismissAfter:1.0 completion:^{
        
        NSLog(@"complete");
    }];
}

- (void)showProgressStatusFail {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeFail;
    hud.style = _style;
    hud.label.text = _text;
    
    [hud dismissAfter:1.0 completion:^{
        
        NSLog(@"complete");
    }];
}

- (void)showProgressStatusWarning {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeWarning;
    hud.style = _style;
    hud.label.text = _text;
    
    [hud dismissAfter:1.0 completion:^{
        
        NSLog(@"complete");
    }];
}

- (void)showProgressText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeText;
    hud.style = _style;
    hud.label.text = _text;
    
    [hud dismissAfter:1.0];
}

- (void)showProgressCustom {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:_animation maskType:_mark];
    hud.mode = DMProgressHUDModeCustom;
    hud.style = _style;
    hud.label.text = _text;
    //custom
    UIView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [hud setCustomView:customView width:180 height:180];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)doSomething {
    
    CGFloat progress = 0;
    
    while (progress < 1) {

        progress += 0.01;
        dispatch_async(dispatch_get_main_queue(), ^{
            //refresh progress-value on main thread
            DMProgressHUD *hud = [DMProgressHUD progressHUDForView:self.view];
            hud.progress = progress;
        });
        [NSThread sleepForTimeInterval:0.01];
    }
}

@end
