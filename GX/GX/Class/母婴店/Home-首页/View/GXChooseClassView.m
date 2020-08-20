//
//  GXChooseClassView.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseClassView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXRunCategoryCell.h"
#import "GXChooseClassHeader.h"
#import "GXChooseClassFooter.h"
#import "GXGoodsDetail.h"
#import "ORSKUDataFilter.h"
#import "GXSpecBtn.h"

static NSString *const RunCategoryCell = @"RunCategoryCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";
static NSString *const ChooseClassFooter = @"ChooseClassFooter";

@interface GXChooseClassView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,ORSKUDataFilterDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_num;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIScrollView *selectTagView;
@property (nonatomic, strong) GXSpecBtn *lastBtn;
@property (nonatomic, strong) ORSKUDataFilter *filter;
@end
@implementation GXChooseClassView

-(void)awakeFromNib
{
    [super awakeFromNib];
        
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXRunCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:RunCategoryCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXChooseClassFooter class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter];
}
-(ORSKUDataFilter *)filter
{
    if (_filter == nil) {
        _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
    }
    return _filter;
}
- (IBAction)goodHandleClicked:(UIButton *)sender {
    if (sender.tag) {
        if (!_filter.currentResult) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品属性"];
            return;
        }
        
        if (_goodsDetail.sku.logistic && _goodsDetail.sku.logistic.count && !_goodsDetail.selectLogisticst) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择配送方式"];
            return;
        }
        
        if (_goodsDetail.sku.limit_num != -1 && _goodsDetail.sku.limit_num != 0) {
            if (self.goodsDetail.buyNum > _goodsDetail.sku.limit_num) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[NSString stringWithFormat:@"此规格限购%zd份",_goodsDetail.sku.limit_num]];
                return;
            }
        }
        
        if ([_goodsDetail.sku.stock isEqualToString:@"0"]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"商品库存为0"];
            return;
        }
        if (self.goodsHandleCall) {
            self.goodsHandleCall(sender.tag);
        }
    }else{
        if (self.goodsHandleCall) {
            self.goodsHandleCall(sender.tag);
        }
    }
}

