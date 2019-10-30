//
//  GXWebContentVC.h
//  GX
//
//  Created by 夏增明 on 2019/10/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/** 富文本 */
@property (nonatomic,copy) NSString *htmlContent;
/** 标题 */
@property(nonatomic,copy) NSString *navTitle;
/** 是否需要请求 */
@property(nonatomic,assign) BOOL isNeedRequest;
/** 1注册协议 2申请供货 3公告详情*/
@property(nonatomic,assign) NSInteger requestType;
/** 公告id  */
@property(nonatomic,copy) NSString *notice_id;

@end

NS_ASSUME_NONNULL_END
