//
//  FSSpeechTool.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSSpeechTool.h"
#import <AVFoundation/AVFoundation.h>


@interface FSSpeechTool ()

/**
 语音合成器  实现文本->语音功能
 */
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation FSSpeechTool

+ (instancetype)shareInstance
{
    static FSSpeechTool *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (AVSpeechSynthesizer *)speechSynthesizer
{
    if (_speechSynthesizer == nil)
    {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    
    return _speechSynthesizer;
}

- (void)readText:(NSString *)text
{
    if (!text.length) return;
    
//    NSArray *array = [AVSpeechSynthesisVoice speechVoices];
    
//    NSLog(@"%@",array);
    
    
    NSString *language = @"en-US";
    
//    language = @"zh-CN";
    
    /// 语音合成的声音
    AVSpeechSynthesisVoice *synthesisVoice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    
    /// 话语，表达
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    
    /// 设置话语的声音
    utterance.voice = synthesisVoice;
    
    /// 语速
//    utterance.rate = 0.6 * AVSpeechUtteranceMaximumSpeechRate;
    
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    /// 设置说话时的音调
    utterance.pitchMultiplier = 0.8;
    
    /// 设置在播放两句话中间停顿的时间
    utterance.postUtteranceDelay = 1;
    
    /// 给语音合成器，设置话语、表达
    [self.speechSynthesizer speakUtterance:utterance];
}


@end

/*
 [AVSpeechSynthesisVoice 0x1c000dba0] Language: ar-SA, Name: Maged, Quality: Default [com.apple.ttsbundle.Maged-compact],
 [AVSpeechSynthesisVoice 0x1c000dfe0] Language: cs-CZ, Name: Zuzana, Quality: Default [com.apple.ttsbundle.Zuzana-compact],
 [AVSpeechSynthesisVoice 0x1c400ae40] Language: da-DK, Name: Sara, Quality: Default [com.apple.ttsbundle.Sara-compact],
 [AVSpeechSynthesisVoice 0x1c000d730] Language: de-DE, Name: Anna, Quality: Default [com.apple.ttsbundle.Anna-compact],
 [AVSpeechSynthesisVoice 0x1c000d920] Language: de-DE, Name: Helena, Quality: Default [com.apple.ttsbundle.siri_female_de-DE_compact],
 [AVSpeechSynthesisVoice 0x1c000dca0] Language: de-DE, Name: Martin, Quality: Default [com.apple.ttsbundle.siri_male_de-DE_compact],
 [AVSpeechSynthesisVoice 0x1c000dd20] Language: el-GR, Name: Melina, Quality: Default [com.apple.ttsbundle.Melina-compact],
 [AVSpeechSynthesisVoice 0x1c000cfe0] Language: en-AU, Name: Catherine, Quality: Default [com.apple.ttsbundle.siri_female_en-AU_compact],
 [AVSpeechSynthesisVoice 0x1c000d8a0] Language: en-AU, Name: Gordon, Quality: Default [com.apple.ttsbundle.siri_male_en-AU_compact],
 [AVSpeechSynthesisVoice 0x1c000da20] Language: en-AU, Name: Karen, Quality: Default [com.apple.ttsbundle.Karen-compact],
 [AVSpeechSynthesisVoice 0x1c000d7b0] Language: en-GB, Name: Arthur, Quality: Default [com.apple.ttsbundle.siri_male_en-GB_compact],
 [AVSpeechSynthesisVoice 0x1c000d010] Language: en-GB, Name: Daniel, Quality: Default [com.apple.ttsbundle.Daniel-compact],
 [AVSpeechSynthesisVoice 0x1c000dc60] Language: en-GB, Name: Martha, Quality: Default [com.apple.ttsbundle.siri_female_en-GB_compact],
 [AVSpeechSynthesisVoice 0x1c000dda0] Language: en-IE, Name: Moira, Quality: Default [com.apple.ttsbundle.Moira-compact],
 [AVSpeechSynthesisVoice 0x1c000d140] Language: en-US, Name: Aaron, Quality: Default [com.apple.ttsbundle.siri_male_en-US_compact],
 [AVSpeechSynthesisVoice 0x1c000ce90] Language: en-US, Name: Fred, Quality: Default [com.apple.speech.synthesis.voice.Fred],
 [AVSpeechSynthesisVoice 0x1c400abe0] Language: en-US, Name: Nicky, Quality: Default [com.apple.ttsbundle.siri_female_en-US_compact],
 [AVSpeechSynthesisVoice 0x1c400ad20] Language: en-US, Name: Samantha, Quality: Default [com.apple.ttsbundle.Samantha-compact],
 [AVSpeechSynthesisVoice 0x1c400a390] Language: en-ZA, Name: Tessa, Quality: Default [com.apple.ttsbundle.Tessa-compact],
 [AVSpeechSynthesisVoice 0x1c000dde0] Language: es-ES, Name: Monica, Quality: Default [com.apple.ttsbundle.Monica-compact],
 [AVSpeechSynthesisVoice 0x1c400acb0] Language: es-MX, Name: Paulina, Quality: Default [com.apple.ttsbundle.Paulina-compact],
 [AVSpeechSynthesisVoice 0x1c400ac70] Language: fi-FI, Name: Satu, Quality: Default [com.apple.ttsbundle.Satu-compact],
 [AVSpeechSynthesisVoice 0x1c000d380] Language: fr-CA, Name: Amelie, Quality: Default [com.apple.ttsbundle.Amelie-compact],
 [AVSpeechSynthesisVoice 0x1c000d610] Language: fr-FR, Name: Daniel, Quality: Default [com.apple.ttsbundle.siri_male_fr-FR_compact],
 [AVSpeechSynthesisVoice 0x1c000dbe0] Language: fr-FR, Name: Marie, Quality: Default [com.apple.ttsbundle.siri_female_fr-FR_compact],
 [AVSpeechSynthesisVoice 0x1c400ab10] Language: fr-FR, Name: Thomas, Quality: Default [com.apple.ttsbundle.Thomas-compact],
 [AVSpeechSynthesisVoice 0x1c000cf80] Language: he-IL, Name: Carmit, Quality: Default [com.apple.ttsbundle.Carmit-compact],
 [AVSpeechSynthesisVoice 0x1c000dae0] Language: hi-IN, Name: Lekha, Quality: Default [com.apple.ttsbundle.Lekha-compact],
 [AVSpeechSynthesisVoice 0x1c000dc20] Language: hu-HU, Name: Mariska, Quality: Default [com.apple.ttsbundle.Mariska-compact],
 [AVSpeechSynthesisVoice 0x1c000d150] Language: id-ID, Name: Damayanti, Quality: Default [com.apple.ttsbundle.Damayanti-compact],
 [AVSpeechSynthesisVoice 0x1c000d480] Language: it-IT, Name: Alice, Quality: Default [com.apple.ttsbundle.Alice-compact],
 [AVSpeechSynthesisVoice 0x1c000d8e0] Language: ja-JP, Name: Hattori, Quality: Default [com.apple.ttsbundle.siri_male_ja-JP_compact],
 [AVSpeechSynthesisVoice 0x1c000da60] Language: ja-JP, Name: Kyoko, Quality: Default [com.apple.ttsbundle.Kyoko-compact],
 [AVSpeechSynthesisVoice 0x1c400ad80] Language: ja-JP, Name: O-ren, Quality: Default [com.apple.ttsbundle.siri_female_ja-JP_compact],
 [AVSpeechSynthesisVoice 0x1c000df20] Language: ko-KR, Name: Yuna, Quality: Default [com.apple.ttsbundle.Yuna-compact],
 [AVSpeechSynthesisVoice 0x1c000d470] Language: nl-BE, Name: Ellen, Quality: Default [com.apple.ttsbundle.Ellen-compact],
 [AVSpeechSynthesisVoice 0x1c000de30] Language: nl-NL, Name: Xander, Quality: Default [com.apple.ttsbundle.Xander-compact],
 [AVSpeechSynthesisVoice 0x1c400ac60] Language: no-NO, Name: Nora, Quality: Default [com.apple.ttsbundle.Nora-compact],
 [AVSpeechSynthesisVoice 0x1c000dfa0] Language: pl-PL, Name: Zosia, Quality: Default [com.apple.ttsbundle.Zosia-compact],
 [AVSpeechSynthesisVoice 0x1c000db60] Language: pt-BR, Name: Luciana, Quality: Default [com.apple.ttsbundle.Luciana-compact],
 [AVSpeechSynthesisVoice 0x1c000d9a0] Language: pt-PT, Name: Joana, Quality: Default [com.apple.ttsbundle.Joana-compact],
 [AVSpeechSynthesisVoice 0x1c000d960] Language: ro-RO, Name: Ioana, Quality: Default [com.apple.ttsbundle.Ioana-compact],
 [AVSpeechSynthesisVoice 0x1c000dd60] Language: ru-RU, Name: Milena, Quality: Default [com.apple.ttsbundle.Milena-compact],
 [AVSpeechSynthesisVoice 0x1c000daa0] Language: sk-SK, Name: Laura, Quality: Default [com.apple.ttsbundle.Laura-compact],
 [AVSpeechSynthesisVoice 0x1c000d850] Language: sv-SE, Name: Alva, Quality: Default [com.apple.ttsbundle.Alva-compact],
 [AVSpeechSynthesisVoice 0x1c000d9e0] Language: th-TH, Name: Kanya, Quality: Default [com.apple.ttsbundle.Kanya-compact],
 [AVSpeechSynthesisVoice 0x1c000de60] Language: tr-TR, Name: Yelda, Quality: Default [com.apple.ttsbundle.Yelda-compact],
 [AVSpeechSynthesisVoice 0x1c400ae70] Language: zh-CN, Name: Ting-Ting (Enhanced), Quality: Enhanced [com.apple.ttsbundle.Ting-Ting-premium],
 [AVSpeechSynthesisVoice 0x1c000dea0] Language: zh-CN, Name: Yu-shu (Enhanced), Quality: Enhanced [com.apple.ttsbundle.siri_female_zh-CN_premium],
 [AVSpeechSynthesisVoice 0x1c000db20] Language: zh-CN, Name: Li-mu, Quality: Default [com.apple.ttsbundle.siri_male_zh-CN_compact],
 [AVSpeechSynthesisVoice 0x1c400aeb0] Language: zh-CN, Name: Ting-Ting, Quality: Default [com.apple.ttsbundle.Ting-Ting-compact],
 [AVSpeechSynthesisVoice 0x1c000dee0] Language: zh-CN, Name: Yu-shu, Quality: Default [com.apple.ttsbundle.siri_female_zh-CN_compact],
 [AVSpeechSynthesisVoice 0x1c400ac30] Language: zh-HK, Name: Sin-Ji, Quality: Default [com.apple.ttsbundle.Sin-Ji-compact],
 [AVSpeechSynthesisVoice 0x1c000dce0] Language: zh-TW, Name: Mei-Jia, Quality: Default [com.apple.ttsbundle.Mei-Jia-compact]
 */
