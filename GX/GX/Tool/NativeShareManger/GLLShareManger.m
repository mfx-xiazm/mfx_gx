//
//  GLLShareManger.m
//  KYPX
//
//  Created by hxrc on 2018/5/10.
//  Copyright © 2018年 HX. All rights reserved.
//

#import "GLLShareManger.h"
#import "GLLShareItem.h"

static GLLShareManger *_instance = nil;
@implementation GLLShareManger
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
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
-(void)awakeNativeShareWithImageUrls:(NSArray *)imageUrls targetController:(id)target completedHandler:(UIActivityViewControllerCompletionWithItemsHandler)completedHandler
{
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSMutableArray *activityItems = [NSMutableArray array];
    /**
     创建分享视图控制器
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     */
    // 生成一个异步操作组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t my_queue = dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    for (NSInteger i = 0; i<imageUrls.count; i++) {
        dispatch_group_async(group, my_queue, ^{
           //地址转码，取出地址
            NSString *imageUrl = imageUrls[i];
            if (![imageUrl hasPrefix:@"http"]) {
                imageUrl = [NSString stringWithFormat:@"%@%@",HXRC_URL_HEADER,imageUrl];
            }
            [self gllReadImageWithImageUrl:imageUrl completedHandle:^(NSString *imagePath, UIImage *readImg) {
                @synchronized (activityItems) {
                    //把缓存图片的地址转成NSUrl格式
                    NSURL *shareObj = [NSURL fileURLWithPath:imagePath];
                    GLLShareItem *item = [[GLLShareItem alloc] initWithImage:readImg andfile:shareObj];
                    [activityItems addObject:item];
                }
            }];
        });
    };
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:nil];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        //UIActivityViewControllerCompletionWithItemsHandler)(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)  iOS >=8.0
        
        //UIActivityViewControllerCompletionHandler (NSString * __nullable activityType, BOOL completed); iOS 6.0~8.0
        
        //初始化回调方法
        /*
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
            NSLog(@"####activityType :%@####", activityType);
            if (completed) {
                NSLog(@"###completed###");
            } else {
                NSLog(@"###cancel###");
            }
        };
         */
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = completedHandler;
        
        // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
        //关闭系统的一些activity类型
        if (@available(iOS 11.0, *))  {
            activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
        }else{
            activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks];
        }
        if (@available(iOS 13.0, *)) {
            activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
            /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
            activityVC.modalInPresentation = YES;
        }
        //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
        [target presentViewController:activityVC animated:YES completion:nil];
    });
}

/** 读出图片 imageUrl: 图片的链接*/
-(void)gllReadImageWithImageUrl:(NSString *)imageUrl completedHandle:(void(^)(NSString *imagePath,UIImage *readImg))completedHandle{
    NSString *catchsImageStr = [imageUrl lastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/ShareImages/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0],catchsImageStr];
    HXLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    // fileExistsAtPath 判断一个文件或目录是否有效
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    
    if ( !(existed == YES) ) {
        // 图片不存在沙盒里，检查文件夹是否存在
        NSString *folderPath = [NSString stringWithFormat:@"%@/ShareImages",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existedFolder = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
        if ( !(isDir == YES && existedFolder == YES) ) {
            // 不存在的文件夹JKImage才会创建
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // 文件夹存在就把图片缓存进去
        // 图片不存在
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageUrl]];
        //转换为图片保存到以上的沙盒路径中
        UIImage * currentImage = [UIImage imageWithData:data];
        //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        [UIImageJPEGRepresentation(currentImage, 0.8) writeToFile:[NSString stringWithFormat:@"%@/%@",folderPath,catchsImageStr] atomically:YES];
        completedHandle([NSString stringWithFormat:@"%@/%@",folderPath,catchsImageStr],currentImage);
    }else{
        // 图片在沙盒里直接取出
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        completedHandle(filePath,image);
    }
}
@end
