//
//  FSRecorderTool.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/20.
//  Copyright © 2018年 付森. All rights reserved.
//

/*
 录音工具类
 */

#import <Foundation/Foundation.h>

@class FSRecorderTool;
@interface FSRecorderTool : NSObject

- (BOOL)record;

- (void)pause;

- (void)stopRecordWithCompletion:(void(^)(FSRecorderTool *tool, BOOL suc))completion;

- (void)saveFileWithName:(NSString *)name completion:(void(^)(BOOL suc, NSError *err, NSURL *fileUrl))completion;

@end
