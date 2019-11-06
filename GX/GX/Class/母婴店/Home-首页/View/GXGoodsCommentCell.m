//
//  GXGoodsCommentCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsCommentCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "GXGoodsCommentLayout.h"

@interface GXGoodsCommentCell ()
/** 头像 */
@property (nonatomic , strong) UIImageView *avatarView;
/** 昵称 */
@property (nonatomic , strong) YYLabel *nickName;
/** 时间 */
@property (nonatomic , strong) YYLabel *createTime;
/** 文本内容 */
@property (nonatomic , strong) YYLabel *textContent;
/** 展开/收起 */
@property (nonatomic , strong) UIButton *moreLessBtn;
/** 九宫格 */
@property (nonatomic , strong) SDWeiXinPhotoContainerView *picContainerView;
/** 分割线 */
@property (nonatomic , strong) UIView *dividingLine;
@end
@implementation GXGoodsCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodsCommentCell";
    GXGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.createTime];
    [self.contentView addSubview:self.textContent];
    [self.contentView addSubview:self.moreLessBtn];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.dividingLine];
}
-(UIImageView *)avatarView
{
    if(!_avatarView){
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.backgroundColor = HXGlobalBg;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.layer.cornerRadius = 22.5f;
        _avatarView.layer.masksToBounds = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClicked)];
        //[_avatarView addGestureRecognizer:tapGR];
    }
    return _avatarView;
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
-(YYLabel *)createTime
{
    if (!_createTime) {
        _createTime = [[YYLabel alloc] init];
        _createTime.font = [UIFont systemFontOfSize:13.0f];
        _createTime.textAlignment = NSTextAlignmentLeft;
        _createTime.textColor = UIColorFromRGB(0x666666);
    }
    return _createTime;
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
-(void)setCommentLayout:(GXGoodsCommentLayout *)commentLayout
{
    _commentLayout = commentLayout;
    
    UIView * lastView;
    GXGoodsComment *comment = _commentLayout.comment;
    
    /*
     #define kMomentTopPadding 15 // 顶部间隙
     #define kMomentMarginPadding 10 // 内容间隙
     #define kMomentPortraitWidthAndHeight 45 // 头像高度
     #define kMomentLineSpacing 5 // 文本行间距
     #define kMomentHandleButtonHeight 30 // 可操作的按钮高度
     */
    //头像
    _avatarView.hxn_x = kMomentMarginPadding;
    _avatarView.hxn_y = kMomentTopPadding;
    _avatarView.hxn_size = CGSizeMake(kMomentPortraitWidthAndHeight, kMomentPortraitWidthAndHeight);
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:comment.portrait]];
    
    //昵称
    _nickName.text = comment.nick;
    _nickName.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    _nickName.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
    CGSize nameSize = [_nickName sizeThatFits:CGSizeZero];
    _nickName.hxn_width = nameSize.width;
    _nickName.hxn_height = kMomentHandleButtonHeight;
    
    
    //时间
    _createTime.text = comment.creatTime;
    _createTime.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    CGSize timeSize = [_createTime sizeThatFits:CGSizeZero];
    _createTime.hxn_width = timeSize.width;
    _createTime.hxn_x = HX_SCREEN_WIDTH - kMomentMarginPadding - timeSize.width;
    _createTime.hxn_height = kMomentHandleButtonHeight;
    
    //文本内容
    _textContent.hxn_x = kMomentMarginPadding;
    _textContent.hxn_y = _avatarView.hxn_bottom + kMomentMarginPadding;
    _textContent.hxn_width = HX_SCREEN_WIDTH - kMomentMarginPadding * 2;
    _textContent.hxn_height = _commentLayout.textLayout.textBoundingSize.height;
    _textContent.textLayout = _commentLayout.textLayout;
    lastView = _textContent;
    
    //展开/收起按钮
    _moreLessBtn.hxn_x = kMomentMarginPadding;
    _moreLessBtn.hxn_y = _textContent.hxn_bottom + kMomentLineSpacing;
    _moreLessBtn.hxn_width = 80;
    _moreLessBtn.hxn_height = kMomentHandleButtonHeight;
    if (comment.shouldShowMoreButton) {
        _moreLessBtn.hidden = NO;
        if (comment.isOpening) {
            [_moreLessBtn setTitle:@"收起全文" forState:UIControlStateNormal];
        }else{
            [_moreLessBtn setTitle:@"展开全文" forState:UIControlStateNormal];
        }
        lastView = _moreLessBtn;
    }else{
        _moreLessBtn.hidden = YES;
    }
    
    //图片集
    if (comment.photos.count != 0) {
        _picContainerView.hidden = NO;
        _picContainerView.hxn_x = kMomentMarginPadding;
        _picContainerView.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
        _picContainerView.hxn_width = _commentLayout.photoContainerSize.width;
        _picContainerView.hxn_height = _commentLayout.photoContainerSize.height;
        //_picContainerView.target = self.sender;
        _picContainerView.picPathStringsArray = comment.photos;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }

    //分割线
    _dividingLine.hxn_x = 0;
    _dividingLine.hxn_height = .5;
    _dividingLine.hxn_width = HX_SCREEN_WIDTH;
    _dividingLine.hxn_bottom = _commentLayout.height - .5;
}
#pragma mark - 事件处理
- (void)moreLessClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickMoreLessInCommentCell:)]) {
        [self.delegate didClickMoreLessInCommentCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
