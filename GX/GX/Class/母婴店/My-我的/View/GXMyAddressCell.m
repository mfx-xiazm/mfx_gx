//
//  GXMyAddressCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXMyAddressCell.h"
#import "GXMyAddress.h"

@interface GXMyAddressCell ()
@property(nonatomic,weak) IBOutlet UILabel *receiver;
@property(nonatomic,weak) IBOutlet UILabel *receiver_phone;
@property(nonatomic,weak) IBOutlet UILabel *address_detail;
@property(nonatomic,weak) IBOutlet UIButton *is_default;
@end
@implementation GXMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addressClicked:(UIButton *)sender {
    if (self.addressClickedCall) {
        self.addressClickedCall(sender.tag);
    }
}
-(void)setAddress:(GXMyAddress *)address
{
    _address = address;
    self.receiver.text = _address.receiver;
    self.receiver_phone.text  = _address.receiver_phone;
    self.address_detail.text = [NSString stringWithFormat:@"%@%@",_address.area_name,_address.address_detail];
    self.is_default.selected = _address.is_default;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
