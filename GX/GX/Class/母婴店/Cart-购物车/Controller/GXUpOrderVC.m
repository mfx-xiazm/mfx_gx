//
//  GXUpOrderVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXUpOrderVC.h"
#import "GXUpOrderCell.h"
#import "GXUpOrderHeader.h"
#import "GXUpOrderFooter.h"
#import "GXChooseCouponVC.h"
#import "GXPayTypeVC.h"

static NSString *const UpOrderCell = @"UpOrderCell";

@interface GXUpOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXUpOrderHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GXUpOrderFooter *footer;
@end

@implementation GXUpOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提交订单"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
}
-(GXUpOrderHeader *)header
{
    if (_header == nil) {
        _header = [GXUpOrderHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 80.f);
    }
    return _header;
}
-(GXUpOrderFooter *)footer
{
    if (_footer == nil) {
        _footer = [GXUpOrderFooter loadXibView];
        _footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
        hx_weakify(self);
        _footer.getCouponCall = ^{
            hx_strongify(weakSelf);
            GXChooseCouponVC *cvc = [GXChooseCouponVC new];
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        };
    }
    return _footer;
}
#pragma mark -- 视图相关
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXUpOrderCell class]) bundle:nil] forCellReuseIdentifier:UpOrderCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 点击事件
- (IBAction)upOrderClicked:(UIButton *)sender {
    GXPayTypeVC *pvc = [GXPayTypeVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXUpOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:UpOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 40.f*4 + 110.f*2 + 10.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
