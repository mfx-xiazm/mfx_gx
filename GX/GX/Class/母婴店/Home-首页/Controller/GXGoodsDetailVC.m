//
//  GXGoodsDetailVC.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsDetailVC.h"
#import "GXGoodsMaterialCell.h"
#import "GXGoodsMaterialLayout.h"
#import "GXGoodsCommentLayout.h"
#import "GXGoodsCommentCell.h"
#import "GXAllMaterialVC.h"
#import "GXAllCommentVC.h"
#import "GXGoodsDetailSectionHeader.h"
#import "GXGoodsDetailHeader.h"
#import "GXGoodsInfoCell.h"
#import "GXWebContentVC.h"
#import <WebKit/WebKit.h>
#import "GXChooseClassView.h"
#import <zhPopupController.h>
#import "GXSankPriceVC.h"

static NSString *const GoodsInfoCell = @"GoodsInfoCell";
@interface GXGoodsDetailVC ()<UITableViewDelegate,WKNavigationDelegate,UITableViewDataSource,GXGoodsMaterialCellDelegate,GXGoodsCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GXGoodsDetailHeader *header;
/** 素材布局数组 */
@property (nonatomic,strong) NSMutableArray *materialLayoutsArr;
/** 评论布局数组 */
@property (nonatomic,strong) NSMutableArray *commentLayoutsArr;
/** 尾部视图 */
@property(nonatomic,strong) UIView *footer;
/* https://www.jianshu.com/p/7179e886a109 */
@property(nonatomic,strong) WKWebView *webView;
/* 缓存自适应的cell高度 */
@property(nonatomic,strong) NSMutableDictionary *cellHeightsDictionary;
@end

