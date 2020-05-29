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
@property (weak, nonatomic) IBOutlet UILabel *provider_no;
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *shop_address;

@end
@implementation GXClientManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(GXClient *)client
{
    _client = client;
    self.provider_no.text = _client.provider_no;
    self.shop_name.text = _client.shop_name;
    self.phone.text = _client.phone;
    self.shop_address.text = _client.shop_address;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
