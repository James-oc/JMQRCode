//
//  JMQRCodeLoadView.m
//  JMQRCodeDemo
//
//  Created by James on 2017/3/14.
//  Copyright © 2017年 James. All rights reserved.
//

#import "JMQRCodeLoadView.h"

int const kView_Size_W = 100;
int const kView_Size_H = 40;

@interface JMQRCodeLoadView()

@property (nonatomic, strong, readwrite) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation JMQRCodeLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.center = CGPointMake(self.center.x, self.center.y - _indicatorView.frame.size.height - 5);
    [_indicatorView startAnimating];
    
    [self addSubview:_indicatorView];
    
    _titleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kView_Size_W, 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font      = [UIFont systemFontOfSize:15.0f];
    _titleLabel.text      = @"正在加载...";
    _titleLabel.center    = CGPointMake(self.center.x, self.center.y + 5);

    [self addSubview:_titleLabel];
}

@end
