//
//  MSUserManager.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "MSUserManager.h"
#import <YYCache.h>
#import <YYModel.h>

//用户信息存储键
#define KUserCacheName @"KBBUserCacheName"
#define KUserModelCache @"KBBUserModelCache"

static MSUserManager *_instance = nil;
static YYCache *_cache = nil;
@implementation MSUserManager
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        _cache = [[YYCache alloc] initWithName:KUserCacheName];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//+(id)copyWithZone:(nullable NSZone *)zone{
//    return _instance;
//}
-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线（用于IM）
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(onKick)
//                                                     name:KNotificationOnKick
//                                                   object:nil];
    }
    return self;
}
#pragma mark ————— 储存用户信息 —————
-(void)saveUserInfo{
    if (self.curUserInfo)
    {
        NSDictionary *dic = [self.curUserInfo yy_modelToJSONObject];
        [_cache setObject:dic forKey:KUserModelCache];
        self.isLogined = YES;
    }
}

#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
    NSDictionary * userDic = (NSDictionary *)[_cache objectForKey:KUserModelCache];
    if (userDic)
    {
        self.curUserInfo = [MSUserInfo yy_modelWithJSON:userDic];
        self.isLogined = YES;
        return YES;
    }
    return NO;
}
#pragma mark ————— 被踢下线 —————
-(void)onKick{
    [self logout:nil];
}
#pragma mark ————— 退出登录 —————
- (void)logout:(void (^)(BOOL, NSString *))completion{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 这里可以做被踢下线通知用户等业务操作
    
    // 在这里可以退出IM
    
    // 清空登录信息
    self.curUserInfo = nil;
    self.isLogined = NO;
    
    //移除登录信息缓存
    [_cache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES,nil);
        }
    }];
}
@end
