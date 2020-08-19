//
//  GXEnterPlatVC.m
//  GX
//
//  Created by huaxin-01 on 2020/8/5.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXEnterPlatVC.h"
#import "ZJPickerView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import "WSDatePickerView.h"
#import "GXUnionAuthVC.h"
#import "GXWebContentVC.h"

@interface GXEnterPlatVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 00：企业商户 01：个人工商户02：小微商户 */
@property (weak, nonatomic) IBOutlet UITextField *reg_mer_type;
@property (nonatomic, copy) NSString *reg_mer_code;
/** 法人身份证姓名 */
@property (weak, nonatomic) IBOutlet UITextField *legal_name;
/** 法人身份证号 */
@property (weak, nonatomic) IBOutlet UITextField *legal_idcard_no;
/** 法人手机号 */
@property (weak, nonatomic) IBOutlet UITextField *legal_mobile;
/** 法人邮箱 */
@property (weak, nonatomic) IBOutlet UITextField *legal_email;
/** 法人代表证件开始日期 */
@property (weak, nonatomic) IBOutlet UITextField *legal_card_begindate;
/** 法人代表证件截止日期 */
@property (weak, nonatomic) IBOutlet UITextField *legal_card_deadline;
/** 法人性别  0-未知的性别
1-男性
2-女性
5-女性改（变）为男性    6-男性改（变）为女性    9-未说明的性别*/
@property (weak, nonatomic) IBOutlet UITextField *legal_sex;
@property (nonatomic, copy) NSString *legal_sex_code;
/** 法人职业 0-各类专业、技术人员
1-国家机关、党群组织、企事业单位的负责人
2-办事人员和有关人员
3-商业工作人员
4-服务性工作人员
5-农林牧渔劳动者
6-生产工作、运输工作和部分体力劳动者
7-不便分类的其他劳动者*/
@property (weak, nonatomic) IBOutlet UITextField *legal_occupation;
@property (nonatomic, copy) NSString *legal_occupation_code;
/** 商户营业名称  */
@property (weak, nonatomic) IBOutlet UITextField *shop_name;
/** 开户行行号    所属支行查询接口返回 */
@property (weak, nonatomic) IBOutlet UITextField *bank_no;
/** 开户行支行名称 */
@property (weak, nonatomic) IBOutlet UITextField *bank_branch_name;
/** 开户行帐号 */
@property (weak, nonatomic) IBOutlet UITextField *bank_acct_no;
/** 开户帐号名称   对公账户填写公司名称，需与营业执照名称保持一致
个人账户填写法人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *bank_acct_name;
/** 营业地址 */
@property (weak, nonatomic) IBOutlet UITextField *shop_addr_ext;
/** 社会信用统一代码/营业执照号 */
@property (weak, nonatomic) IBOutlet UITextField *shop_lic;
/** 营业执照类型
 '0:多合一营业执照（（三证合一后的营业执照号，18位）
1:普通营业执照（15位）
2:无营业执照'; */
@property (weak, nonatomic) IBOutlet UITextField *license_type;
@property (nonatomic, copy) NSString *license_type_code;
/** 账户类型
 '0:个人账户  1:公司账户'*/
