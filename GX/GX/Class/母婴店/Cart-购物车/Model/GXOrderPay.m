//
//  GXOrderPay.m
//  GX
//
//  Created by 夏增明 on 2019/11/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXOrderPay.h"
#import "NSDate+HXNExtension.h"

@implementation GXOrderPay
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"account_data":[GXPayAccount class]};
}
-(void)setCreate_time:(NSString *)create_time
{
    _create_time = create_time;
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
       dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *expireDate = [dateFomatter dateFromString:_create_time];

    _countDown =  [self getCurrentCountDown:[NSDate date] formDate:[expireDate dateByAddingMinutes:30]];
}
-(NSInteger)getCurrentCountDown:(NSDate *)nowDate formDate:(NSDate *)endDate
{
    // 当前日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 对比时间差
//    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
//    HXLog(@"年差额 =%zd , 月差额 =%zd , 日差额 =%zd , 小时差额 =%zd , 分钟差额 =%zd , 秒差额 =%zd ",dateCom.year,dateCom.month,dateCom.day,dateCom.hour,dateCom.minute,dateCom.second);
    NSComparisonResult result = [nowDate compare:endDate];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            return [endDate timeIntervalSinceDate:nowDate];
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

@implementation GXPayAccount


@end
