//
//  GYEmptyView.m
//  GY
//
//  Created by 夏增明 on 2019/11/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYEmptyView.h"

@implementation GYEmptyView

- (void)zx_customSetting{
    self.zx_type = GYUINoDataState;
    self.zx_autoHideWhenTapOrClick = NO;
    self.zx_autoAdjustWhenHeaderView = NO;
    self.zx_autoAdjustWhenFooterView = NO;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setZx_type:(int)zx_type{
    if(zx_type == GYUINoDataState){
        //暂无数据的样式
        self.zx_topImageView.image = [UIImage imageNamed:@"no_data"];
        self.zx_topImageView.zx_fixSize = CGSizeMake(120, 120);
        self.zx_titleLabel.zx_fixTop = 10;
        self.zx_titleLabel.text = @"";
        self.zx_titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
    }else if(zx_type == GYUIApiErrorState){
        //接口报错的样式
        self.zx_topImageView.image = [UIImage imageNamed:@"api_error"];
        self.zx_topImageView.zx_fixSize = CGSizeMake(80, 80);
        self.zx_titleLabel.zx_fixTop = 10;
        self.zx_titleLabel.text = @"接口错误";
        self.zx_titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.zx_actionBtn.zx_fixTop = 10;
        self.zx_actionBtn.zx_additionWidth = 20;
        self.zx_actionBtn.zx_additionHeight = 15;
        self.zx_actionBtn.layer.cornerRadius = 6;
        [self.zx_actionBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        self.zx_actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.zx_actionBtn.backgroundColor = HXControlBg;
        [self.zx_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        //网络错误的样式
        self.zx_topImageView.image = [UIImage imageNamed:@"net_error"];
        self.zx_topImageView.zx_fixSize = CGSizeMake(80, 80);
        self.zx_titleLabel.zx_fixTop = 10;
        self.zx_titleLabel.text = @"网络异常，请检查网络设置";
        self.zx_titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        self.zx_actionBtn.zx_fixTop = 10;
        self.zx_actionBtn.zx_additionWidth = 20;
        self.zx_actionBtn.zx_additionHeight = 15;
        self.zx_actionBtn.layer.cornerRadius = 6;
        [self.zx_actionBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        self.zx_actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.zx_actionBtn.backgroundColor = HXControlBg;
        [self.zx_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
