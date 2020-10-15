//
//  YJAMRConverter.m
//  YJAMRConverter
//
//  Created by 杨警 on 2020/10/15.
//

#import "YJAMRConverter.h"
#import <YJAMRConverter/YJInterf_dec.h>
#import <YJAMRConverter/YJInterf_enc.h>
#import <YJAMRConverter/YJAmrFileCodec.h>

@implementation YJAMRConverter


+ (NSData *)yjAmrToWavWithData:(NSData *)amrData {
    NSData *wavData = DecodeAMRToWAVE(amrData);
    return wavData;
}

+ (int)yjAmrToWavWithPath:(NSString*)amrPath toPath:(NSString*)wavPath {
    NSData *amrData = [NSData dataWithContentsOfFile:amrPath];
    NSData *wavData = [self yjAmrToWavWithData:amrData];
    if (wavData != nil) {
        [wavData writeToFile:wavPath atomically:YES];
        return 0;
    }
    return -1;
}

+ (NSData *)yjWavToAmrWithData:(NSData *)wavData {
    NSData *amrData = EncodeWAVEToAMR(wavData, 1, 16);
    return amrData;
}


+ (int)yjWavToAmrWithPath:(NSString*)wavPath toPath:(NSString*)amrPath {
    NSData *wavData = [NSData dataWithContentsOfFile:wavPath];
    NSData *amrData = [self yjWavToAmrWithData:wavData];
    if (amrData != nil) {
        [amrData writeToFile:amrPath atomically:YES];
        return 0;
    }
    return -1;
}

@end
