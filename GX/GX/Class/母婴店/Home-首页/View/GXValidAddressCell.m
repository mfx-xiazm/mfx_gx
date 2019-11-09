//
//  GXValidAddressCell.m
//  GX
//
//  Created by 夏增明 on 2019/10/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXValidAddressCell.h"
#import "GXMyAddress.h"

@interface GXValidAddressCell ()
@property(nonatomic,weak) IBOutlet UILabel *receiver;
@property(nonatomic,weak) IBOutlet UILabel *receiver_phone;
@property(nonatomic,weak) IBOutlet UILabel *address_detail;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
@implementation GXValidAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAddress:(GXMyAddress *)address
{
    _address = address;
    
    self.receiver.text = _address.receiver;
    self.receiver_phone.text  = _address.receiver_phone;
    self.address_detail.text = [NSString stringWithFormat:@"%@%@",_address.area_name,_address.address_detail];
    
    self.selectBtn.selected = _address.isSelected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
