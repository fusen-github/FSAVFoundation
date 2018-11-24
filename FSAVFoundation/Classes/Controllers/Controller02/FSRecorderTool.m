//
//  FSRecorderTool.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/20.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSRecorderTool.h"
#import <AVFoundation/AVFoundation.h>


@interface FSRecorderTool ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recoder;

@property (nonatomic, copy) void(^completion)(id tool, BOOL suc);

@end


@implementation FSRecorderTool

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *tmpPath = NSTemporaryDirectory();
        
        
        /*
         .caf格式是 core audio format(caf)。这个通常是最好的音频容器格式，
         因为这个格式和内容无关，并且可以保存core audio支持的任何音频格式
         */
        NSString *filePath = [tmpPath stringByAppendingPathComponent:@"memo.caf"];
        
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        
        
        /**
         指定音频格式
         设置的音频格式一定要喝音频文件后缀名相匹配。(.caf 是core audio format通用格式)
         如果不匹配，录音时会报错
         */
        [setting setObject:@(kAudioFormatAppleIMA4) forKey:AVFormatIDKey];
        
        
        /**
         指定采样率，单位(Hz)
         采样率定义了对输入的模拟音频信号每一秒的采样数，决定着音频的质量和音频文件的物理大小
         使用什么样的采样率没有一个明确的定义，但是有几个标准采样率8000、16000、22050、44100
         最终效果取决于听者的听觉
         */
        [setting setObject:@(44100.0f) forKey:AVSampleRateKey];
        
        
        /**
         通道数
         1是单通道，2是立体声。一般都是设置单通道1
         */
        [setting setObject:@(1) forKey:AVNumberOfChannelsKey];
        
        
        /**
         编码的深度
         */
        [setting setObject:@(16) forKey:AVEncoderBitDepthHintKey];
        
        
        /**
         质量
         */
        [setting setObject:@(AVAudioQualityMedium) forKey:AVEncoderAudioQualityKey];
        
        NSError *error = nil;
        
        AVAudioRecorder *recoder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:setting error:&error];
        
        self.recoder = recoder;
        
        if (recoder)
        {
            recoder.delegate = self;
            
            [recoder prepareToRecord];
        }
    }
    return self;
}

- (BOOL)record
{
    BOOL rst = [self.recoder record];
    
    return rst;
}

- (void)pause
{
    [self.recoder pause];
}

- (void)stopRecordWithCompletion:(void (^)(FSRecorderTool *, BOOL))completion
{
    self.completion = completion;
    
    [self.recoder stop];
}

- (void)saveFileWithName:(NSString *)name completion:(void (^)(BOOL, NSError *, NSURL *))completion
{
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *fileName = [NSString stringWithFormat:@"%@-%f.caf",name,timeInterval];
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [document stringByAppendingPathComponent:fileName];
    
    NSURL *tmpUrl = self.recoder.url;
    
    NSURL *realUrl = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    BOOL rst = [[NSFileManager defaultManager] copyItemAtURL:tmpUrl toURL:realUrl error:&error];
    
    realUrl = rst ? realUrl : nil;
    
    if (completion)
    {
        completion(rst, error, realUrl);
    }
}

#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.completion)
    {
        self.completion(self, flag);
    }
}

@end
