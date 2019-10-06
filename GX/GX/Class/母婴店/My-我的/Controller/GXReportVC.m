//
//  GXReportVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXReportVC.h"
#import "JJOptionView.h"
#import "GXOnLineReportVC.h"
#import "GXOffLineReportVC.h"

@interface GXReportVC ()
@property (weak, nonatomic) IBOutlet UIView *optionSuperView;
/* 选择 */
@property(nonatomic,strong) JJOptionView *optionView;
/* 选择的类型 */
@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation GXReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"窜货举报"];
    [self.optionSuperView addSubview:self.optionView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.optionView.frame = self.optionSuperView.bounds;
}
-(JJOptionView *)optionView
{
    if (_optionView == nil) {
        _optionView = [[JJOptionView alloc] initWithFrame:self.optionSuperView.bounds];
        _optionView.dataSource = @[@"线上违规窜货",@"线下违规窜货"];
        _optionView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _optionView.titleColor = UIColorFromRGB(0x131d2d);
        _optionView.titleFontSize = 14.f;
        _optionView.cornerRadius = 2;
        _optionView.borderColor = [UIColor clearColor];
        _optionView.borderWidth = 0;
        hx_weakify(self);
        _optionView.selectedBlock = ^(JJOptionView * _Nonnull optionView, NSInteger selectedIndex) {
            hx_strongify(weakSelf);
            strongSelf.selectIndex = selectedIndex;
        };
    }
    return _optionView;
}
- (IBAction)nextBtnClicked:(UIButton *)sender {
    if (self.selectIndex == 0) {
        GXOnLineReportVC *rvc = [GXOnLineReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        GXOffLineReportVC *rvc = [GXOffLineReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

@end
