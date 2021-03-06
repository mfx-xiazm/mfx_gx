//
//  GXChooseValidAddressView.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseValidAddressView.h"
#import "GXValidAddressCell.h"
#import "GXMyAddress.h"

static NSString *const ValidAddressCell = @"ValidAddressCell";
@interface GXChooseValidAddressView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 选择的地址 */
@property(nonatomic,strong) GXMyAddress *selectAddress;
@end

@implementation GXChooseValidAddressView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXValidAddressCell class]) bundle:nil] forCellReuseIdentifier:ValidAddressCell];
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.chooseAddressCall) {
        self.chooseAddressCall(nil);
    }
}

-(void)setAddressList:(NSArray *)addressList
{
    _addressList = addressList;
    [self.tableView reloadData];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXValidAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ValidAddressCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXMyAddress *address = self.addressList[indexPath.row];
    cell.address = address;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectAddress.isSelected = NO;
    
    GXMyAddress *address = self.addressList[indexPath.row];
    address.isSelected = YES;
    
    self.selectAddress = address;
    
    [tableView reloadData];
    
    if (self.chooseAddressCall) {
        self.chooseAddressCall(address);
    }
}

@end
