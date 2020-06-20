//
//  GXGoodsMaterialCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsMaterialCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "GXGoodsMaterialLayout.h"

@interface GXGoodsMaterialCell ()
/** 昵称 */
@property (nonatomic , strong) YYLabel *nickName;
/** 文本内容 */
@property (nonatomic , strong) YYLabel *textContent;
/** 展开/收起 */
@property (nonatomic , strong) UIButton *moreLessBtn;
/** 九宫格 */
@property (nonatomic , strong) SDWeiXinPhotoContainerView *picContainerView;
/** 查看商品 */
@property (nonatomic , strong) UIButton *lookGoods;
/** 分享 */
@property (nonatomic , strong) UIButton *share;
/** 分享热度 */
@property (nonatomic , strong) UILabel *shareNum;
/** 分割线 */
@property (nonatomic , strong) UIView *dividingLine;
@end
@implementation GXGoodsMaterialCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsMaterialCell";
    GXGoodsMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        [self setUpSubViews];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 创建子控制器
- (void)setUpSubViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.textContent];
    [self.contentView addSubview:self.moreLessBtn];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.shareNum];
    [self.contentView addSubview:self.lookGoods];
    [self.contentView addSubview:self.share];
    [self.contentView addSubview:self.dividingLine];
}
-(YYLabel *)nickName
{
    if (!_nickName) {
        _nickName = [YYLabel new];
        _nickName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _nickName.textColor = UIColorFromRGB(0x222222);
        _nickName.userInteractionEnabled = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nickNameClicked)];
        //[_nickName addGestureRecognizer:tapGR];
    }
    return _nickName;
}
-(YYLabel *)textContent
{
    if (!_textContent) {
        _textContent = [YYLabel new];
    }
    return _textContent;
}
-(UIButton *)moreLessBtn
{
    if (!_moreLessBtn) {
        _moreLessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreLessBtn setTitleColor:UIColorFromRGB(0xff0000) forState:UIControlStateNormal];
        _moreLessBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _moreLessBtn.hidden = YES;
        [_moreLessBtn addTarget:self action:@selector(moreLessClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreLessBtn;
}
-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}
-(UILabel *)shareNum
{
    if (!_shareNum) {
        _shareNum = [UILabel new];
        _shareNum.font = [UIFont systemFontOfSize:12];
        _shareNum.textColor = HXControlBg;
    }
    return _shareNum;
}
-(UIButton *)lookGoods
{
    if (!_lookGoods) {
        _lookGoods = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookGoods setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [_lookGoods setTitle:@"查看商品" forState:UIControlStateNormal];
        _lookGoods.titleLabel.font = [UIFont systemFontOfSize:12];
        _lookGoods.layer.cornerRadius = 15.f;
        _lookGoods.layer.masksToBounds = YES;
        _lookGoods.layer.borderWidth = 1;
        _lookGoods.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
        [_lookGoods addTarget:self action:@selector(lookGoodsClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookGoods;
}
-(UIButton *)share
{
    if (!_share) {
        _share = [UIButton buttonWithType:UIButtonTypeCustom];
        [_share setTitleColor:HXControlBg forState:UIControlStateNormal];
        [_share setTitle:@"一键分享" forState:UIControlStateNormal];
        _share.titleLabel.font = [UIFont systemFontOfSize:12];
        _share.layer.cornerRadius = 15.f;
        _share.layer.masksToBounds = YES;
        _share.layer.borderWidth = 1;
        _share.layer.borderColor = HXControlBg.CGColor;
        [_share addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _share;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _dividingLine;
}
#pragma mark - Setter
-(void)setMaterialLayout:(GXGoodsMaterialLayout *)materialLayout
{
    _materialLayout = materialLayout;
    
    UIView * lastView;
    GXGoodsMaterial *material = _materialLayout.material;
    
    /*
     #define kMomentTopPadding 15 // 顶部间隙
     #define kMomentMarginPadding 10 // 内容间隙
     #define kMomentPortraitWidthAndHeight 45 // 头像高度
     #define kMomentLineSpacing 5 // 文本行间距
     #define kMomentHandleButtonHeight 30 // 可操作的按钮高度
     */
   
    //昵称
    _nickName.text = material.nick;
    _nickName.hxn_y = kMomentTopPadding;
    _nickName.hxn_x = kMomentMarginPadding;
    CGSize nameSize = [_nickName sizeThatFits:CGSizeZero];
    _nickName.hxn_width = nameSize.width;
    _nickName.hxn_height = kMomentHandleButtonHeight;
    
    //文本内容
    _textContent.hxn_x = kMomentMarginPadding;
    _textContent.hxn_y = _nickName.hxn_bottom + kMomentMarginPadding;
    _textContent.hxn_width = HX_SCREEN_WIDTH - kMomentMarginPadding * 2;
    _textContent.hxn_height = _materialLayout.textLayout.textBoundingSize.height;
    _textContent.textLayout = _materialLayout.textLayout;
    lastView = _textContent;
    
    //展开/收起按钮
    _moreLessBtn.hxn_x = kMomentMarginPadding;
    _moreLessBtn.hxn_y = _textContent.hxn_bottom + kMomentLineSpacing;
    _moreLessBtn.hxn_width = 80;
    _moreLessBtn.hxn_height = kMomentHandleButtonHeight;
    if (material.shouldShowMoreButton) {
        _moreLessBtn.hidden = NO;
        if (material.isOpening) {
            [_moreLessBtn setTitle:@"收起全文" forState:UIControlStateNormal];
        }else{
            [_moreLessBtn setTitle:@"展开全文" forState:UIControlStateNormal];
        }
        lastView = _moreLessBtn;
    }else{
        _moreLessBtn.hidden = YES;
    }
    
    //图片集
    if (material.photos.count != 0) {
        _picContainerView.hidden = NO;
        _picContainerView.hxn_x = kMomentMarginPadding;
        _picContainerView.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
        _picContainerView.hxn_width = _materialLayout.photoContainerSize.width;
        _picContainerView.hxn_height = _materialLayout.photoContainerSize.height;
        _picContainerView.targetVc = self.targetVc;
        _picContainerView.picPathStringsArray = material.photos;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
    
    // 分享热度
    if (material.shareNum && material.shareNum.length) {
        _shareNum.text = [NSString stringWithFormat:@"分享热度 %@",material.shareNum];
        _shareNum.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;;
        _shareNum.hxn_x = kMomentMarginPadding;
        CGSize shareNumSize = [_shareNum sizeThatFits:CGSizeZero];
        _shareNum.hxn_width = shareNumSize.width;
        _shareNum.hxn_height = kMomentHandleButtonHeight;
    }
    
    //点赞
    _share.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
    _share.hxn_x = HX_SCREEN_WIDTH - 70 - 10;
    _share.hxn_width = 70;
    _share.hxn_height = kMomentHandleButtonHeight;
    
    //评论
    if (material.goods_id && material.goods_id.length) {
        _lookGoods.hidden = NO;
        _lookGoods.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
        _lookGoods.hxn_x = HX_SCREEN_WIDTH - 70*2 - 10*2;
        _lookGoods.hxn_width = 70;
        _lookGoods.hxn_height = kMomentHandleButtonHeight;
    }else{
        _lookGoods.hidden = YES;
    }
    
    //分割线
    _dividingLine.hxn_x = 0;
    _dividingLine.hxn_height = .5;
    _dividingLine.hxn_width = HX_SCREEN_WIDTH;
    _dividingLine.hxn_bottom = _materialLayout.height - .5;
}
#pragma mark - 事件处理
- (void)moreLessClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickMoreLessInCell:)]) {
        [self.delegate didClickMoreLessInCell:self];
    }
}
- (void)lookGoodsClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickGoodsInCell:)]) {
        [self.delegate didClickGoodsInCell:self];
    }
}
- (void)shareClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickShareInCell:)]) {
        [self.delegate didClickShareInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
