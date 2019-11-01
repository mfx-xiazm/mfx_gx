//
//  GXMarketTrendCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMarketTrendCell.h"
#import "GXMarketTrend.h"

@interface GXMarketTrendCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *sku_name;
@end
@implementation GXMarketTrendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GXSeriesGoods *)goods
{
    _goods = goods;
    self.name.text = _goods.goods_name;
    self.price.text = _goods.price;
    self.sku_name.text = _goods.specs_attrs;
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (self.trendBtnCall) {
        self.trendBtnCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
