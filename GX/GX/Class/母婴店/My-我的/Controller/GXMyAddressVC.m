//
//  GXMyAddressVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyAddressVC.h"
#import "GXMyAddressCell.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GXEditAddressVC.h"

static NSString *const MyAddressCell = @"MyAddressCell";
@interface GXMyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GXMyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"收货地址"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyAddressCell class]) bundle:nil] forCellReuseIdentifier:MyAddressCell];
}
#pragma mark -- 点击事件
- (IBAction)addAddressClicked:(UIButton *)sender {
    GXEditAddressVC *avc = [GXEditAddressVC new];
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAddressCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    hx_weakify(self);
    cell.addressClickedCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        if (index == 1) {
            
        }else if (index == 2) {
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该地址吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            hx_weakify(self);
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            GXEditAddressVC *avc = [GXEditAddressVC new];
            [strongSelf.navigationController pushViewController:avc animated:YES];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 105.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
