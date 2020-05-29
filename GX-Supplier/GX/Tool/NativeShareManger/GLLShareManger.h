//
//  GLLShareManger.h
//  KYPX
//
//  Created by hxrc on 2018/5/10.
//  Copyright © 2018年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLLShareManger : NSObject
+ (instancetype)sharedInstance;
-(void)awakeNativeShareWithImageUrls:(NSArray *)imageUrls targetController:(id)target completedHandler:(UIActivityViewControllerCompletionWithItemsHandler)completedHandler;
@end