@implementation GXGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/7179e886a109"]]];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/5.0 + 50.f + 150);
}
-(NSMutableDictionary *)cellHeightsDictionary
{
    if (_cellHeightsDictionary == nil) {
        _cellHeightsDictionary = [NSMutableDictionary dictionary];
    }
    return _cellHeightsDictionary;
}
-(GXGoodsDetailHeader *)header
{
    if (_header == nil) {
        _header = [GXGoodsDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/5.0 + 50.f + 150);
    }
    return _header;
}
-(WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
        [self.footer addSubview:_webView];
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(NSMutableArray *)materialLayoutsArr
{
    if (!_materialLayoutsArr) {
        _materialLayoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment1" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            GXGoodsMaterial *model = [GXGoodsMaterial yy_modelWithDictionary:dict];
            GXGoodsMaterialLayout *layout = [[GXGoodsMaterialLayout alloc] initWithModel:model];
            [_materialLayoutsArr addObject:layout];
        }
    }
    return _materialLayoutsArr;
}
-(NSMutableArray *)commentLayoutsArr
{
    if (!_commentLayoutsArr) {
        _commentLayoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            GXGoodsComment *model = [GXGoodsComment yy_modelWithDictionary:dict];
            GXGoodsCommentLayout *layout = [[GXGoodsCommentLayout alloc] initWithModel:model];
            [_commentLayoutsArr addObject:layout];
        }
    }
    return _commentLayoutsArr;
}
-(UIView *)footer
{
    if (_footer == nil) {
        _footer = [UIView new];
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        image.backgroundColor = [UIColor whiteColor];
        image.contentMode = UIViewContentModeCenter;
        image.image = HXGetImage(@"商品描述");
        [_footer addSubview:image];
    }
    return _footer;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    UIBarButtonItem *cartItem = [UIBarButtonItem itemWithTarget:self action:@selector(cartClicked) image:HXGetImage(@"购物车黑色")];
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) image:HXGetImage(@"分享黑色")];
    
    UIButton *material = [UIButton buttonWithType:UIButtonTypeCustom];
    [material setTitle:@"卖货素材" forState:UIControlStateNormal];
    [material setTitleColor:HXControlBg forState:UIControlStateNormal];
    material.titleLabel.font = [UIFont systemFontOfSize:12];
    material.hxn_size = CGSizeMake(70, 22);
    material.layer.cornerRadius = 11.f;
    material.layer.masksToBounds = YES;
    material.backgroundColor = [UIColor whiteColor];
    [material addTarget:self action:@selector(materialClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *materialItem = [[UIBarButtonItem alloc] initWithCustomView:material];
    
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
    [apply setTitle:@"我要供货" forState:UIControlStateNormal];
    [apply setTitleColor:HXControlBg forState:UIControlStateNormal];
    apply.titleLabel.font = [UIFont systemFontOfSize:12];
    apply.hxn_size = CGSizeMake(70, 22);
    apply.layer.cornerRadius = 11.f;
    apply.layer.masksToBounds = YES;
    apply.backgroundColor = [UIColor whiteColor];
    [apply addTarget:self action:@selector(applyClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *applyItem = [[UIBarButtonItem alloc] initWithCustomView:apply];
    
    self.navigationItem.rightBarButtonItems = @[cartItem,shareItem,materialItem,applyItem];
}
- (void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:GoodsInfoCell];

    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)cartClicked
{
    
}
-(void)shareClicked
{
    
}
-(void)materialClicked
{
    GXAllMaterialVC *mvc = [GXAllMaterialVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(void)applyClicked
{
    GXWebContentVC *wvc = [GXWebContentVC new];
    wvc.url = @"http://news.cctv.com/2019/10/03/ARTI2EUlwRGH3jMPI6cAVqti191003.shtml";
    wvc.navTitle = @"申请供货";
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)sankPriceClicked:(SPButton *)sender {
    GXSankPriceVC *pvc = [GXSankPriceVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)buyGoodsClicked:(UIButton *)sender {
    GXChooseClassView *cv = [GXChooseClassView loadXibView];
    cv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 380);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:cv duration:0.25 springAnimated:NO];
}

#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height);
        self.footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height + 60.f);
        self.tableView.tableFooterView = self.footer;
    }
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
-(void)dealloc
{
    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
#pragma mark -- TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.materialLayoutsArr.count;
    }else if (section == 1) {
        return self.commentLayoutsArr.count;
    }else{
        return 5;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GXGoodsMaterialLayout *layout = self.materialLayoutsArr[indexPath.row];
        return layout.height;
    }else if (indexPath.section == 1) {
        GXGoodsCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
        return layout.height;
    }else{
        NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
        if (height) return height.doubleValue;
        return UITableViewAutomaticDimension;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GXGoodsMaterialCell * cell = [GXGoodsMaterialCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GXGoodsMaterialLayout *layout = self.materialLayoutsArr[indexPath.row];
        cell.materialLayout = layout;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        GXGoodsCommentCell * cell = [GXGoodsCommentCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GXGoodsCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
        cell.commentLayout = layout;
        cell.delegate = self;
        return cell;
    }else{
        GXGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXGoodsDetailSectionHeader *header = [GXGoodsDetailSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    if (section == 0) {
        header.titleLabel.text = @"素材";
    }else if (section == 1){
        header.titleLabel.text = @"评价";
    }else{
        header.titleLabel.text = @"商品规格";
    }
    hx_weakify(self);
    header.sectionClickCall = ^{
        hx_strongify(weakSelf);
        if (section == 0) {
            GXAllMaterialVC *mvc = [GXAllMaterialVC new];
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        }else if (section == 1) {
            GXAllCommentVC *mvc = [GXAllCommentVC new];
            [strongSelf.navigationController pushViewController:mvc animated:YES];
        }
    };
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- GXGoodsMaterialCellDelegate
/** 点击了全文/收回 */
- (void)didClickMoreLessInCell:(GXGoodsMaterialCell *)Cell
{
    GXGoodsMaterialLayout *layout = Cell.materialLayout;
    layout.material.isOpening = !layout.material.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
/** 查看商品 */
- (void)didClickGoodsInCell:(GXGoodsMaterialCell *)Cell
{
    HXLog(@"查看商品");
}
/** 分享 */
- (void)didClickShareInCell:(GXGoodsMaterialCell *)Cell
{
    HXLog(@"分享");
}
#pragma mark -- GXGoodsCommentCellDelegate
/** 点击了全文/收回 */
-(void)didClickMoreLessInCommentCell:(GXGoodsCommentCell *)Cell
{
    GXGoodsCommentLayout *layout = Cell.commentLayout;
    layout.comment.isOpening = !layout.comment.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
@end
