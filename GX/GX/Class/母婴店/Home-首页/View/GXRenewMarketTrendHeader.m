//
//  GXRenewMarketTrendHeader.m
//  GX
//
//  Created by huaxin-01 on 2020/6/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "GXRenewMarketTrendHeader.h"
#import "GXMarketTrend.h"

@interface GXRenewMarketTrendHeader()

@end

@implementation GXRenewMarketTrendHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = HXGetImage(@"行情-奶粉");
    self.imageView.clipsToBounds = YES;
    self.imageView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 200.f);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self insertSubview:self.imageView atIndex:0];
    self.imageViewFrame = self.imageView.frame;
}

@end
