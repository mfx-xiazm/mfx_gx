//
//  GXShowMoneyProofVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXShowMoneyProofVC.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GXMyIdeaPhotoCell.h"
#import "GXShowProof.h"
#import <ZLPhotoActionSheet.h>

static NSString *const MyIdeaPhotoCell = @"MyIdeaPhotoCell";
@interface GXShowMoneyProofVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *showProofs;
@end

@implementation GXShowMoneyProofVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"打款凭证"];
    [self setUpCollectionView];
    [self startShimmer];
    [self getShowPpPayImgRequest];
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.photoCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.photoCollectionView.collectionViewLayout = flowLayout;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GXMyIdeaPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:MyIdeaPhotoCell];
}
-(void)getShowPpPayImgRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;//订单id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getUpPayImg" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.showProofs = [NSArray yy_modelArrayWithClass:[GXShowProof class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.photoCollectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showProofs.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXMyIdeaPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdeaPhotoCell forIndexPath:indexPath];
    GXShowProof *proof = self.showProofs[indexPath.row];
    cell.proof = proof;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < self.showProofs.count; i++) {
        GXShowProof *proof = self.showProofs[i];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[ZLPreviewPhotoObj] = [proof.pay_img hasPrefix:@"http"]?[NSURL URLWithString:proof.pay_img]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,proof.pay_img]];
        temp[ZLPreviewPhotoTyp] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
    }
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = [UIColor clearColor];
    /**
     底部工具栏按钮 可交互 状态标题颜色
     */
    actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    actionSheet.sender = self;
    [actionSheet previewPhotos:items index:indexPath.row hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
        
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-10*3.f)/2.0;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
