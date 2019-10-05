//
//  GXRegionalVC.m
//  GX
//
//  Created by 夏增明 on 2019/9/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegionalVC.h"
#import "GXRegionalCell.h"
#import "GXRegionalHeader.h"
#import "GXWebContentVC.h"
#import "GXBrandPartnerVC.h"
#import "GXBrandDetailVC.h"
#import "GXSaleMaterialVC.h"
#import "GXTryApplyVC.h"
#import "GXPartnerDataVC.h"

static NSString *const RegionalCell = @"RegionalCell";

@interface GXRegionalVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXRegionalHeader *header;
@end

@implementation GXRegionalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 265.f);
}
-(GXRegionalHeader *)header
{
    if (_header == nil) {
        _header = [GXRegionalHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 265.f);
        hx_weakify(self);
        _header.regionalClickedCall = ^(NSInteger type, NSInteger index) {
            hx_strongify(weakSelf);
            if (type == 1) {
                GXWebContentVC *wvc = [GXWebContentVC new];
                wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
                wvc.navTitle = @"轮播图详情";
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }else if (type == 2){
                GXWebContentVC *wvc = [GXWebContentVC new];
                wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
                wvc.navTitle = @"公告详情";
                [strongSelf.navigationController pushViewController:wvc animated:YES];
            }else{
                if (index == 1) {
                    GXBrandPartnerVC *pvc = [GXBrandPartnerVC new];
                    [strongSelf.navigationController pushViewController:pvc animated:YES];
                }else if (index == 2){
                    GXPartnerDataVC *dvc = [GXPartnerDataVC new];
                    [strongSelf.navigationController pushViewController:dvc animated:YES];
                }else{
                    GXSaleMaterialVC *mvc = [GXSaleMaterialVC new];
                    [strongSelf.navigationController pushViewController:mvc animated:YES];
                }
            }
        };
    }
    return _header;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRegionalCell class]) bundle:nil] forCellReuseIdentifier:RegionalCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXRegionalCell *cell = [tableView dequeueReusableCellWithIdentifier:RegionalCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (indexPath.section == 0) {
        return 110.f;
    }else{
        return 260.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }else{
        return 44.f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIImageView *image = [[UIImageView alloc] init];
        image.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
        image.backgroundColor = HXGlobalBg;
        image.contentMode = UIViewContentModeCenter;
        image.image = HXGetImage(@"热门品牌");
        return image;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//本周上新
            GXBrandDetailVC *dvc = [GXBrandDetailVC new];
            [self.navigationController pushViewController:dvc animated:YES];
        }else{//试用装
            GXTryApplyVC *avc = [GXTryApplyVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }
    }else{//热门品牌
        GXBrandDetailVC *dvc = [GXBrandDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
