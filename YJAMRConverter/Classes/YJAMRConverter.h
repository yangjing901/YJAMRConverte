//
//  YJAMRConverter.h
//  YJAMRConverter
//
//  Created by 杨警 on 2020/10/15.
//

#import <Foundation/Foundation.h>

@interface YJAMRConverter : NSObject

/// amr转wav
+ (NSData *)yjAmrToWavWithData:(NSData *)amrData;
+ (int)yjAmrToWavWithPath:(NSString*)amrPath toPath:(NSString*)wavPath;

/// wav转amr
+ (NSData *)yjWavToAmrWithData:(NSData *)wavData;
+ (int)yjWavToAmrWithPath:(NSString*)wavPath toPath:(NSString*)amrPath;

@end
