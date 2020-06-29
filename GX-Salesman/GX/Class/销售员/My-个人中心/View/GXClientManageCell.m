//
//  GXClientManageCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXClientManageCell.h"
#import "GXClient.h"

@interface GXClientManageCell ()
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
@implementation GXClientManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(GXClient *)client
{
    _client = client;
    self.shop_name.text = _client.shop_name;
    self.phone.text = _client.phone;
    self.create_time.text = _client.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
