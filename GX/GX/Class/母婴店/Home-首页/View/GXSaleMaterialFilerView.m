//
//  GXSaleMaterialFilerView.m
//  GX
//
//  Created by 夏增明 on 2019/10/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXSaleMaterialFilerView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXRunCategoryCell.h"
#import "GXChooseClassHeader.h"
#import "GXMaterialFilter.h"
#import "GXCatalogItem.h"
#import "GXTopSaleMaterial.h"
#import "GXTopSaleMaterial.h"

//遮罩颜色
#define bgColor [UIColor colorWithWhite:0.0 alpha:0.2]
//默认未选中文案颜色
#define unselectColor UIColorFromRGB(0x131d2d)
//默认选中文案颜色
#define selectColor UIColorFromRGB(0xFF9F08)

static NSString *const ChooseClassHeader = @"ChooseClassHeader";
static NSString *const CategoryCell = @"CategoryCell";
@interface GXSaleMaterialFilerView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
//是否显示
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UIView *backGroundView;
/* 操作按钮视图 */
@property(nonatomic,strong) UIView *btnView;
/* 选中的商品分类 */
@property(nonatomic,strong) GXCatalogItem *selectLog;
/* 选中的品牌宣传 */
@property(nonatomic,strong) GXTopSaleMaterial *selectAdvertise;
/* 选中的卖货方案 */
@property(nonatomic,strong) GXTopSaleMaterial *selectPlan;

@end

@implementation GXSaleMaterialFilerView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //列表
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRunCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:CategoryCell];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];

    UIView *buttomView = [[UIView alloc] initWithFrame:self.bounds];
    buttomView.backgroundColor = [UIColor clearColor];
    buttomView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [buttomView addGestureRecognizer:gesture0];
    [self addSubview:buttomView];

    //遮罩
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = bgColor;
    _backGroundView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    
    [self addSubview:_collectionView];
    
    
    _btnView = [[UIView alloc] init];
    _btnView.backgroundColor = [UIColor whiteColor];
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.tag = 1;
    sure.frame = CGRectMake(HX_SCREEN_WIDTH-70-10, 15, 70, 26);
    sure.backgroundColor = HXControlBg;
    sure.layer.cornerRadius = 13.f;
    sure.layer.masksToBounds = YES;
    sure.titleLabel.font = [UIFont systemFontOfSize:12];
    [sure addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [_btnView addSubview:sure];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.tag = 0;
    reset.frame = CGRectMake(HX_SCREEN_WIDTH-70*2-10*2, 15, 70, 26);
    reset.layer.cornerRadius = 13.f;
    reset.layer.borderWidth = 1;
    reset.layer.borderColor = UIColorFromRGB(0x1a1a1a).CGColor;
    reset.layer.masksToBounds = YES;
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset setTitleColor:UIColorFromRGB(0x1a1a1a) forState:UIControlStateNormal];
    reset.titleLabel.font = [UIFont systemFontOfSize:12];
    [reset addTarget:self action:@selector(handleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:reset];
    
    [self addSubview:_btnView];
}

#pragma mark - 更新数据源
-(void)reloadData {
    [_collectionView reloadData];
}
#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterMenu_positionInSuperView)]) {
            CGPoint position = [self.delegate filterMenu_positionInSuperView];
            _collectionView.frame = CGRectMake(0.f, position.y, self.frame.size.width, HX_SCREEN_HEIGHT-260.f);
            _btnView.frame = CGRectMake(0.f, CGRectGetMaxY(_collectionView.frame), self.frame.size.width, 50.f);
            _backGroundView.frame = CGRectMake(0.f, position.y, self.frame.size.width, HX_SCREEN_HEIGHT-position.y);
        } else {
            self.frame = CGRectMake(0, 0, self.frame.size.width, HX_SCREEN_HEIGHT);
        }
        if (view) {
            [view addSubview:self];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
    hx_weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        hx_strongify(weakSelf);
        strongSelf.backGroundView.backgroundColor = strongSelf.show ? [UIColor colorWithWhite:0.0 alpha:0.0] : bgColor;
        if (strongSelf.transformImageView) {
            strongSelf.transformImageView.transform = strongSelf.show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        }
    } completion:^(BOOL finished) {
        hx_strongify(weakSelf);
        if (strongSelf.show) {
            [strongSelf removeFromSuperview];
        }
        strongSelf.show = !strongSelf.show;
    }];
    
    self.titleLabel.textColor = HXControlBg;
    
    [self reloadData];
}

#pragma mark - 触发收起事件
- (void)handleBtnClicked:(UIButton *)sender {
    if (sender.tag) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterMenu:didSelectLogId:didSelectAdvertiseId:didSelectPlanId:)]) {
            [self.delegate filterMenu:self didSelectLogId:(self.selectLog && self.selectLog.isSelected)?self.selectLog.catalog_id:@"" didSelectAdvertiseId:(self.selectAdvertise && self.selectAdvertise.isSelected)?self.selectAdvertise.material_filter_id:@"" didSelectPlanId:(self.selectPlan && self.selectPlan.isSelected)?self.selectPlan.material_filter_id:@""];
            [self menuHidden];
        }
    }else{
        self.selectLog.isSelected = NO;
        self.selectAdvertise.isSelected = NO;
        self.selectPlan.isSelected = NO;
        
        [self.collectionView reloadData];
    }
}
- (void)menuHidden{
    if (_show) {
        self.titleLabel.textColor = UIColorFromRGB(0x131D2D);
        hx_weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            hx_strongify(weakSelf);
            strongSelf.backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (strongSelf.transformImageView) {
                strongSelf.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            hx_strongify(weakSelf);
            strongSelf.show = !strongSelf.show;
            [strongSelf removeFromSuperview];
            if ([strongSelf.delegate respondsToSelector:@selector(filterMenu_didDismiss)]) {
                [strongSelf.delegate filterMenu_didDismiss];
            }
        }];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSource.catalog.count;
    }else if (section == 1) {
        return self.dataSource.advertise.count;
    }else{
        return self.dataSource.plan.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXRunCategoryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        GXCatalogItem *caItem = self.dataSource.catalog[indexPath.item];
        cell.logItem = caItem;
    }else if (indexPath.section == 1) {
        GXTopSaleMaterial *material = self.dataSource.advertise[indexPath.item];
        cell.material = material;
    }else{
        GXTopSaleMaterial *material = self.dataSource.plan[indexPath.item];
        cell.material = material;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.selectLog.isSelected = NO;
        GXCatalogItem *caItem = self.dataSource.catalog[indexPath.item];
        caItem.isSelected = YES;
        self.selectLog = caItem;
    }else if (indexPath.section == 1) {
        self.selectAdvertise.isSelected = NO;
        GXTopSaleMaterial *material = self.dataSource.advertise[indexPath.item];
        material.isSelected = YES;
        self.selectAdvertise = material;
    }else{
        self.selectPlan.isSelected = NO;
        GXTopSaleMaterial *material = self.dataSource.plan[indexPath.item];
        material.isSelected = YES;
        self.selectPlan = material;
    }
    
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,44.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (indexPath.section==0) {
            header.titleLabel.text = @"商品分类";
        }else if (indexPath.section==1) {
            header.titleLabel.text = @"品牌宣传";
        }else{
            header.titleLabel.text = @"卖货方案";
        }
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((HX_SCREEN_WIDTH-10*2.f-5*2.f)/3.0, 34);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 10, 5, 10);
}
@end
