//
//  GXPartnerIncomeVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/19.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXPartnerIncomeVC.h"
#import "GXPartnerIncomeCell.h"
#import "HXSearchBar.h"
#import "GXPartnerIncome.h"
#import <WMZDropDownMenu.h>
#import "FCDropMenuCollectionHeader.h"
#import "FCDropMenuCollectionCell.h"
#import "FCDropMenuRangeCollectionCell.h"

static NSString *const PartnerIncomeCell = @"PartnerIncomeCell";
@interface GXPartnerIncomeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WMZDropMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 列表 */
@property(nonatomic,strong) NSMutableArray *income;
@property (nonatomic, strong) WMZDropDownMenu *menu;
/**搜索关键词 */
@property (nonatomic, copy) NSString *shop_name;
/** 开始时间 */
@property (nonatomic, copy) NSString *start_time;
/** 结束时间 */
@property (nonatomic, copy) NSString *end_time;
@end

@implementation GXPartnerIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavbar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getDataCountRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)income
{
    if (_income == nil) {
        _income = [NSMutableArray array];
    }
    return _income;
}
-(WMZDropDownMenu *)menu
{
    if (_menu == nil) {
        WMZDropMenuParam *param =
        MenuParam()
        .wMainRadiusSet(5)
        .wMenuTitleEqualCountSet(1)
        .wPopOraignYSet(self.HXNavBarHeight)
        .wCollectionViewCellSelectTitleColorSet(HXControlBg)
        .wCollectionViewCellTitleColorSet([UIColor blackColor])
        .wCollectionViewSectionRecycleCountSet(8)
        .wMaxHeightScaleSet(0.5)
        //注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
        .wReginerCollectionHeadViewsSet(@[@"FCDropMenuCollectionHeader"])
        //注册自定义collectionViewCell 类名 如果使用了自定义collectionView 必填否则会崩溃
        .wReginerCollectionCellsSet(@[@"FCDropMenuCollectionCell",@"FCDropMenuRangeCollectionCell"]);
        
        _menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 44.f) withParam:param];
        _menu.delegate = self;
    }
    return _menu;
}
-(void)setUpNavbar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 88.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 15.f;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入母婴店名称查询";
    self.searchBar = searchBar;
    self.navigationItem.titleView = searchBar;
    
    SPButton *filter = [SPButton buttonWithType:UIButtonTypeCustom];
    filter.hxn_size = CGSizeMake(40, 40);
    filter.titleLabel.font = [UIFont systemFontOfSize:9];
    [filter setImage:HXGetImage(@"时间筛选") forState:UIControlStateNormal];
    [filter addTarget:self action:@selector(filterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filter];
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
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXPartnerIncomeCell class]) bundle:nil] forCellReuseIdentifier:PartnerIncomeCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getDataCountRequest:YES];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getDataCountRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getDataCountRequest:NO];
    }];
}
#pragma mark -- 点击事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField hasText]) {
        self.shop_name = textField.text;
    }else{
        self.shop_name = @"";
    }
    [self getDataCountRequest:YES];
    return YES;
}
-(void)filterClicked
{
    // 判断一个view是否为另一个view的子视图
    BOOL isSubView = [self.menu isDescendantOfView:self.view];
    if (isSubView) {
        [self.menu removeFromSuperview];
    }else{
        [self.view addSubview:self.menu];
    }
    [self.menu selectDefaltExpand];
}
#pragma mark -- 数据请求
-(void)getDataCountRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"post_id"] = [MSUserManager sharedInstance].curUserInfo.post_id;
    parameters[@"shop_name"] = self.shop_name;
    parameters[@"start_time"] = self.start_time;
    parameters[@"end_time"] = self.end_time;
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"program/getDataCount" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.income removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXPartnerIncome class] json:responseObject[@"data"]];
                [strongSelf.income addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GXPartnerIncome class] json:responseObject[@"data"]];
                    [strongSelf.income addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.income.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXPartnerIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:PartnerIncomeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXPartnerIncome *income = self.income[indexPath.row];
    cell.income = income;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- WMZDropMenuDelegate必须实现的代理
/*
*标题数组
 1 传字符串数组 其余属性为默认 如 @[@"标题1"],@"标题2",@"标题3",@"标题4"]
 2 可传带字典的数组
 字典参数@{
 @"name":@"标题",
 @"font":@(15)(字体大小)
 @"normalColor":[UIColor blackClor](普通状态下的字体颜色)
 @"selectColor":[UIColor redColor](选中状态下的字体颜色)
 @"normalImage":@"1"(普通状态下的图片)
 @"selectImage":@"2"(选中状态下的图片)
 @"reSelectImage":@"3"(选中状态下再点击的图片~>用于点击两次才回到原来的场景)
 @"lastFix":@(YES) (最后一个固定在在右边,仅最后一个有效)
 }
*/
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    
    return @[
         @{@"name":@"更多",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"下拉红色",@"selectImage":@"上拉红色"}
    ];
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
          
          if (dropIndexPath.row == 0)  return @[@{@"config":@{@"lowPlaceholder":@"起始",@"highPlaceholder":@"终止",@"isShowPicker":@(YES)},@"otherData":@"data_time"}];
      }
      return @[];
}
/*
*返回setion行标题有多少列 默认1列
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 1;
}
/*
*返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
     return 35;
}
#pragma mark -- WMZDropDownMenu交互自定义代理
/*
* WMZDropIndexPath上的内容点击 是否关闭视图 default YES
*/
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}
/*
*是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 取消，互不关联
*/
-(BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section
{
    return NO;
}
/*
*返回WMZDropIndexPath每行 每列的UI样式  默认MenuUITableView
  注:设置了dropIndexPath.section 设置了 MenuUITableView 那么row则全部为MenuUITableView 保持统一风格
*/
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return MenuUICollectionView;
}
/*
*返回WMZDropIndexPath每行 每列 显示的个数
 注:
    样式MenuUICollectionView         默认4个
    样式MenuUITableView    默认1个 传值无效
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 1;
}
/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
*/
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    return MenuShowAnimalBottom;
}
/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
*/
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalNone;
}
/*
*返回WMZDropIndexPath每行 每列的编辑类型 单选|多选  默认单选
*/
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath
{
    return MenuEditOneCheck;
}
/*
*WMZDropIndexPath是否显示收缩功能 default >参数wCollectionViewSectionShowExpandCount 显示；会有展开按钮的显示
*/
- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}
/*
*自定义headView高度 collectionView默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 60;
}
/*
*自定义footView高度
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForFootViewAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath{
    return 30.f;
}
/*
*自定义collectionView headView
*/
- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath
{
    FCDropMenuCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCDropMenuCollectionHeader" forIndexPath:indexpath];
    
    header.textLa.text = @[@"时间"][dropIndexPath.row];
    return header;
}
/*
 *自定义collectionViewCell内容
 */
- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    FCDropMenuRangeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCDropMenuRangeCollectionCell class]) forIndexPath:indexpath];
    if ([model isKindOfClass:[WMZDropTree class]]) {
        WMZDropTree *tree = model;
        tree.lowPlaceholder = tree.config[@"lowPlaceholder"]?:tree.lowPlaceholder;
        tree.highPlaceholder = tree.config[@"highPlaceholder"]?:tree.highPlaceholder;
        cell.isShowPicker = tree.config[@"isShowPicker"]?YES:NO;
        cell.lowText.placeholder =  tree.lowPlaceholder;
        cell.highText.placeholder = tree.highPlaceholder;
        
        cell.lowText.text = tree.rangeArr.count>1?tree.rangeArr[0]:@"";
        cell.highText.text = tree.rangeArr.count>1?tree.rangeArr[1]:@"";
        if (!tree.normalRangeArr||!tree.normalRangeArr.count) {
            if ([cell.lowText.text length]&&[cell.highText.text length]) {
                tree.normalRangeArr = @[cell.lowText.text,cell.highText.text];
            }
        }
        MenuWeakSelf(cell)
        cell.fieldBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
            MenuStrongSelf(weakObject)
            if (textField == cell.lowText) {
                strongObject.lowT = string;
                if (strongObject.lowT) {
                    tree.rangeArr[0] = strongObject.lowT;
                }
            }else{
                strongObject.highT = string;
                if (strongObject.highT) {
                    tree.rangeArr[1] = strongObject.highT;
                }
            }
            tree.isSelected = YES;
        };
        tree.isSelected = ([cell.lowText.text length]>0||[cell.highText.text length]>0);
        cell.lowText.backgroundColor = menu.param.wCollectionViewCellBgColor;
        cell.highText.backgroundColor = menu.param.wCollectionViewCellBgColor;
    }
    return cell;
}
/*
*自定义每行全局尾部视图 多用于交互事件
*/
- (UIView*)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section{
    UIView *userInteractionFootView = [UIView new];
    userInteractionFootView.backgroundColor = [UIColor whiteColor];
    userInteractionFootView.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 50);

    UIImageView *shaImg = [[UIImageView alloc] init];
    shaImg.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 2);
    shaImg.image = HXGetImage(@"筛选阴影");
    [userInteractionFootView addSubview:shaImg];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(HX_SCREEN_WIDTH/2.0-110.f, 8.f,100.f,34.f);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5.f;
    [btn setBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [btn setTitle:@"重置" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [btn addTarget:menu action:@selector(reSetAction) forControlEvents:UIControlEventTouchUpInside];
    [userInteractionFootView addSubview:btn];
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(HX_SCREEN_WIDTH/2.0+10.f, 8.f,100.f,34.f);
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    btn1.clipsToBounds = YES;
    btn1.layer.cornerRadius = 5.f;
    [btn1 setBackgroundColor:UIColorFromRGB(0xEA4A5C)];
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:menu action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [userInteractionFootView addSubview:btn1];
    
    return userInteractionFootView;
}
/*
*获取所有选中的数据
*/
-(void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray *)selectData
{
    [menu removeFromSuperview];

    /** 开始时间 */
    self.start_time = nil;//
    /** 结束时间 */
    self.end_time =  nil;//

    for (WMZDropTree *tree in selectData) {
        NSString *orKey = (NSString *)tree.otherData;
        if ([orKey isEqualToString:@"data_time"]) {
            self.start_time = tree.rangeArr.count>1?tree.rangeArr[0]:@"";
            self.end_time = tree.rangeArr.count>1?tree.rangeArr[1]:@"";
        }
    }

    [self getDataCountRequest:YES];
}
@end
