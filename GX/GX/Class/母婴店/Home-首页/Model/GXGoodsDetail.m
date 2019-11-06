//
//  GXGoodsDetail.m
//  GX
//
//  Created by 夏增明 on 2019/11/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXGoodsDetail.h"
#import "GXGoodsComment.h"
#import "GXGoodsMaterial.h"

@implementation GXGoodsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"good_adv":[GXGoodsDetailAdv class],
             @"good_param":[GXGoodsDetailParam class],
             @"spec":[GXGoodsDetailSpec class],
             @"material":[GXGoodsMaterial class],
             @"eva":[GXGoodsComment class],
             @"rush":[GXGoodsRush class],
             @"logistics":[GXGoodsLogisticst class],
             };
}

-(NSInteger)buyNum
{
    if (_buyNum>0) {
        return _buyNum;
    }
    return 1;
}

@end

@implementation GXGoodsDetailAdv

@end

@implementation GXGoodsDetailParam

@end

@implementation GXGoodsDetailSpec
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"spec_val":[GXGoodsDetailSubSpec class]
             };
}
@end

@implementation GXGoodsDetailSubSpec

@end

@implementation GXGoodsDetailSku

@end

@implementation GXGoodsLogisticst

@end

@implementation GXGoodsRush
-(void)setEnd_time:(NSString *)end_time
{
    if (!end_time) {
        return;
    }
    _end_time = end_time;
    _countDown =  [self getCurrentCountDown:[NSDate date] formDate:_end_time];
}
-(NSInteger)getCurrentCountDown:(NSDate *)nowDate formDate:(NSString *)endDateStr
{
    // 截止时间字符串格式
    NSString *expireDateStr = endDateStr;
    // 时间戳
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 对比时间差
//    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
//    HXLog(@"年差额 =%zd , 月差额 =%zd , 日差额 =%zd , 小时差额 =%zd , 分钟差额 =%zd , 秒差额 =%zd ",dateCom.year,dateCom.month,dateCom.day,dateCom.hour,dateCom.minute,dateCom.second);
    NSComparisonResult result = [nowDate compare:expireDate];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            return [expireDate timeIntervalSinceDate:nowDate];
            break;
            //date02比date01小
        case NSOrderedDescending:
            return -1;
            break;
            //date02=date01
        case NSOrderedSame:
            return 0;
            break;
        default:
            break;
    }
}
@end


