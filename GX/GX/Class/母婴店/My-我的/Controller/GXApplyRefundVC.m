//
//  GXApplyRefundVC.m
//  GX
//
//  Created by huaxin-01 on 2020/6/16.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXApplyRefundVC.h"
#import "HXPlaceholderTextView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import <ZLPhotoActionSheet.h>
#import <AFNetworking.h>
#import "GXMyIdeaPhotoCell.h"
#import "GXApplyRefundTypeView.h"
#import <zhPopupController.h>
#import "GXApplyRefund.h"

static NSString *const MyIdeaPhotoCell = @"MyIdeaPhotoCell";
@interface GXApplyRefundVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_strc;
@property (weak, nonatomic) IBOutlet UILabel *refund_price;
@property (weak, nonatomic) IBOutlet UILabel *refundNum;
@property (weak, nonatomic) IBOutlet UIView *refundNumView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundContentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *refund_type;
@property (weak, nonatomic) IBOutlet UITextField *goods_type;
@property (weak, nonatomic) IBOutlet UITextField *reasion_type;

/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
/** 是否原图 */
@property (nonatomic, assign) BOOL isOriginal;
/** 是否选择了6张 */
@property (nonatomic, assign) BOOL isSelect6;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *showData;
@property (nonatomic, strong) zhPopupController *typePopVC;

@property (nonatomic, strong) GXApplyRefund *applyRefund;
@end

