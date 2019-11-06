//
//  AspectMananer.m
//  AopTestDemo
//
//  Created by ChenMan on 2018/4/26.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AspectMananer.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import "Aspects.h"
#import "AspectStoreManager.h"


@implementation AspectMananer

+(void)trackAspectHooks{
    
    [AspectMananer trackViewAppear];
    [AspectMananer trackBttonEvent];
    [AspectStoreManager recordingAppInfo];
}


#pragma mark -- 监控统计用户进入此界面的时长，频率等信息
+ (void)trackViewAppear{
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> info){
                                   
                                   //用户统计代码写在此处
                                   NSLog(@"[打点统计]:%@ viewWillAppear",NSStringFromClass([info.instance class]));
                                   NSString *className = NSStringFromClass([info.instance class]);
//                                   DDLogDebug(@"className-->%@",className);
//                                   [MobClick beginLogPageView:className];//(className为页面名称
                                    [AspectStoreManager beginLogPageView:className];
                                   
                               }
                                    error:NULL];
    
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> info){
                                   
                                   //用户统计代码写在此处
                                   NSLog(@"[打点统计]:%@ viewWillDisappear",NSStringFromClass([info.instance class]));
//                                   NSString *className = NSStringFromClass([info.instance class]);
//                                   DDLogDebug(@"className-->%@",className);
//                                   [MobClick endLogPageView:className];
                                   
                               }
                                    error:NULL];
    
    
    //other hooks ... goes here
    //...
}

#pragma mark --- 监控button的点击事件
+ (void)trackBttonEvent{
    
    __weak typeof(self) ws = self;
    
    //设置事件统计
    //放到异步线程去执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //读取配置文件，获取需要统计的事件列表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EventList" ofType:@"plist"];
        
        NSDictionary *eventStatisticsDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        [ws trackSubViewButtonEvent:eventStatisticsDict];
        
//        for (NSString *classNameString in eventStatisticsDict.allKeys) {
//            //使用运行时创建类对象
//            const char * className = [classNameString UTF8String];
//            //从一个字串返回一个类
//            Class newClass = objc_getClass(className);
//
//            NSArray *pageEventList = [eventStatisticsDict objectForKey:classNameString];
//            for (NSDictionary *eventDict in pageEventList) {
//                //事件方法名称
//                NSString *eventMethodName = eventDict[@"MethodName"];
//                SEL seletor = NSSelectorFromString(eventMethodName);
////                NSString *eventId = eventDict[@"EventId"];
////                NSString *propertyName = eventDict[@"PropertyName"];
//                NSString *controlName = eventDict[@"ControlName"];
//                NSDictionary *subViewsDict = eventDict[@"SubViews"];
//                if (subViewsDict) {
//                    [ws trackSubViewButtonEvent:subViewsDict];
//                }
//                if ([controlName isEqualToString:@"UITableViewCell"]||[controlName isEqualToString:@"UICollectionViewCell"]) {
//                    [ws trackTableViewEventWithClass:newClass selector:seletor eventInfo:eventDict];
//                }else{
//                    if ([eventMethodName containsString:@":"]) {//判断是否含参数
//                        [ws trackParameterEventWithClass:newClass selector:seletor eventInfo:eventDict];
//                    }else{
//                        [ws trackEventWithClass:newClass selector:seletor eventInfo:eventDict];
//                    }
//                }
//            }
//        }
    });
}
+ (void)trackSubViewButtonEvent:(NSDictionary *)subViewDict{
    
    __weak typeof(self) ws = self;
    
    for (NSString *classNameString in subViewDict.allKeys) {
        //使用运行时创建类对象
        const char * className = [classNameString UTF8String];
        //从一个字串返回一个类
        Class newClass = objc_getClass(className);
        NSArray *pageEventList = [subViewDict objectForKey:classNameString];
        for (NSDictionary *eventDict in pageEventList) {
             //事件方法名称
            NSString *eventMethodName = eventDict[@"MethodName"];
            SEL seletor = NSSelectorFromString(eventMethodName);
//                NSString *eventId = eventDict[@"EventId"];
//                NSString *propertyName = eventDict[@"PropertyName"];
            NSString *controlName = eventDict[@"ControlName"];
            NSDictionary *subViewsDict = eventDict[@"SubViews"];
            if (subViewsDict) {
                [ws trackSubViewButtonEvent:subViewsDict];
            }
            if ([controlName isEqualToString:@"UITableViewCell"]||[controlName isEqualToString:@"UICollectionViewCell"]) {
                [ws trackTableViewEventWithClass:newClass selector:seletor eventInfo:eventDict];
            }else{
                if ([eventMethodName containsString:@":"]) {//判断是否含参数
                    [ws trackParameterEventWithClass:newClass selector:seletor eventInfo:eventDict];
                }else{
                    [ws trackEventWithClass:newClass selector:seletor eventInfo:eventDict];
                }
            }
        }
    }
}


#pragma mark -- 1.监控button和tap点击事件(不带参数)
+ (void)trackEventWithClass:(Class)klass selector:(SEL)selector eventInfo:(NSDictionary *)eventInfo{
    
    [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSLog(@"className--->%@",className);
//        NSLog(@"event----->%@",eventID);
        
        [AspectStoreManager eventInfo:eventInfo];
        
//        if ([eventID isEqualToString:@"xxx"]) {
//            [EJServiceUserInfo isLogin]?[MobClick event:eventID]:[MobClick event:@"???"];
//        }else{
//            [MobClick event:eventID];
//        }
    } error:NULL];
}


#pragma mark -- 2.监控button和tap点击事件（带参数）
+ (void)trackParameterEventWithClass:(Class)klass selector:(SEL)selector eventInfo:(NSDictionary *)eventInfo{
    
    [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UIButton *button) {
        
        NSLog(@"button---->%@",button);
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSLog(@"className--->%@",className);
//        NSLog(@"event----->%@",eventID);
//        [AspectStoreManager eventId:eventID superView:superView];
        [AspectStoreManager eventInfo:eventInfo];
        
    } error:NULL];
}


#pragma mark -- 3.监控tableView的点击事件
+ (void)trackTableViewEventWithClass:(Class)klass selector:(SEL)selector eventInfo:(NSDictionary *)eventInfo{
    
    [klass aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,NSSet *touches, UIEvent *event) {
        
        NSString *className = NSStringFromClass([aspectInfo.instance class]);
        NSString *eventID = eventInfo[@"EventId"];
        NSLog(@"className--->%@",className);
        NSLog(@"event----->%@",eventID);
        NSLog(@"section---->%@",[event valueForKeyPath:@"section"]);
        NSLog(@"row---->%@",[event valueForKeyPath:@"row"]);
        NSInteger section = [[event valueForKeyPath:@"section"]integerValue];
        NSInteger row = [[event valueForKeyPath:@"row"]integerValue];
        NSString *cellEventId = [NSString stringWithFormat:@"%@|%ld-%ld",eventID,section,row];
        
        [AspectStoreManager cellEventId:cellEventId eventInfo:eventInfo];
        
    } error:NULL];
}
@end
