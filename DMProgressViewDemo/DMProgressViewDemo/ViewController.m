//
//  ViewController.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    int _index;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *arrData;

@end

@implementation ViewController

#pragma mark - lazy load
- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSArray *)arrData {

    if (!_arrData) {
        
        _arrData = [NSArray arrayWithObjects:@"【重构】成功提示", @"【重构】失败提示", @"【重构】警告提示", @"【重构】纯文字提示",nil];
    }
    
    return _arrData;
}

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reusedId = @"Hub";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    NSString *strText = self.arrData[indexPath.row];
    
    cell.textLabel.text = strText;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            [self showProgressSuccess];
            break;
        case 1:
            [self showProgressFail];
            break;
        case 2:
            [self showProgressWarning];
            break;
        case 3:
            [self showProgressText];
            
        default:
            break;
    }
}

#pragma mark 进度圈
- (void)showProgressView {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];

    NSArray *arrProcess = @[@0, @0.2, @0.4, @0.6, @0.8, @1.0];
    
    __block int i = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (i < arrProcess.count) {
            
            progressView.process = [arrProcess[i] doubleValue];
            i++;
        } else {
        
            [timer invalidate];
            [progressView hideProgressView];
        }
    }];
}

#pragma mark 加载中
- (void)showLoadingView {

    DMProgressView *progressView = [DMProgressView showLoadingViewAddTo:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [progressView hideLoadingView];
    });
}

#pragma mark 成功提示
- (void)showSuccessView {
    
    [DMProgressView showSuccessAddedTo:self.view message:@"保存成功"];
    
}

#warning recode
- (void)showProgressSuccess {

    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusSuccess;
    progressView.label.text = @"Success status";
}

- (void)showProgressFail {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusFail;
    progressView.label.text = @"Fail status";
}

- (void)showProgressWarning {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusWarning;
    progressView.label.text = @"Warning status";
}

- (void)showProgressText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeText;
    progressView.label.text = @"This is your textThis is your textThis is your textThis is your textThis is your text";
}


@end
