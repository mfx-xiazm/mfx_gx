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

static NSString *const RunCategoryCell = @"RunCategoryCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";
static NSString *const ChooseClassFooter = @"ChooseClassFooter";

@interface GXChooseClassView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_num;
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
- (IBAction)goodHandleClicked:(UIButton *)sender {
    if (sender.tag) {
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
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"建议价：￥%@",_goodsDetail.suggest_price]];
    
    if (!_goodsDetail.selectLogisticst && _goodsDetail.logistics.count) {
        // 如果未选择就默认第一个
        GXGoodsLogisticst *logisticst = _goodsDetail.logistics.firstObject;
        logisticst.isSelected = YES;
        _goodsDetail.selectLogisticst = logisticst;
    }
    if (_goodsDetail.spec && _goodsDetail.spec.count) {
        if (_goodsDetail.sku) {
            self.price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.sku.price];
            self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.sku.stock];
            [self.collectionView reloadData];
        }else{
            for (GXGoodsDetailSpec *spec in _goodsDetail.spec) {
                if (!spec.selectSpec) {// 如果未选择就默认第一个
                    GXGoodsDetailSubSpec *subSpec = spec.spec_val.firstObject;
                    subSpec.isSelected = YES;
                    spec.selectSpec = subSpec;
                }
            }
            [self getShopStockRequest];
        }
    }else{
        [self.collectionView reloadData];
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
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getSkuDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.goodsDetail.sku = [GXGoodsDetailSku yy_modelWithDictionary:responseObject[@"data"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.price.text = [NSString stringWithFormat:@"￥%@",strongSelf.goodsDetail.sku.price];
                strongSelf.stock_num.text = [NSString stringWithFormat:@"库存：%@",strongSelf.goodsDetail.sku.stock];
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
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
            return self.goodsDetail.logistics.count;
        }
    }else{
        return self.goodsDetail.logistics.count;
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
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
            cell.logisticst = logisticst;
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
        cell.logisticst = logisticst;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (indexPath.section <= self.goodsDetail.spec.count-1) {
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
            spec.selectSpec.isSelected = NO;
            
            GXGoodsDetailSubSpec *subSpec = spec.spec_val[indexPath.item];
            subSpec.isSelected = YES;
            
            spec.selectSpec = subSpec;
            
            [self getShopStockRequest];
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
            self.goodsDetail.selectLogisticst.isSelected = NO;
            
            logisticst.isSelected = YES;
            
            self.goodsDetail.selectLogisticst = logisticst;
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
        self.goodsDetail.selectLogisticst.isSelected = NO;
        
        logisticst.isSelected = YES;
        
        self.goodsDetail.selectLogisticst = logisticst;
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
                header.titleLabel.text = @"快递";
            }
        }else{
            header.titleLabel.text = @"快递";
        }
        return header;
    }else{
        GXChooseClassFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter forIndexPath:indexPath];
        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
            if (indexPath.section == self.goodsDetail.spec.count-1) {
                footer.numView.hidden = NO;
                footer.storeCodeView.hidden = YES;
                footer.stock_num = [self.goodsDetail.sku.stock integerValue];
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
                footer.shop_code.text = [NSString stringWithFormat:@"发货商家：%@",self.goodsDetail.sku.provider_no];
                return footer;
            }else{
                return nil;
            }
        }else{
            footer.numView.hidden = YES;
            footer.storeCodeView.hidden = NO;
            footer.shop_code.text = [NSString stringWithFormat:@"发货商家：%@",self.goodsDetail.sku.provider_no];
            return footer;
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        if (indexPath.section <= self.goodsDetail.spec.count-1) {
            GXGoodsDetailSpec *spec = self.goodsDetail.spec[indexPath.section];
            GXGoodsDetailSubSpec *subSpec = spec.spec_val[indexPath.row];
            return CGSizeMake([subSpec.attr_name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 20, 30);
        }else{
            GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
            return CGSizeMake([logisticst.logistics_com_name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 20, 30);
        }
    }else{
        GXGoodsLogisticst *logisticst = self.goodsDetail.logistics[indexPath.row];
        return CGSizeMake([logisticst.logistics_com_name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 20, 30);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
