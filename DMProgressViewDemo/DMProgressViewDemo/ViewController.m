//
//  ViewController.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressView.h"

@interface ViewController (){
    
    int _index;
}

@property (nonatomic, strong)DMProgressView *progressView;

@property (nonatomic, strong)NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.progressView = [DMProgressView showAddedTo:self.view];
    
    self.array = @[@0.2, @0.4, @0.6, @0.8, @1.0];
    
}

#warning touch to test
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_index>self.array.count-1) {
        
        //        [self.processView hide];
        _index = 0;
    }
    
    CGFloat process = [self.array[_index] doubleValue];
    
    self.progressView.process = process;
    
    _index++;
    
}

@end