-(void)setGoodsDetail:(GXGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goodsDetail.cover_img]];
    if ([_goodsDetail.control_type isEqualToString:@"2"]) {
        self.market_price.hidden = NO;
        self.market_price.text = [NSString stringWithFormat:@"建议零售价:￥%@",_goodsDetail.suggest_price];
    }else{
        self.market_price.hidden = NO;
        self.market_price.text = [NSString stringWithFormat:@"建议零售价:￥%@",_goodsDetail.suggest_price];
    }
    
    if (_goodsDetail.spec && _goodsDetail.spec.count) {
        [self initGoodsPriceStock];
    }
    if (!_filter) {
        //当数据更新的时候 需要reloadData
        [self.filter reloadData];
    }
    [self.collectionView reloadData];
}
-(void)initGoodsPriceStock
{
    if (_goodsDetail.sku) {
        self.price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.sku.price];
        self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.sku.stock];
    }else{
        self.stock_num.text = @"";
        if ([_goodsDetail.control_type isEqualToString:@"1"]) {
            if ([_goodsDetail.min_price floatValue] == [_goodsDetail.max_price floatValue]) {
                self.price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.min_price];
            }else{
                self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goodsDetail.min_price,_goodsDetail.max_price];
            }
        }else{
            self.price.text = [NSString stringWithFormat:@"￥%@  ",_goodsDetail.min_price];
        }
    }
}
-(void)getShopStockRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goodsDetail.goods_id;
    NSMutableString *spec_attr_ids = [NSMutableString string];
    for (GXGoodsDetailSpec *spec in _goodsDetail.spec) {
        if (spec_attr_ids.length) {
            [spec_attr_ids appendFormat:@",%@",spec.selectSpec.attr_id];
        }else{
            [spec_attr_ids appendFormat:@"%@",spec.selectSpec.attr_id];
        }
    }
    parameters[@"spec_attr_ids"] = spec_attr_ids;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.goodsDetail.presell_id && self.goodsDetail.presell_id.length)?@"admin/getPreSkuDetail":@"admin/getSkuDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                strongSelf.goodsDetail.sku = [GXGoodsDetailSku yy_modelWithDictionary:responseObject[@"data"]];
                // 清除选择的快递
                strongSelf.goodsDetail.selectLogisticst = nil;
            }else{
                GXGoodsDetailSku *sku = [[GXGoodsDetailSku alloc] init];
                sku.sku_id = @"0";
                sku.provider_no = @"暂无";
                sku.price = strongSelf.goodsDetail.min_price;
                sku.stock = @"0";
                sku.logistic = @[];
                sku.limit_num = -1;//不限购
                strongSelf.goodsDetail.sku = sku;
                // 清除选择的快递
                strongSelf.goodsDetail.selectLogisticst = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.price.text = [NSString stringWithFormat:@"￥%@",strongSelf.goodsDetail.sku.price];
                strongSelf.stock_num.text = [NSString stringWithFormat:@"库存：%@",strongSelf.goodsDetail.sku.stock];
                [strongSelf updateSelectView];
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)updateSelectView
{
    self.lastBtn = nil;
    for (UIView *sub in self.selectTagView.subviews) {
        if ([sub isKindOfClass:[GXSpecBtn class]]) {
            [sub removeFromSuperview];
        }
    }
    for (int i=0; i<self.goodsDetail.spec.count; i++) {
        GXGoodsDetailSpec *spec = self.goodsDetail.spec[i];
        if (spec.selectSpec && spec.selectSpec.isSelected) {
            GXSpecBtn *btn = [GXSpecBtn new];
            btn.indexPath = spec.selectSpec.indexPath;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:HXControlBg forState:UIControlStateNormal];
            [btn setTitle:spec.selectSpec.attr_name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn sizeToFit];
            if (self.lastBtn) {
                btn.frame = CGRectMake(self.lastBtn.hxn_right+10.f, 13.f, btn.hxn_width + 15.f, 24.f);
            }else{
                btn.frame = CGRectMake(0, 13.f, btn.hxn_width + 15.f, 24.f);
            }
            [self.selectTagView addSubview:btn];
            self.lastBtn = btn;
        }
    }
    if (self.goodsDetail.selectLogisticst && self.goodsDetail.selectLogisticst.isSelected) {
        GXSpecBtn *btn = [GXSpecBtn new];
        btn.indexPath = self.goodsDetail.selectLogisticst.indexPath;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:HXControlBg forState:UIControlStateNormal];
        [btn setTitle:self.goodsDetail.selectLogisticst.freight_type forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        if (self.lastBtn) {
            btn.frame = CGRectMake(self.lastBtn.hxn_right+10.f, 13.f, btn.hxn_width + 15.f, 24.f);
        }else{
            btn.frame = CGRectMake(0, 13.f, btn.hxn_width + 15.f, 24.f);
        }
        [self.selectTagView addSubview:btn];
        self.lastBtn = btn;
    }
    self.selectTagView.contentSize = CGSizeMake(self.lastBtn.hxn_right + 10.f, 0);
}
-(void)selectBtnClicked:(GXSpecBtn *)btn
{
    [self collectionView:self.collectionView didSelectItemAtIndexPath:btn.indexPath];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        return self.goodsDetail.spec.count+1;
    }else{
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (section <= self.goodsDetail.spec.count-1) {
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[section];
            return spec.spec_val.count;
        }else{
            return self.goodsDetail.sku.logistic.count;
        }
    }else{
        return self.goodsDetail.sku.logistic.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXRunCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RunCategoryCell forIndexPath:indexPath];
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (indexPath.section <= self.goodsDetail.spec.count-1) {
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
            GXGoodsDetailSubSpec *subSpec = spec.spec_val[indexPath.row];
            cell.subSpec = subSpec;
            
            if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
                cell.contentText.textColor = UIColorFromRGB(0x1A1A1A);
                cell.contentText.backgroundColor = [UIColor whiteColor];
                cell.contentText.layer.borderColor = UIColorFromRGB(0x1A1A1A).CGColor;
            }else {
                cell.contentText.textColor = UIColorFromRGB(0x999999);
                cell.contentText.backgroundColor = [UIColor whiteColor];
                cell.contentText.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
            }
            
            if ([_filter.selectedIndexPaths containsObject:indexPath]) {
                cell.contentText.textColor = [UIColor whiteColor];
                cell.contentText.backgroundColor = HXControlBg;
                cell.contentText.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
            cell.logisticst = logisticst;
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
        cell.logisticst = logisticst;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (indexPath.section <= self.goodsDetail.spec.count-1) {
            
            [_filter didSelectedPropertyWithIndexPath:indexPath];

            if (![_filter.availableIndexPathsSet containsObject:indexPath]) {
                //不可选
                return;
            }

            self.goodsDetail.buyNum = 1;// 每次调整sku就将购买数量置为1
            
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
            spec.selectSpec.isSelected = NO;
            
            GXGoodsDetailSubSpec *subSpec = spec.spec_val[indexPath.item];
            
            if ([_filter.selectedIndexPaths containsObject:indexPath]) {
                spec.selectSpec.isSelected = NO;
                subSpec.isSelected = YES;
                subSpec.indexPath = indexPath;
                spec.selectSpec = subSpec;
            }else{
                spec.selectSpec.isSelected = NO;
                subSpec.isSelected = NO;
                subSpec.indexPath = indexPath;
                spec.selectSpec = nil;
            }
            
            GXGoodsDetailSku *resultSku = (GXGoodsDetailSku *)_filter.currentResult;
            
            if (resultSku != nil) {// 如果选择了一条完整的sku,就请求库存、价格和配送方式
                [self getShopStockRequest];
            }else{// 如果不是一条完整的sku,就重置上次的配送方式
                self.goodsDetail.sku = nil;
                self.goodsDetail.selectLogisticst = nil;
                [self initGoodsPriceStock];
                [self updateSelectView];
            }
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
            self.goodsDetail.selectLogisticst.isSelected = [logisticst isEqual:self.goodsDetail.selectLogisticst]?:NO;
            
            logisticst.isSelected = !logisticst.isSelected;
            logisticst.indexPath = indexPath;
            self.goodsDetail.selectLogisticst = logisticst;
            
            [self updateSelectView];
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
        self.goodsDetail.selectLogisticst.isSelected = [logisticst isEqual:self.goodsDetail.selectLogisticst]?:NO;
        
        logisticst.isSelected = !logisticst.isSelected;
        logisticst.indexPath = indexPath;
        self.goodsDetail.selectLogisticst = logisticst;
        
        [self updateSelectView];
    }
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,40.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (section < ((self.goodsDetail.spec.count+1)-2)) {
            return CGSizeZero;
        }else{
            return CGSizeMake(HX_SCREEN_WIDTH,40.f);
        }
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH,40.f);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GXChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
            if (indexPath.section <= self.goodsDetail.spec.count-1) {
                GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
                header.titleLabel.text = spec.specs_name;
            }else{
                header.titleLabel.text = self.goodsDetail.sku.logistic.count?@"配送方式":@"";
            }
        }else{
            header.titleLabel.text = self.goodsDetail.sku.logistic.count?@"配送方式":@"";;
        }
        return header;
    }else{
        GXChooseClassFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter forIndexPath:indexPath];
        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
            if (indexPath.section == self.goodsDetail.spec.count-1) {
                footer.numView.hidden = NO;
                footer.storeCodeView.hidden = YES;
                footer.stock_num = self.goodsDetail.sku ? [self.goodsDetail.sku.stock integerValue]:200;// 如果未选择出一条sku，就默认库存200
                footer.limit_num = self.goodsDetail.sku ? self.goodsDetail.sku.limit_num:0;// 如果未选择出一条sku，就默认0不限购
                footer.buy_num.text = [NSString stringWithFormat:@"%zd",self.goodsDetail.buyNum];
                hx_weakify(self);
                footer.buyNumCall = ^(NSInteger num) {
                    hx_strongify(weakSelf);
                    strongSelf.goodsDetail.buyNum = num;
                };
                return footer;
            }else if (indexPath.section == self.goodsDetail.spec.count){
                footer.numView.hidden = YES;
                footer.storeCodeView.hidden = NO;
                footer.shop_code.textColor = UIColorFromRGB(0x1A1A1A);
                footer.shop_code.text = self.goodsDetail.sku.provider_no?[NSString stringWithFormat:@"发货商家：%@",self.goodsDetail.sku.provider_no]:@"";
                return footer;
            }else{
                return nil;
            }
        }else{
            footer.numView.hidden = YES;
            footer.storeCodeView.hidden = NO;
            footer.shop_code.textColor = UIColorFromRGB(0x1A1A1A);
            footer.shop_code.text = self.goodsDetail.sku.provider_no?[NSString stringWithFormat:@"发货商家：%@",self.goodsDetail.sku.provider_no]:@"";
            return footer;
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (indexPath.section <= self.goodsDetail.spec.count-1) {
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
            GXGoodsDetailSubSpec *subSpec = spec.spec_val[indexPath.row];
            return CGSizeMake([subSpec.attr_name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 24, 30);
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
            return CGSizeMake([logisticst.freight_type boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 24, 30);
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.sku.logistic[indexPath.row];
        return CGSizeMake([logisticst.freight_type boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 24, 30);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark -- ORSKUDataFilterDataSource
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return self.goodsDetail.spec.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    GXGoodsDetailSpec *spec = self.goodsDetail.spec[section];
    return spec.attr_ids;
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return self.goodsDetail.enableSkus.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    GXGoodsDetailSku *enableSku = self.goodsDetail.enableSkus[row];
    return [enableSku.spec_attr_ids componentsSeparatedByString:@","];
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    GXGoodsDetailSku *enableSku = self.goodsDetail.enableSkus[row];
    return enableSku;
}
@end
