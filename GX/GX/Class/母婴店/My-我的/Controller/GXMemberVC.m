//
//  GXMemberVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMemberVC.h"
#import "GXMemberRankCell.h"
#import "GXMember.h"
#import "GXMineData.h"

static NSString *const MemberRankCell = @"MemberRankCell";
@interface GXMemberVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *now_amount;
@property (weak, nonatomic) IBOutlet UILabel *need_amout;

/* 会员权益 */
@property(nonatomic,strong) GXMember *member;
@end

@implementation GXMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"会员中心"];
    [self setUpTableView];
    
    [self geMemberLevelDataRequest];
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 85.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMemberRankCell class]) bundle:nil] forCellReuseIdentifier:MemberRankCell];
}
#pragma mark -- 接口请求
-(void)geMemberLevelDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/memberLevel" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.member = [GXMember yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showMemberData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showMemberData
{
    self.tableView.hidden = NO;
    
    self.shop_name.text = self.mineData.shop_name;
    self.now_amount.text = [NSString stringWithFormat:@"已消费￥%@",self.member.order_price_amount];
    self.need_amout.text = [NSString stringWithFormat:@"还需消费￥%@升级",self.member.level_need];
    
    [self.tableView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.tableViewHeight.constant = strongSelf.tableView.contentSize.height + 20.f;
    });
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.member.level.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMemberRankCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberRankCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.current_level_id = self.mineData.level_id;
    cell.price_amount = self.member.order_price_amount;
    GXMemberLevel *level = self.member.level[indexPath.row];
    cell.level = level;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 90.f;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
