//
//  GXActivityBannerHeader.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXActivityBannerHeader.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GXHomePushCell.h"
#import "GXActivityCataInfo.h"

@interface GXActivityBannerHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;

@end
@implementation GXActivityBannerHeader

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
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
}
-(void)setAdv:(NSArray<GXActivityBanner *> *)adv
{
    _adv = adv;
    self.pageControl.numberOfPages = _adv.count;
    [self.cyclePagerView reloadData];
}
-(void)setTryCovers:(NSArray *)tryCovers
{
    _tryCovers = tryCovers;
    self.pageControl.numberOfPages = _tryCovers.count;
    [self.cyclePagerView reloadData];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.adv ? self.adv.count : self.tryCovers.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GXHomePushCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    if (self.adv) {
        GXActivityBanner *activityBanner = self.adv[index];
        cell.activityBanner = activityBanner;
    }else{
        NSString *imgUrl = self.tryCovers[index];
        [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
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
    if (self.activityBannerClicked) {
        self.activityBannerClicked(index);
    }
}

@end
