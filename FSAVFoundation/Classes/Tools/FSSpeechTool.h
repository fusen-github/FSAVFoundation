//
//  FSSpeechTool.h
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSpeechTool : NSObject

+ (instancetype)shareInstance;

- (void)readText:(NSString *)text;

@end
