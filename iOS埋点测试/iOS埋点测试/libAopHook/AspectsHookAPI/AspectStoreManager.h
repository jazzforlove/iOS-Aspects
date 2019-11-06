//
//  AspectStoreManager.h
//  AopTestDemo
//
//  Created by 李国卿 on 2019/11/4.
//  Copyright © 2019 cimain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AspectStoreManager : NSObject

+ (NSString *)getLocatAspectHookPath;

+ (void)createLocalAspectHookPlist;

/// 记录手机版本相关信息
+ (void)recordingAppInfo;

/// 统计界面层
/// @param pageName 控制器名称
+ (void)beginLogPageView:(NSString *)pageName;

/// 统计事件层
/// @param eventInfo 事件信息
+ (void)eventInfo:(NSDictionary *)eventInfo;
// 统计cell事件层
/// @param eventInfo 事件信息
+ (void)cellEventId:(NSString *)eventId eventInfo:(NSDictionary *)eventInfo;



@end

NS_ASSUME_NONNULL_END
