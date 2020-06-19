//
//  GXRefundDetailFooter.m
//  GX
//
//  Created by 夏增明 on 2019/10/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXRefundDetailFooter.h"
#import "GXMyRefund.h"

@interface GXRefundDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@end
@implementation GXRefundDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setRefundDetail:(GXMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.receiver.text = [NSString stringWithFormat:@"%@  %@",_refundDetail.address.receiver,_refundDetail.address.receiver_phone];
    self.receive_address.text = [NSString stringWithFormat:@"%@",_refundDetail.address.receiver_address];
}
@end
