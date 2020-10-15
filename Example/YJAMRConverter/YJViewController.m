//
//  YJViewController.m
//  YJAMRConverter
//
//  Created by yangjing901 on 10/15/2020.
//  Copyright (c) 2020 yangjing901. All rights reserved.
//

#import "YJViewController.h"
#import <YJAMRConverter/YJAMRConverter.h>
#import <AVFoundation/AVFoundation.h>

@interface YJViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSData *voiceData;

@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, copy) NSString *voiceFormat;

@property (nonatomic, assign) long duration;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation YJViewController {
    NSURLSessionDownloadTask *_task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.voiceUrl = @"https://image1.gopopon.com/1584503526345_868608039163978_audio_0";
    self.voiceFormat = @"amr";
}

//MARK: - player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self stopPlay];
}

- (IBAction)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (!self.voiceData) {
        if (!self.voiceUrl || self.voiceUrl.length == 0) return;
                    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __weak __typeof(self) weakSelf = self;
            [weakSelf getDataSuccess:^(NSURL *response) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.voiceData = [NSData dataWithContentsOfURL:response];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf startPlayForData:self.voiceData format:self.voiceFormat];
                });
                
            } failure:^(void) {
            }];
        });
        
    } else {
        [self startPlayForData:self.voiceData format:self.voiceFormat];
    }
}

- (void)getDataSuccess:(void (^)(NSURL *response))success failure:(void (^)(void))failure {
    NSURL *url = [NSURL URLWithString:self.voiceUrl];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (success) success (location);
        } else {
            if (failure) failure();
        }
    }];
    
    [_task resume];
}

- (BOOL)startPlayForData:(NSData *)data format:(NSString *)format {
    format = format.lowercaseString;
    if ([format isEqualToString:@"amr"]) {
        //  arm转wav
        #if __has_include(<YJAMRConverter/YJAMRConverter.h>)
            data = [YJAMRConverter yjAmrToWavWithData:data];
        #endif
    }

    if (self.player.isPlaying) {
        [self stopPlay];
    }
    
    if (!data) {
        NSLog(@"yangjing_audio: 音频数据为空");
        return NO;
    }
    
    /// 扬声器
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];
    
    BOOL shouldPlayback = YES;
    for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
        /// 内置听筒处理
        if (![output.portType isEqualToString:AVAudioSessionPortBuiltInReceiver] && ![output.portType isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            shouldPlayback = NO;
        }
    }
    
    if (shouldPlayback) {
        /// 切换扬声器
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
        
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error) {
        NSLog(@"yangjing_audio: 音频播放器初始化失败");
        return NO;
    }
    self.player.delegate = self;
    self.player.currentTime = 0;
    
    BOOL ret2 = [self.player prepareToPlay];
    if (!ret2) {
        NSLog(@"yangjing_audio: 音频播放器准备失败");
        return NO;
    };
    
    BOOL ret = [self.player play];
    if (!ret) {
        NSLog(@"yangjing_audio: 音频播放器播放失败");
        return NO;
    }
    
    NSLog(@"yangjing_audio: 播放成功");
    return YES;
}

/// 停止播放
- (void)stopPlay {
    [self.player stop];
    self.player.currentTime = 0;
}

@end