@property (weak, nonatomic) IBOutlet UITextField *bank_acct_type;
@property (nonatomic, copy) NSString *bank_acct_code;
/** 行业类别编码 */
@property (weak, nonatomic) IBOutlet UITextField *mccCode;
@property (nonatomic, copy) NSString *mccCode_id;
@property (nonatomic, strong) NSArray *mccCodeArr;
@property (nonatomic, strong) NSArray *mccCodeTxtArr;
/** 营业执照开始日期 */
@property (weak, nonatomic) IBOutlet UITextField *license_begindate;
/** 营业执照结束日期 */
@property (weak, nonatomic) IBOutlet UITextField *license_deadline;
/** 注册地址 */
@property (weak, nonatomic) IBOutlet UITextField *registerAddress;
/** 身份证正面照 */
@property (weak, nonatomic) IBOutlet UIImageView *card_front_img;
@property (nonatomic, strong) NSMutableDictionary *card_front_img_dict;
/** 身份证反面照 */
@property (weak, nonatomic) IBOutlet UIImageView *card_back_img;
@property (nonatomic, strong) NSMutableDictionary *card_back_img_dict;
/** 商户营业执照 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_zhizhao_img;
@property (nonatomic, strong) NSMutableDictionary *shop_zhizhao_img_dict;
/** 门头照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_mentou_img;
@property (nonatomic, strong) NSMutableDictionary *shop_mentou_img_dict;
/** 手持身份证 */
@property (weak, nonatomic) IBOutlet UIImageView *card_auth_img;
@property (nonatomic, strong) NSMutableDictionary *card_auth_img_dict;
/** 商户室内照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_shinei_img;
@property (nonatomic, strong) NSMutableDictionary *shop_shinei_img_dict;
/** 租赁协议照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_zulin_img;
@property (nonatomic, strong) NSMutableDictionary *shop_zulin_img_dict;
/** 产权照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_chanquan_img;
@property (nonatomic, strong) NSMutableDictionary *shop_chanquan_img_dict;
/** 资质照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_zizhi_img;
@property (nonatomic, strong) NSMutableDictionary *shop_zizhi_img_dict;
/** 商品照片 */
@property (weak, nonatomic) IBOutlet UIImageView *shop_goods_img;
@property (nonatomic, strong) NSMutableDictionary *shop_goods_img_dict;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/** 选中的那个要上传图片 */
@property (nonatomic, strong) UIButton *selectImageBtn;
@end

