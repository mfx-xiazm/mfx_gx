//
//  XQCarousel.m
//  视频和图片的混合轮播
//
//  Created by xzmwkj on 2018/7/10.
//  Copyright © 2018年 WangShuai. All rights reserved.
//

#import "XQCarousel.h"
#import "XQVideoView.h"

@interface XQCarousel ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *pageControl;
@property (nonatomic, strong) XQVideoView *videoView;

@end

@implementation XQCarousel

+ (instancetype)scrollViewFrame:(CGRect)frame imageStringGroup:(NSArray *)imgArray {
    XQCarousel *carousel = [[self alloc] initWithFrame:frame];
    carousel.contentArray = imgArray;
    return carousel;
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    [self loadUI];
}

- (void)loadUI {
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.contentArray.count, self.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    for (NSInteger index = 0; index < self.contentArray.count; index ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, self.frame.size.height)];
        [img sd_setImageWithURL:[NSURL URLWithString:self.contentArray[index]]];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.userInteractionEnabled = YES;
        img.clipsToBounds = YES;
        /** 测试 **/
        if (index == 0) {
            self.videoView = [XQVideoView videoViewFrame:img.frame videoUrl:self.contentArray[index]];
            self.videoView.videoUrl = self.contentArray[index];
            [self.scrollView addSubview:self.videoView];
        }else {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgtap:)];
            img.tag = index-1;
            [img addGestureRecognizer:tap];
            [self.scrollView addSubview:img];
        }
    }
    
    self.pageControl = [[UILabel alloc]init];
    self.pageControl.frame = CGRectMake(self.hxn_width - 50, self.hxn_height - 30, 40, 20);
    self.pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    self.pageControl.textColor = [UIColor whiteColor];
    self.pageControl.font = [UIFont systemFontOfSize:12];
    self.pageControl.layer.cornerRadius = 10.f;
    self.pageControl.layer.masksToBounds = YES;
    self.pageControl.textAlignment = NSTextAlignmentCenter;
    self.pageControl.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.contentArray.count];
    [self addSubview:self.pageControl];
    
}
-(void)imgtap:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击图片第%zd张",tap.view.tag);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = round(scrollView.contentOffset.x / self.frame.size.width);
    self.pageControl.text = [NSString stringWithFormat:@"%ld/%ld",currentPage+1,self.contentArray.count];

    if (self.videoView.isPlay) {
        if (currentPage == 0) {
            [self.videoView start];
        }else {
            [self.videoView stop];
        }
    }
    
}

@end
