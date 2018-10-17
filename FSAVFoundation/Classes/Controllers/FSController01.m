//
//  FSController01.m
//  FSAVFoundation
//
//  Created by 付森 on 2018/10/17.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSController01.h"
#import "FSSpeechTool.h"


@interface FSController01 ()

@end

@implementation FSController01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(doRightAction)];
}


- (void)doRightAction
{
    NSString *text = @"hello world";
    
//    NSString *text = @"你好世界";
    
    text = [self englishText];
    
    [[FSSpeechTool shareInstance] readText:text];
}

- (NSString *)englishText
{
    NSString *string = @"For maximum security, passwords should not be cohesive words or phrases and should not be too obviously related to something like your birthday or the birthday of someone close to you. Personal information is one of the first things used when people attempt to break passwords. Having a password of \"Password\" is indeed humorous and ironic but it is not in the least bit secure.";
    
    return string;
}

@end
