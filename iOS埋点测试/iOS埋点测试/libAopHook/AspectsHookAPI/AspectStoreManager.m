//
//  AspectStoreManager.m
//  AopTestDemo
//
//  Created by 李国卿 on 2019/11/4.
//  Copyright © 2019 cimain. All rights reserved.
//

#import "AspectStoreManager.h"
#import <UIKit/UIKit.h>

@implementation AspectStoreManager

+ (NSString *)getLocatAspectHookPath{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [filePath stringByAppendingPathComponent:@"aspect.plist"];
    return fileName;
}

+ (void)createLocalAspectHookPlist{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         NSString *fileName = [AspectStoreManager getLocatAspectHookPath];
        //使用NSMutableDictionary来接收plist里面的文件
        NSMutableDictionary * plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:fileName];
        //判断plist存不存在，如果不存在，则创建这个Dic，否则，后面的文件写入不进去
        if (plistDic == nil) {
            plistDic = [[NSMutableDictionary alloc]init];
        }
    });
}

+ (void)recordingAppInfo{
    
    NSString *pathName = [AspectStoreManager getLocatAspectHookPath];
    
    NSDictionary *aspectDict = [NSDictionary dictionaryWithContentsOfFile:pathName];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:aspectDict];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
     NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    // app buddle id
    NSString *app_bundleId = [NSBundle mainBundle].bundleIdentifier;
    // 手机序列号
    NSString *identifierNumber = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    // 手机别名：用户定义的名称
    NSString *userPhoneName = [[UIDevice currentDevice] name];
    // 设备名称
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    // 手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    // 手机型号
    NSString *phoneModel = [[UIDevice currentDevice] model];
    // 地方型号  （国际化区域名称）
//    NSString *localPhoneModel = [[UIDevice currentDevice] localizedModel];
    
    NSMutableDictionary *appInfo = [NSMutableDictionary dictionary];
    [appInfo setValue:app_Name forKey:@"appName"];
    [appInfo setValue:app_Version forKey:@"appVersion"];
    [appInfo setValue:app_build forKey:@"appBuild"];
    [appInfo setValue:app_bundleId forKey:@"appBundleId"];
    [appInfo setValue:identifierNumber forKey:@"UUID"];
    [appInfo setValue:userPhoneName forKey:@"phoneName"];
    [appInfo setValue:deviceName forKey:@"deviceName"];
    [appInfo setValue:phoneVersion forKey:@"phoneVersion"];
    [appInfo setValue:phoneModel forKey:@"phoneModel"];
    
    [mutableDict setValue:appInfo forKey:@"appInfo"];
    [mutableDict writeToFile:pathName atomically:YES];
    
    NSLog(@"mutableDict----%@",mutableDict);
}
+ (void)beginLogPageView:(NSString *)pageName{
    
    NSString *pathName = [AspectStoreManager getLocatAspectHookPath];
    NSDictionary *aspectDict = [NSDictionary dictionaryWithContentsOfFile:pathName];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:aspectDict];
    if (aspectDict && aspectDict[pageName]) {
        NSDictionary *infoDict = aspectDict[pageName];
        NSNumber *number = infoDict[@"count"];
        NSArray  *timesArr = infoDict[@"times"];
        NSInteger count = number.integerValue+1;
        NSNumber *number2 = [NSNumber numberWithInteger:count];
        NSMutableArray *newTimes = [NSMutableArray arrayWithArray:timesArr];
        [newTimes addObject:[AspectStoreManager currentDateString]];
        NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:number2,@"count",newTimes,@"times",nil];
        [mutableDict setValue:newDict forKey:pageName];
        [mutableDict writeToFile:pathName atomically:YES];
    }else{
        NSNumber *number = [NSNumber numberWithInt:1];
        NSArray *array = [NSArray arrayWithObject:[AspectStoreManager currentDateString]];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:number,@"count",array,@"times", nil];
        [mutableDict setValue:infoDict forKey:pageName];
        [mutableDict writeToFile:pathName atomically:YES];
    }
    NSLog(@"mutableDict----%@",mutableDict);
    
}

+ (void)eventInfo:(NSDictionary *)eventInfo{
    NSString *pathName = [AspectStoreManager getLocatAspectHookPath];
    NSDictionary *aspectDict = [NSDictionary dictionaryWithContentsOfFile:pathName];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:aspectDict];
    NSString *eventId = eventInfo[@"EventId"];
    NSString *propertyName = eventInfo[@"PropertyName"];
    NSString *superView = eventInfo[@"SuperView"];
    if (aspectDict || aspectDict[eventId]) {
        NSDictionary *infoDict = aspectDict[eventId];
        NSNumber *number = infoDict[@"count"];
        NSArray  *timesArr = infoDict[@"times"];
        NSInteger count = number.integerValue+1;
        NSNumber *number2 = [NSNumber numberWithInteger:count];
        NSMutableArray *newTimes = [NSMutableArray arrayWithArray:timesArr];
        [newTimes addObject:[AspectStoreManager currentDateString]];
        NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:number2,@"count",newTimes,@"times",propertyName,@"propertyName",superView,@"superView",nil];
        [mutableDict setValue:newDict forKey:eventId];
        [mutableDict writeToFile:pathName atomically:YES];
    }else{
        NSNumber *number = [NSNumber numberWithInt:1];
        NSArray *array = [NSArray arrayWithObject:[AspectStoreManager currentDateString]];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:number,@"count",array,@"times",propertyName,@"propertyName",superView,@"superView", nil];
        [mutableDict setValue:infoDict forKey:eventId];
        [mutableDict writeToFile:pathName atomically:YES];
    }
    NSLog(@"mutableDict----%@",mutableDict);
}
+ (void)cellEventId:(NSString *)eventId eventInfo:(NSDictionary *)eventInfo{
    NSString *pathName = [AspectStoreManager getLocatAspectHookPath];
    NSDictionary *aspectDict = [NSDictionary dictionaryWithContentsOfFile:pathName];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:aspectDict];
    NSString *propertyName = eventInfo[@"PropertyName"];
    NSString *superView = eventInfo[@"SuperView"];
    if (aspectDict || aspectDict[eventId]) {
           NSDictionary *infoDict = aspectDict[eventId];
           NSNumber *number = infoDict[@"count"];
           NSArray  *timesArr = infoDict[@"times"];
           NSInteger count = number.integerValue+1;
           NSNumber *number2 = [NSNumber numberWithInteger:count];
           NSMutableArray *newTimes = [NSMutableArray arrayWithArray:timesArr];
           [newTimes addObject:[AspectStoreManager currentDateString]];
           NSDictionary *newDict = [NSDictionary dictionaryWithObjectsAndKeys:number2,@"count",newTimes,@"times",propertyName,@"propertyName",superView,@"superView",nil];
           [mutableDict setValue:newDict forKey:eventId];
           [mutableDict writeToFile:pathName atomically:YES];
       }else{
           NSNumber *number = [NSNumber numberWithInt:1];
           NSArray *array = [NSArray arrayWithObject:[AspectStoreManager currentDateString]];
           NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:number,@"count",array,@"times",propertyName,@"propertyName",superView,@"superView", nil];
           [mutableDict setValue:infoDict forKey:eventId];
           [mutableDict writeToFile:pathName atomically:YES];
       }
       NSLog(@"mutableDict----%@",mutableDict);
}

+ (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


@end