@implementation GXApplyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"售后退款"];
    self.remark.placeholder = @"请输入退款说明";
    [self setUpCollectionView];
    [self startShimmer];
    [self getRefundReasonRequest];
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.refund_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择售后类型"];
            return NO;
        }
        if (![strongSelf.goods_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择货物状态"];
            return NO;
        }
        if (![strongSelf.reasion_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择退款原因"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitClicked:button];
    }];
}
-(NSMutableArray *)showData
{
    if (_showData == nil) {
        _showData = [NSMutableArray array];
        [_showData addObject:HXGetImage(@"选择照片")];
    }
    return _showData;
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = HXControlBg;
    actionSheet.configuration.bottomViewBgColor = HXControlBg;
    actionSheet.configuration.indexLabelBgColor = HXControlBg;
    // -- optional
    //以下参数为自定义参数，均可不设置，有默认值
    /**
     是否升序排列，预览界面不受该参数影响，默认升序 YES
     */
    actionSheet.configuration.sortAscending = NO;
    /**
     是否允许相册内部拍照 ，设置相册内部显示拍照按钮 默认YES
     */
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    /**
     是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
     */
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    /**
     是否允许滑动选择 默认 YES （预览界面不受该参数影响）
     */
    actionSheet.configuration.allowSlideSelect = YES;
    /**
     编辑图片后是否保存编辑后的图片至相册，默认YES
     */
    actionSheet.configuration.saveNewImageAfterEdit = NO;
    
    /**
     回调时候是否允许框架解析图片，默认YES
     如果选择了大量图片，框架一下解析大量图片会耗费一些内存，开发者此时可置为NO，拿到assets数组后自行解析，该值为NO时，回调的图片数组为nil
     */
    actionSheet.configuration.shouldAnialysisAsset = YES;
    
    /**
     是否允许选择照片 默认YES (为NO只能选择视频)
     */
    actionSheet.configuration.allowSelectImage = YES;
    /**
     是否允许选择视频 默认YES
     */
    actionSheet.configuration.allowSelectVideo = NO;
    /**
     是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认YES （此属性与是否允许选择照片相关联，如果可以允许选择照片那就会展示gif[前提是照片中存在gif]）
     */
    actionSheet.configuration.allowSelectGif = NO;
    /**
     是否允许编辑图片，选择一张时候才允许编辑，默认YES
     */
    actionSheet.configuration.allowEditImage = YES;
    /**
     是否允许录制视频(当useSystemCamera为YES时无效)，默认YES
     */
    actionSheet.configuration.allowRecordVideo = NO;
    /**
     设置照片最大选择数 默认10张
     */
    actionSheet.configuration.maxSelectCount = 6;
    
    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    /**
     已选择的图片数组
     */
    actionSheet.arrSelectedAssets = self.selectedAssets;
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        [self.showData removeAllObjects];
        [self.showData addObjectsFromArray:images];
        if (self.showData.count != 6) {
            [self.showData addObject:HXGetImage(@"选择照片")];
            self.isSelect6 = NO;
        }else{
            self.isSelect6 = YES;
        }
        
        self.selectedAssets = assets.mutableCopy;
        self.isOriginal = isOriginal;
        self.selectedPhotos = images.mutableCopy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photoCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.photoViewHeight.constant = self.photoCollectionView.contentSize.height;
            });
        });
    }];
    return actionSheet;
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
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.photoViewHeight.constant = weakSelf.photoCollectionView.contentSize.height;
    });
}
-(void)getRefundReasonRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getRefundReason" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.applyRefund = [GXApplyRefund yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showGoodsInfo];
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
-(void)showGoodsInfo
{
    self.refundContentViewHeight.constant = 200.f;
    self.refundNumView.hidden = YES;

    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:self.applyRefund.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:(self.applyRefund.goods_name)?self.applyRefund.goods_name:@"" withFont:[UIFont systemFontOfSize:13]];
    self.goods_strc.text = (self.applyRefund.specs_attrs && self.applyRefund.specs_attrs.length)?[NSString stringWithFormat:@" %@ ",self.applyRefund.specs_attrs]:@"";

    self.refundNum.text = self.applyRefund.goods_num;
    self.refund_price.text = [NSString stringWithFormat:@"%.2f",[self.applyRefund.pay_amount floatValue] - [self.applyRefund.order_freight_amount floatValue]];
}
- (IBAction)chooseTypeClicked:(UIButton *)sender {
    GXApplyRefundTypeView *typeView = [GXApplyRefundTypeView loadXibView];
    typeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 400.f);
    if (sender.tag == 1) {
        typeView.typeTitle.text = @"售后类型";
        typeView.showTextField = self.refund_type;
        typeView.dataSource = @[@"我要退款（无需退货）",@"我要退款退货"];
    }else if (sender.tag == 2) {
        typeView.typeTitle.text = @"货物状态";
        typeView.showTextField = self.goods_type;
        typeView.dataSource = @[@"已收到货",@"未收到货"];
    }else{
        typeView.typeTitle.text = @"退款原因";
        typeView.showTextField = self.reasion_type;
        NSMutableArray *datas = [NSMutableArray array];
        for (GXApplyRefundReason *reason in self.applyRefund.orderReason) {
            [datas addObject:reason.set_val2];
        }
        typeView.dataSource = datas;
    }
    hx_weakify(self);
    typeView.selectCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.typePopVC dismiss];
        if (sender.tag == 1) {
            if ([strongSelf.refund_type.text isEqualToString:@"我要退款退货"]) {
                self.refundContentViewHeight.constant = 250.f;
                self.refundNumView.hidden = NO;
            }else{
                self.refundContentViewHeight.constant = 200.f;
                self.refundNumView.hidden = YES;
            }
        }
    };
    self.typePopVC = [[zhPopupController alloc] initWithView:typeView size:typeView.bounds.size];
    self.typePopVC.layoutType = zhPopupLayoutTypeBottom;
    [self.typePopVC show];
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.refundNum.text integerValue] + 1 > [self.applyRefund.goods_num integerValue]) {
            return;
        }
        self.refundNum.text = [NSString stringWithFormat:@"%zd",[self.refundNum.text integerValue] + 1];
    }else{// -
        if ([self.refundNum.text integerValue] - 1 < 1) {
            return;
        }
        self.refundNum.text = [NSString stringWithFormat:@"%zd",[self.refundNum.text integerValue] - 1];
    }
   CGFloat price = [self.applyRefund.pay_amount floatValue] - [self.applyRefund.order_freight_amount floatValue];
   self.refund_price.text = [NSString stringWithFormat:@"%.2f",price/[self.applyRefund.goods_num integerValue]*[self.refundNum.text integerValue]];
}
- (void)submitClicked:(UIButton *)sender {
    hx_weakify(self);
    if (self.showData.count > 1) {
        if (self.isSelect6) {
            [self runUpLoadImages:self.showData completedCall:^(NSMutableArray *result) {
                hx_strongify(weakSelf);
                [strongSelf submitUpPayImgRequest:sender imageUrls:result];
            }];
        }else{
            NSMutableArray *tempImgs = [NSMutableArray arrayWithArray:self.showData];
            [tempImgs removeLastObject];
            [self runUpLoadImages:tempImgs completedCall:^(NSMutableArray *result) {
                hx_strongify(weakSelf);
                [strongSelf submitUpPayImgRequest:sender imageUrls:result];
            }];
        }
    }else{
        [self submitUpPayImgRequest:sender imageUrls:nil];
    }
}
-(void)submitUpPayImgRequest:(UIButton *)btn imageUrls:(NSArray *)imageUrls
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    parameters[@"refund_type"] = [self.refund_type.text isEqualToString:@"我要退款退货"]?@"退货退款":@"仅退款";
    parameters[@"goods_status"] = [self.goods_type.text isEqualToString:@"已收到货"]?@"1":@"2";
    parameters[@"reason"] = self.reasion_type.text;
    parameters[@"refund_goods_num"] = self.refundNum.text;
    parameters[@"refund_amount"] = self.refund_price.text;
    parameters[@"refund_desc"] = [self.remark hasText]?self.remark.text:@"";
    if (imageUrls) {
        parameters[@"img_srcs"] = [imageUrls componentsJoinedByString:@","];//评价图片多个用逗号隔开
    }else{
        parameters[@"img_srcs"] = @"";//评价图片多个用逗号隔开
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"admin/orderRefund" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            if (strongSelf.refundCall) {
                strongSelf.refundCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/**
 *  图片批量上传方法
 */
- (void)runUpLoadImages:(NSArray *)imageArr completedCall:(void(^)(NSMutableArray* result))completedCall{
    // 需要上传的图片数据imageArr
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0;i<imageArr.count;i++) {
        [result addObject:[NSNull null]];
    }
    // 生成一个请求组
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < imageArr.count; i++) {
        dispatch_group_enter(group);
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithImage:imageArr[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                // CBLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                //CBLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    if ([responseObject[@"status"] boolValue]){
                        // 将上传完成返回的图片链接存入数组
                        result[i] = responseObject[@"data"][@"path"];
                    }else{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
                    }
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //HXLog(@"上传完成!");
        if (completedCall) {
            completedCall(result);//将图片链接数组传入
        }
    });
}

/**
 *  生成图片批量上传的上传请求方法
 *
 *  @param image           上传的图片
 *  @param completionBlock 包装成的请求回调
 *
 *  @return 上传请求
 */

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    AFHTTPSessionManager *HTTPmanager = [AFHTTPSessionManager manager];
    //    HTTPmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSMutableURLRequest *request = [HTTPmanager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@admin/uploadFile",HXRC_M_URL]  parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //把本地的图片转换为NSData类型的数据
        NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.png" mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.showData.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GXMyIdeaPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyIdeaPhotoCell forIndexPath:indexPath];
    cell.photoImg.image = self.showData[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
        
    if (self.isSelect6) {
        [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
    }else{
        if (indexPath.row == self.showData.count - 1) {//最后一个
            [[self getPas] showPhotoLibrary];
        }else{
            [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-10*5.f)/4.0;
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
