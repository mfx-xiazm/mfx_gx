//
//  GXGoodsDetailHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsDetailHeader.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GXHomePushCell.h"
#import "GXGoodsDetail.h"
#import "XTimer.h"

@interface GXGoodsDetailHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *cale_num;
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UILabel *rush_price;
@property (weak, nonatomic) IBOutlet UILabel *rush_market_price;
@property (weak, nonatomic) IBOutlet UILabel *rush_time;
/** 倒计时 */
@property (nonatomic,strong) XTimer *timer;
@end
@implementation GXGoodsDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.cyclePagerView.isInfiniteLoop = YES;
    self.cyclePagerView.autoScrollInterval = 3.0;
    self.cyclePagerView.dataSource = self;
    self.cyclePagerView.delegate = self;
    // registerClass or registerNib
    [self.cyclePagerView registerNib:[UINib nibWithNibName:NSStringFromClass([GXHomePushCell class]) bundle:nil] forCellWithReuseIdentifier:@"TopBannerCell"];
    
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.numberOfPages = 4;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    //    pageControl.pageIndicatorImage = HXGetImage(@"轮播点灰");
    //    pageControl.currentPageIndicatorImage = HXGetImage(@"轮播点黑");
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = HXControlBg;
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
}
-(void)setGoodsDetail:(GXGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    self.pageControl.numberOfPages = _goodsDetail.good_adv.count;
    [self.cyclePagerView reloadData];
    
    [self.shop_name setTextWithLineSpace:5.f withString:_goodsDetail.goods_name withFont:[UIFont systemFontOfSize:15]];
    if ([self.goodsDetail.rushbuy isEqualToString:@"1"]) {//抢购商品
        if ([_goodsDetail.rush.rush_min_price floatValue] == [_goodsDetail.rush.rush_max_price floatValue]) {
            self.rush_price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.rush.rush_min_price];
        }else{
            self.rush_price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goodsDetail.rush.rush_min_price,_goodsDetail.rush.rush_max_price];
        }
        if ([_goodsDetail.min_price floatValue] == [_goodsDetail.max_price floatValue]) {
            self.rush_market_price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.min_price];
        }else{
            self.rush_market_price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goodsDetail.min_price,_goodsDetail.max_price];
        }
        /** 1未开始，2进行中；3已结束；4暂停 */
        if ([_goodsDetail.rush.rushbuy_status isEqualToString:@"1"]) {
            self.rush_time.text = @"未开始";
        }else if ([_goodsDetail.rush.rushbuy_status isEqualToString:@"2"]) {
            [self countTimeDown];
            if (!self.timer) {
                self.timer = [XTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTimeDown) userInfo:nil repeats:YES];
            }
        }else{
            self.rush_time.text = @"已结束";
        }
        self.price.text = @"";
        self.market_price.text = [NSString stringWithFormat:@"建议价：￥%@",_goodsDetail.suggest_price];
    }else{//不抢购商品
        if ([_goodsDetail.control_type isEqualToString:@"1"]) {
            if ([_goodsDetail.min_price floatValue] == [_goodsDetail.max_price floatValue]) {
                self.price.text = [NSString stringWithFormat:@"￥%@",_goodsDetail.min_price];
            }else{
                self.price.text = [NSString stringWithFormat:@"￥%@-￥%@",_goodsDetail.min_price,_goodsDetail.max_price];
            }
            self.market_price.text = [NSString stringWithFormat:@"建议价：￥%@",_goodsDetail.suggest_price];
        }else{
            self.price.text = [NSString stringWithFormat:@"￥%@  ",_goodsDetail.min_price];
            self.market_price.text = @"";
        }
    }
    self.cale_num.text = [NSString stringWithFormat:@"销量：%@",_goodsDetail.sale_num];
    
    self.notice.text = [NSString stringWithFormat:@"重要通知：%@",_goodsDetail.important_notice];
}
-(void)countTimeDown
{
    if (self.goodsDetail.rush.countDown >0) {
        if ((self.goodsDetail.rush.countDown/3600)/24) {
            NSString *str_day = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.rush.countDown/3600)/24];
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.goodsDetail.rush.countDown/3600%24];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.rush.countDown%(60*60))/60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld",self.goodsDetail.rush.countDown%60];
            NSString *format_time = [NSString stringWithFormat:@"%@天%@:%@:%@",str_day,str_hour,str_minute,str_second];
            //设置文字显示 根据自己需求设置
            self.rush_time.text = [NSString stringWithFormat:@"距结束 %@",format_time];
        }else{
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.goodsDetail.rush.countDown/3600%24];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.goodsDetail.rush.countDown%(60*60))/60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld",self.goodsDetail.rush.countDown%60];
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            //设置文字显示 根据自己需求设置
            self.rush_time.text = [NSString stringWithFormat:@"距结束 %@",format_time];
        }
        
        self.goodsDetail.rush.countDown -= 1;
    }else{
        // 移除倒计时，发出通知并刷新页面
        self.goodsDetail.rush.countDown = 0;
        [self.timer invalidate];
        self.timer = nil;
        
        if (self.countDownCall) {
            self.countDownCall();
        }
    }
}
-(void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.goodsDetail.good_adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GXHomePushCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    GXGoodsDetailAdv *adv = self.goodsDetail.good_adv[index];
    cell.adv = adv;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*2/3.0);
    layout.itemSpacing = 0;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.bannerClickedCall) {
        self.bannerClickedCall(index);
    }
}

@end
