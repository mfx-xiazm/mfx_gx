//
//  GXSankPriceVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSankPriceVC.h"
#import "GXSankPriceCell.h"
#import "GXSankPriceSectionFooter.h"
#import "GXChooseValidAddressView.h"
#import <zhPopupController.h>

static NSString *const SankPriceCell = @"SankPriceCell";
@interface GXSankPriceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* titileView */
@property(nonatomic,strong) UIView *titileView;
@end

@implementation GXSankPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-100, 40.f);
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"配送至：咸宁市咸安区";
    CGSize titleSize = [title sizeThatFits:CGSizeZero];
    title.hxn_x = (titleView.hxn_width-titleSize.width)/2.0;
    title.hxn_y = (titleView.hxn_height-titleSize.height)/2.0;
    title.hxn_width = titleSize.width;
    title.hxn_height = titleSize.height;
    [titleView addSubview:title];
    
    UIImageView *dw = [[UIImageView alloc] initWithImage:HXGetImage(@"地址")];
    dw.hxn_centerY = titleView.hxn_centerY;
    dw.hxn_x = CGRectGetMinX(title.frame) - 20.f;
    [titleView addSubview:dw];
    
    UIImageView *zk = [[UIImageView alloc] initWithImage:HXGetImage(@"展开")];
    zk.hxn_centerY = titleView.hxn_centerY;
    zk.hxn_x = CGRectGetMaxX(title.frame) + 10.f;
    [titleView addSubview:zk];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = titleView.bounds;
    [coverBtn addTarget:self action:@selector(chooseAddressClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:coverBtn];

    self.titileView = titleView;
    
    self.navigationItem.titleView = titleView;
}
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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXSankPriceCell class]) bundle:nil] forCellReuseIdentifier:SankPriceCell];
}
#pragma mark -- 点击事件
-(void)chooseAddressClicked
{
    GXChooseValidAddressView *vdv = [GXChooseValidAddressView loadXibView];
    vdv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 300);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:vdv duration:0.25 springAnimated:NO];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXSankPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:SankPriceCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXSankPriceSectionFooter *footer = [GXSankPriceSectionFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 100.f);
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
