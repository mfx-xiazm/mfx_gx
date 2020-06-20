//
//  GXRegionalHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRegionalHeader.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GXHomePushCell.h"
#import "GXRegional.h"
#import "GXRegionNoticeCell.h"
#import <GYRollingNoticeView.h>

@interface GXRegionalHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *scrollTextView;
@property (nonatomic,strong) GYRollingNoticeView *roolNoticeView;
@end
@implementation GXRegionalHeader

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
    pageControl.pageIndicatorImage = HXGetImage(@"灰色渐进器");
    pageControl.currentPageIndicatorImage = HXGetImage(@"当前渐进器");
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
    
    
    GYRollingNoticeView *noticeView = [[GYRollingNoticeView alloc]initWithFrame:self.scrollTextView.bounds];
    noticeView.dataSource = self;
    noticeView.delegate = self;
    [noticeView registerNib:[UINib nibWithNibName:@"GXRegionNoticeCell" bundle:nil] forCellReuseIdentifier:@"TopNoticeCell"];
    self.roolNoticeView = noticeView;
    [self.scrollTextView addSubview:noticeView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    
    self.roolNoticeView.frame = self.scrollTextView.bounds;
}
-(void)setRegional:(GXRegional *)regional
{
    _regional = regional;
    
    self.pageControl.numberOfPages = _regional.adv.count;

    [self.cyclePagerView reloadData];
    
    [self.roolNoticeView reloadDataAndStartRoll];
}
- (IBAction)brandDataClicked:(UIButton *)sender {
    if (self.regionalClickedCall) {
        self.regionalClickedCall(3,sender.tag);
    }
}

#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.regional.adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GXHomePushCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    GXRegionalBanner *regionalBanner = self.regional.adv[index];
    cell.regionalBanner = regionalBanner;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
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
    if (self.regionalClickedCall) {
        self.regionalClickedCall(1,index);
    }
}
#pragma mark -- GYRollingNoticeView数据源和代理
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return self.regional.notice.count;
}
- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    GXRegionNoticeCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"TopNoticeCell"];
    GXRegionalNotice *notice = self.regional.notice[index];
    cell.notice = notice;
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    if (self.regionalClickedCall) {
        self.regionalClickedCall(2,index);
    }
}
@end