@implementation GXEnterPlatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"银联数据库留档"];
 
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.reg_mer_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择注册类型"];
            return NO;
        }
        if (![strongSelf.legal_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人身份证姓名"];
            return NO;
        }
        if (![strongSelf.legal_idcard_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人身份证号"];
            return NO;
        }
        if (![strongSelf.legal_mobile hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人手机号"];
            return NO;
        }
        if (![strongSelf.legal_email hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入法人邮箱"];
            return NO;
        }
        if (![strongSelf.legal_card_begindate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择法人代表证件开始日期"];
            return NO;
        }
        if (![strongSelf.legal_card_deadline hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择法人代表证件截止日期"];
            return NO;
        }
        if (![strongSelf.legal_sex hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择法人性别"];
            return NO;
        }
        if (![strongSelf.legal_occupation hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择法人职业"];
            return NO;
        }
        if (![strongSelf.shop_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入商户营业名称"];
            return NO;
        }
        if (![strongSelf.bank_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行行号"];
            return NO;
        }
        if (![strongSelf.bank_branch_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行支行名称"];
            return NO;
        }
        if (![strongSelf.bank_acct_no hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户行帐号"];
            return NO;
        }
        if (![strongSelf.bank_acct_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入开户帐号名称"];
            return NO;
        }
        if (![strongSelf.shop_addr_ext hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入营业地址详细信息"];
            return NO;
        }
        if (![strongSelf.shop_lic hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入社会信用统一代码/营业执照号"];
            return NO;
        }
        if (![strongSelf.license_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择营业执照类型"];
             return NO;
         }
        if (![strongSelf.bank_acct_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择账户类型"];
            return NO;
        }
        if (![strongSelf.mccCode hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择行业类别编码"];
            return NO;
        }
        if (![strongSelf.license_begindate hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择营业执照开始日期"];
            return NO;
        }
        if (![strongSelf.license_deadline hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择营业执照结束日期"];
            return NO;
        }
        if (![strongSelf.registerAddress hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入注册地址"];
            return NO;
        }
        if (!strongSelf.card_front_img_dict) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证正面照"];
            return NO;
        }
        if (!strongSelf.card_back_img_dict) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证反面照"];
            return NO;
        }
        if (!strongSelf.shop_zhizhao_img_dict) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传商户营业执照"];
            return NO;
        }
        if (!strongSelf.shop_mentou_img_dict) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传门头照片"];
            return NO;
        }
        if (!strongSelf.card_auth_img_dict) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传手持身份证正面照"];
            return NO;
        }
        if ([self.reg_mer_code isEqualToString:@"02"]) {// 小微商户
            if (!strongSelf.shop_zulin_img_dict && !strongSelf.shop_chanquan_img_dict && !strongSelf.shop_zizhi_img_dict) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"小微商户选填照片至少要上传一种类型"];
                return NO;
            }
            if (!strongSelf.shop_goods_img_dict) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传经营商品照片"];
                return NO;
            }
        }else{
            if (!strongSelf.shop_shinei_img_dict) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传室内照片"];
                return NO;
            }
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf setSignDataRequest:@"2" submitBtn:button];
    }];
}
// 1非小微 2小微
-(void)getMccCodeRequest:(NSString *)seaType
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/getMccCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.mccCodeArr = [NSArray arrayWithArray:responseObject[@"data"]];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *temp in strongSelf.mccCodeArr) {
                [tempArr addObject:temp[@"name"]];
            }
            strongSelf.mccCodeTxtArr = [NSArray arrayWithArray:tempArr];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)setSignDataRequest:(NSString *)seaType submitBtn:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    /** 00：企业商户 01：个人工商户02：小微商户 */
    parameters[@"reg_mer_type"] = self.reg_mer_code;
    /** 法人身份证姓名 */
    parameters[@"legal_name"] = self.legal_name.text;
    /** 法人身份证号 */
    parameters[@"legal_idcard_no"] = self.legal_idcard_no.text;
    /** 法人手机号 */
    parameters[@"legal_mobile"] = self.legal_mobile.text;
    /** 法人邮箱 */
    parameters[@"legal_email"] = self.legal_email.text;
    /** 法人代表证件开始日期 */
    parameters[@"legal_card_begindate"] = self.legal_card_begindate.text;
    /** 法人代表证件截止日期 */
    parameters[@"legal_card_deadline"] = self.legal_card_deadline.text;
    /** 法人性别 */
    parameters[@"legal_sex"] = self.legal_sex_code;
    /** 法人职业 */
    parameters[@"legal_occupation"] = self.legal_occupation_code;
    /** 商户营业名称  */
    parameters[@"shop_name"] = self.shop_name.text;
    /** 开户行行号    所属支行查询接口返回 */
    parameters[@"bank_no"] = self.bank_no.text;
    /** 开户行支行名称 */
    parameters[@"bank_branch_name"] = self.bank_branch_name.text;
    /** 开户行帐号 */
    parameters[@"bank_acct_no"] = self.bank_acct_no.text;
    /** 开户帐号名称   对公账户填写公司名称，需与营业执照名称保持一致
    个人账户填写法人姓名 */
    parameters[@"bank_acct_name"] = self.bank_acct_name.text;
    /** 营业地址 */
    parameters[@"shop_addr_ext"] = self.shop_addr_ext.text;
    /** 社会信用统一代码/营业执照号 */
    parameters[@"shop_lic"] = self.shop_lic.text;
    /** 营业执照类型; */
    parameters[@"license_type"] = self.license_type_code;
    /** 账户类型 '0:个人账户  1:公司账户'*/
    parameters[@"bank_acct_type"] = self.bank_acct_code;
    /** 行业类别编码 */
    parameters[@"mccCode"] = self.mccCode_id;
    /** 营业执照开始日期 */
    parameters[@"license_begindate"] = self.license_begindate.text;
    /** 营业执照结束日期 */
    parameters[@"license_deadline"] = self.license_deadline.text;
    /** 注册地址 */
    parameters[@"registerAddress"] = self.registerAddress.text;
    
    /** 图片参数组装 */
    NSMutableArray *document_type = [NSMutableArray array];
    NSMutableArray *document_name = [NSMutableArray array];
    NSMutableArray *file_size = [NSMutableArray array];
    NSMutableArray *file_path = [NSMutableArray array];
    if (self.card_front_img_dict) {// 0001    法人身份证
        [document_type addObject:self.card_front_img_dict[@"document_type"]];
        [document_name addObject:self.card_front_img_dict[@"document_name"]];
        [file_size addObject:self.card_front_img_dict[@"file_size"]];
        [file_path addObject:self.card_front_img_dict[@"file_path"]];
    }
    if (self.card_back_img_dict) {// 0011    身份证反面
        [document_type addObject:self.card_back_img_dict[@"document_type"]];
        [document_name addObject:self.card_back_img_dict[@"document_name"]];
        [file_size addObject:self.card_back_img_dict[@"file_size"]];
        [file_path addObject:self.card_back_img_dict[@"file_path"]];
    }
    if (self.shop_zhizhao_img_dict) {// 0002    商户营业执照（个人商户或企业商户必传）
        [document_type addObject:self.shop_zhizhao_img_dict[@"document_type"]];
        [document_name addObject:self.shop_zhizhao_img_dict[@"document_name"]];
        [file_size addObject:self.shop_zhizhao_img_dict[@"file_size"]];
        [file_path addObject:self.shop_zhizhao_img_dict[@"file_path"]];
    }
    if (self.shop_mentou_img_dict) {// 0005    门头照片
        [document_type addObject:self.shop_mentou_img_dict[@"document_type"]];
        [document_name addObject:self.shop_mentou_img_dict[@"document_name"]];
        [file_size addObject:self.shop_mentou_img_dict[@"file_size"]];
        [file_path addObject:self.shop_mentou_img_dict[@"file_path"]];
    }
    if (self.card_auth_img_dict) {// 0007    手持身份证自拍照
        [document_type addObject:self.card_auth_img_dict[@"document_type"]];
        [document_name addObject:self.card_auth_img_dict[@"document_name"]];
        [file_size addObject:self.card_auth_img_dict[@"file_size"]];
        [file_path addObject:self.card_auth_img_dict[@"file_path"]];
    }
    if (self.shop_shinei_img_dict) {// 0015    室内照片
        [document_type addObject:self.shop_shinei_img_dict[@"document_type"]];
        [document_name addObject:self.shop_shinei_img_dict[@"document_name"]];
        [file_size addObject:self.shop_shinei_img_dict[@"file_size"]];
        [file_path addObject:self.shop_shinei_img_dict[@"file_path"]];
    }
    if (self.shop_zulin_img_dict) {// 0016   租赁协议
        [document_type addObject:self.shop_zulin_img_dict[@"document_type"]];
        [document_name addObject:self.shop_zulin_img_dict[@"document_name"]];
        [file_size addObject:self.shop_zulin_img_dict[@"file_size"]];
        [file_path addObject:self.shop_zulin_img_dict[@"file_path"]];
    }
    if (self.shop_chanquan_img_dict) {// 0017   产权证明
        [document_type addObject:self.shop_chanquan_img_dict[@"document_type"]];
        [document_name addObject:self.shop_chanquan_img_dict[@"document_name"]];
        [file_size addObject:self.shop_chanquan_img_dict[@"file_size"]];
        [file_path addObject:self.shop_chanquan_img_dict[@"file_path"]];
    }
    if (self.shop_zizhi_img_dict) {// 0018  执业资质证照
        [document_type addObject:self.shop_zizhi_img_dict[@"document_type"]];
        [document_name addObject:self.shop_zizhi_img_dict[@"document_name"]];
        [file_size addObject:self.shop_zizhi_img_dict[@"file_size"]];
        [file_path addObject:self.shop_zizhi_img_dict[@"file_path"]];
    }
    if (self.shop_goods_img_dict) {// 0021 经营商品照片(小微商户必传)
        [document_type addObject:self.shop_goods_img_dict[@"document_type"]];
        [document_name addObject:self.shop_goods_img_dict[@"document_name"]];
        [file_size addObject:self.shop_goods_img_dict[@"file_size"]];
        [file_path addObject:self.shop_goods_img_dict[@"file_path"]];
    }
    parameters[@"document_type"] = document_type;
    parameters[@"document_name"] = document_name;
    parameters[@"file_size"] = file_size;
    parameters[@"file_path"] = file_path;
    parameters[@"uid"] = self.uid;
    parameters[@"token"] = self.token;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([strongSelf.reg_mer_code isEqualToString:@"02"]) {//小微商户
            if([[responseObject objectForKey:@"res_code"] isEqualToString:@"0000"]) {
                [strongSelf getSignWebDataRequest:@"6" ums_reg_id:[NSString stringWithFormat:@"%@",responseObject[@"ums_reg_id"]] submitBtn:btn];
            }else{
                [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"res_msg"]];
            }
        }else{
            [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
            if([[responseObject objectForKey:@"res_code"] isEqualToString:@"1057"]) {
                GXUnionAuthVC *uvc = [GXUnionAuthVC new];
                uvc.uid = strongSelf.uid;
                uvc.token = strongSelf.token;
                uvc.ums_reg_id = [NSString stringWithFormat:@"%@",responseObject[@"ums_reg_id"]];
                uvc.company_account = strongSelf.bank_acct_no.text;
                [strongSelf.navigationController pushViewController:uvc animated:YES];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"res_msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getSignWebDataRequest:(NSString *)seaType ums_reg_id:(NSString *)ums_reg_id submitBtn:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    parameters[@"ums_reg_id"] = ums_reg_id;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            GXWebContentVC *wvc = [GXWebContentVC new];
            wvc.isNeedRequest = NO;
            wvc.url = responseObject[@"data"];
            [strongSelf.navigationController pushViewController:wvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)chooseTypeClicked:(UIButton *)sender {
    NSArray *dataArr = nil;
    if (sender.tag == 1) {
        dataArr = @[@"企业商户", @"个人工商户", @"小微商户"];
    }else if (sender.tag == 2) {
        dataArr = @[@"未知", @"男", @"女"];
    }else if (sender.tag == 3) {
        dataArr = @[@"各类专业、技术人员", @"国家机关、党群组织、企事业单位的负责人", @"办事人员和有关人员", @"商业工作人员", @"服务性工作人员", @"农林牧渔劳动者", @"生产工作、运输工作和部分体力劳动者", @"不便分类的其他劳动者"];
    }else if (sender.tag == 4) {
        dataArr = @[@"多合一营业执照", @"普通营业执照", @"无营业执照"];
    }else if (sender.tag == 5) {
        dataArr = @[@"个人账户", @"公司账户"];
    }else{
        if (![self.reg_mer_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择注册类型"];
            return;
        }
        dataArr = self.mccCodeTxtArr;
    }
    if (!dataArr.count) {
        return;
    }
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
        ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
        ZJPickerViewPropertySureBtnTitleKey  : @"确定",
        ZJPickerViewPropertyTipLabelTextKey  : @"请选择", // 提示内容
        ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0x999999),
        ZJPickerViewPropertySureBtnTitleColorKey : HXControlBg,
        ZJPickerViewPropertyTipLabelTextColorKey :
            UIColorFromRGB(0x131D2D),
        ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:13.0f],
        ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
        ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
        ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : HXControlBg, NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
        ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
        ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
        ZJPickerViewPropertyIsShowSelectContentKey : @YES,
        ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
        ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:dataArr propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
        if (sender.tag == 1) {
            strongSelf.reg_mer_type.text = results.firstObject;
            strongSelf.reg_mer_code = [NSString stringWithFormat:@"%02ld",(long)[results.lastObject integerValue]];
            if ([results.lastObject integerValue] == 2) {
                [strongSelf getMccCodeRequest:@"2"];
            }else{
                [strongSelf getMccCodeRequest:@"1"];
            }
        }else if (sender.tag == 2) {
            strongSelf.legal_sex.text = results.firstObject;
            strongSelf.legal_sex_code = results.lastObject;
        }else if (sender.tag == 3) {
            strongSelf.legal_occupation.text = results.firstObject;
            strongSelf.legal_occupation_code = results.lastObject;
        }else if (sender.tag == 4) {
            strongSelf.license_type.text = results.firstObject;
            strongSelf.license_type_code = results.lastObject;
        }else if (sender.tag == 5) {
            strongSelf.bank_acct_type.text = results.firstObject;
            strongSelf.bank_acct_code = results.lastObject;
        }else{
            strongSelf.mccCode.text = results.firstObject;
            NSDictionary *temp = strongSelf.mccCodeArr[[results.lastObject integerValue]];
            strongSelf.mccCode_id = [NSString stringWithFormat:@"%@",temp[@"mccCode_id"]];
        }
    }];
}

- (IBAction)chooseTimeClicked:(UIButton *)sender {
    NSDate *scrollToDate = nil;
    if (sender.tag == 1) {
        if ([self.legal_card_begindate hasText]) {
            scrollToDate = [NSDate date:self.legal_card_begindate.text WithFormat:@"yyyy-MM-dd"];
        }else{
            scrollToDate = [NSDate date];
        }
    }else if (sender.tag == 2){
        if ([self.legal_card_deadline hasText]) {
            scrollToDate = [NSDate date:self.legal_card_deadline.text WithFormat:@"yyyy-MM-dd"];
        }else{
            scrollToDate = [NSDate date];
        }
    }else if (sender.tag == 3){
        if ([self.license_begindate hasText]) {
            scrollToDate = [NSDate date:self.license_begindate.text WithFormat:@"yyyy-MM-dd"];
        }else{
            scrollToDate = [NSDate date];
        }
    }else{
        if ([self.license_deadline hasText]) {
            scrollToDate = [NSDate date:self.license_deadline.text WithFormat:@"yyyy-MM-dd"];
        }else{
            scrollToDate = [NSDate date];
        }
    }
    
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
        hx_strongify(weakSelf);
        NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
        NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:selectDate];
        NSDate *newDate = [selectDate dateByAddingTimeInterval:timeOffset];
        NSString *date = [newDate stringWithFormat:@"yyyy-MM-dd"];
        if (sender.tag == 1) {
            strongSelf.legal_card_begindate.text = date;
        }else if (sender.tag == 2){
            strongSelf.legal_card_deadline.text = date;
        }else if (sender.tag == 3){
            strongSelf.license_begindate.text = date;
        }else{
            strongSelf.license_deadline.text = date;
        }
    }];
    if (sender.tag == 1) {
        if ([self.legal_card_deadline hasText]) {
            datepicker.maxLimitDate = [NSDate date:self.legal_card_deadline.text WithFormat:@"yyyy-MM-dd"];
        }else{
            datepicker.maxLimitDate = [NSDate date];
        }
    }else if (sender.tag == 2){
        if ([self.legal_card_begindate hasText]) {
            datepicker.minLimitDate = [NSDate date:self.legal_card_begindate.text WithFormat:@"yyyy-MM-dd"];
        }else{
            datepicker.minLimitDate = [NSDate date];
        }
    }else if (sender.tag == 3){
        if ([self.license_deadline hasText]) {
            datepicker.maxLimitDate = [NSDate date:self.license_deadline.text WithFormat:@"yyyy-MM-dd"];
        }else{
            datepicker.maxLimitDate = [NSDate date];
        }
    }else{
        if ([self.license_begindate hasText]) {
            datepicker.minLimitDate = [NSDate date:self.license_begindate.text WithFormat:@"yyyy-MM-dd"];
        }else{
            datepicker.minLimitDate = [NSDate date];
        }
    }
    [datepicker show];
}

- (IBAction)chooseImgClicked:(UIButton *)sender {
    
    self.selectImageBtn = sender;
    
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                if (@available(iOS 13.0, *)) {
                    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                    /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
                    imagePickerController.modalInPresentation = YES;
                }
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl,NSString * imagePath) {
            [strongSelf getSignDataRequest:@"1" base64:imageUrl completedCall:^(NSDictionary *imageDict) {
                if (strongSelf.selectImageBtn.tag == 1) {// 0001    法人身份证
                    [strongSelf.card_front_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.card_front_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0001",@"document_name":@"法人身份证",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 2) {// 0011    身份证反面
                    [strongSelf.card_back_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.card_back_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0011",@"document_name":@"身份证反面",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 3) {// 0002    商户营业执照（个人商户或企业商户必传）
                    [strongSelf.shop_zhizhao_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_zhizhao_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0002",@"document_name":@"商户营业执照",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 4) {// 0005    门头照片
                    [strongSelf.shop_mentou_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_mentou_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0005",@"document_name":@"门头照片",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 5) {// 0007    手持身份证自拍照
                    [strongSelf.card_auth_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.card_auth_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0007",@"document_name":@"手持身份证自拍照",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 6) {// 0015    室内照片
                    [strongSelf.shop_shinei_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_shinei_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0015",@"document_name":@"室内照片",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 7) {// 0016   租赁协议
                    [strongSelf.shop_zulin_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_zulin_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0016",@"document_name":@"租赁协议",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 8) {// 0017   产权证明
                    [strongSelf.shop_chanquan_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_chanquan_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0017",@"document_name":@"产权证明",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else if (strongSelf.selectImageBtn.tag == 9) {// 0018  执业资质证照
                    [strongSelf.shop_zizhi_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_zizhi_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0018",@"document_name":@"执业资质证照",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }else {// 0021 经营商品照片(小微商户必传)
                    [strongSelf.shop_goods_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                    strongSelf.shop_goods_img_dict = [NSMutableDictionary dictionaryWithDictionary:@{@"document_type":@"0021",@"document_name":@"经营商品照片",@"file_path":imageDict[@"file_path"],@"file_size":imageDict[@"file_size"]}];
                }
            }];
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [MBProgressHUD showLoadToView:nil title:@"图片上传处理.."];
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"index/uploadFile" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completedCall(responseObject[@"data"][@"pic_base64"],responseObject[@"data"][@"imgPath"]);
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/**
 0001    法人身份证
 0011    身份证反面
 0002    商户营业执照（个人商户或企业商户必传）
 0003    商户税务登记证（选传）
 0004    组织机构代码证（选传）
 0005    门头照片
 0006    开户许可证（企业商户选传）
 0007    手持身份证自拍照
 0008    辅助证明材料
 0013    辅助证明材料1
 0014    辅助证明材料2
 (0008,0013,0014; 辅助证明材料系统审核选传)
 0015    室内照片
 0099        其他材料
 0016   租赁协议
 0017   产权证明
 0018  执业资质证照
 0019  第三方证明
 0020 其他小微商户证明材料（0016-0020小微商户必传其一）
 0021 经营商品照片(小微商户必传)
 */
-(void)getSignDataRequest:(NSString *)seaType base64:(NSString *)base64 completedCall:(void(^)(NSDictionary* imageDict))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"seaType"] = seaType;
    parameters[@"pic_base64"] = base64;

    [HXNetworkTool POST:HXRC_M_URL action:@"index/signData" parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if([[responseObject objectForKey:@"res_code"] isEqualToString:@"0000"]) {
            completedCall(responseObject);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"res_msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
