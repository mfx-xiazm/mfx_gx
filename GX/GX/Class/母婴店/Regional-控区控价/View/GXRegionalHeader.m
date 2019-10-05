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
#import "LMJHorizontalScrollText.h"

@interface GXRegionalHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *scrollTextView;
@property (strong, nonatomic) LMJHorizontalScrollText *scrollText;
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
    //    pageControl.pageIndicatorImage = HXGetImage(@"轮播点灰");
    //    pageControl.currentPageIndicatorImage = HXGetImage(@"轮播点黑");
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = HXControlBg;
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
    
    
    self.scrollText = [[LMJHorizontalScrollText alloc] initWithFrame:self.scrollTextView.bounds];
    self.scrollText.layer.cornerRadius = 2;
    self.scrollText.layer.masksToBounds = YES;
    self.scrollText.backgroundColor    = [UIColor whiteColor];
    self.scrollText.text               = @"《呱选控区控价细则》，门店必看！门店必看，《呱选控区控价细则》！";
    self.scrollText.textColor          = HXControlBg;
    self.scrollText.textFont           = [UIFont systemFontOfSize:13];
    self.scrollText.speed              = 0.07;
    //self.scrollText.moveDirection      = LMJTextScrollMoveLeft;
    self.scrollText.moveMode           = LMJTextScrollWandering;
    
    [self.scrollTextView addSubview:self.scrollText];
    [self.scrollText move];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    
    self.scrollText.frame = self.scrollTextView.bounds;
}
- (IBAction)noticeClicked:(UIButton *)sender {
    if (self.regionalClickedCall) {
        self.regionalClickedCall(2,0);
    }
}
- (IBAction)brandDataClicked:(UIButton *)sender {
    if (self.regionalClickedCall) {
        self.regionalClickedCall(3,sender.tag);
    }
}

#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 2;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GXHomePushCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    
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

@end
