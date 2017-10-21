//
//  ViewController.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray *> *arrData;

@end

@implementation ViewController

#pragma mark - lazy load
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
    
        NSArray *arrLoading = @[@"Loading", @"Loading-带文字"];
        NSArray *arrProgress = @[@"Circle", @"Circel-带文字", @"Sector", @"Sector-带文字"];
        NSArray *arrStatus = [NSArray arrayWithObjects:@"【重构】成功提示", @"【重构】失败提示", @"【重构】警告提示", nil];
        NSArray *arrText = @[@"【重构】纯文字提示"];
        NSArray *arrCustom = @[@"【重构】自定义", @"【重构】自定义-带文字"];
        _arrData = [NSMutableArray arrayWithObjects:arrLoading ,arrProgress ,arrStatus, arrText,arrCustom, nil];
    }
    
    return _arrData;
}

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 22, self.view.bounds.size.width, self.view.bounds.size.height-22);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
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
                [self showProgressLoading];
                break;
            case 1:
                [self showProgressLoadingWithText];
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
                [self showProgressTypeCircleWithText];
                break;
            case 2:
                [self showProgressTypeSector];
                break;
            case 3:
                [self showProgressTypeSectorWithText];
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
            case 1:
                [self showProgressCustomWithText];
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


#warning recode
- (void)showProgressLoading {

    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeLoading;
    progressView.label.text = @"";
}

- (void)showProgressLoadingWithText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeLoading;
    progressView.label.text = @"Loading With text";
}

- (void)showProgressTypeCircle {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeProgress;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [progressView dismiss];
        });
    });
}

- (void)showProgressTypeCircleWithText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeProgress;
    progressView.label.text = @"Loading...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [progressView dismiss];
        });
    });
}

- (void)showProgressTypeSector {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeProgress;
    progressView.progressType = DMProgressViewProgressTypeSector;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [progressView dismiss];
        });
    });
}

- (void)showProgressTypeSectorWithText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeProgress;
    progressView.progressType = DMProgressViewProgressTypeSector;
    progressView.label.text = @"Loading...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [progressView dismiss];
        });
    });
}

- (void)showProgressStatusSuccess {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.statusType = DMProgressViewStatusTypeSuccess;
    progressView.label.text = @"Success status";
}

- (void)showProgressStatusFail {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.statusType = DMProgressViewStatusTypeFail;
    progressView.label.text = @"Fail status";
}

- (void)showProgressStatusWarning {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.statusType = DMProgressViewStatusTypeWarning;
    progressView.label.text = @"Warning status";
}

- (void)showProgressText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeText;
    progressView.label.text = @"This is your textThis is your textThis is your textThis is your textThis is your text";
}

- (void)showProgressCustom {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeCustom;
    progressView.label.text = @"";
    //custom
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [progressView setCustomView:view width:80 height:80];
}

- (void)showProgressCustomWithText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeCustom;
    progressView.label.text = @"Custom with label";
    
    //custom
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [progressView setCustomView:view width:80 height:80];
}

- (void)doSomething {

    CGFloat progress = 0;
    while (progress < 1) {
        
        progress += 0.01;
        dispatch_async(dispatch_get_main_queue(), ^{
            //refresh progress-value on main thread
            DMProgressView *progressView = [DMProgressView progressViewForView:self.view];
            progressView.progress = progress;
        });
        [NSThread sleepForTimeInterval:0.01];
    }
}

@end
