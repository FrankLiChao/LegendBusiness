//
//  NSObjec+PortEncry.m
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "NSObject+PortEncry.h"
#import "MJExtension.h"
#import "DefineKey.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

@implementation NSObject(PortEncry)


-(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    CCCryptorRef thisEncipher = NULL;
    uint8_t iv[kCCBlockSizeDES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    CCCryptorStatus ccStatus = CCCryptorCreate(kCCEncrypt,
                                               kCCAlgorithmDES,
                                               kCCOptionPKCS7Padding | kCCOptionECBMode,
                                               (const void *)[keyData bytes],
                                               kCCBlockSizeDES,
                                               (const void *)iv,
                                               &thisEncipher);
    if (ccStatus == kCCSuccess) {
        size_t totalBytesWritten = 0;
        size_t plainTextBufferSize = [data length];
        size_t bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        uint8_t *bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t) );
        
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        
        uint8_t *ptr = bufferPtr;
        size_t remainingBytes = bufferPtrSize;
        size_t movedBytes = 0;
        ccStatus = CCCryptorUpdate(thisEncipher,
                                   (const void *)[data bytes],
                                   plainTextBufferSize,
                                   ptr,
                                   remainingBytes,
                                   &movedBytes);
        
        if (ccStatus == kCCSuccess) {
            ptr += movedBytes;
            remainingBytes -= movedBytes;
            totalBytesWritten += movedBytes;
            
            ccStatus = CCCryptorFinal(thisEncipher,
                                      ptr,
                                      remainingBytes,
                                      &movedBytes);
            totalBytesWritten += movedBytes;
            
            if (thisEncipher) {
                (void) CCCryptorRelease(thisEncipher);
                thisEncipher = NULL;
            }
            
            if (ccStatus == kCCSuccess) {
                NSData *cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
                NSString *cipherString = [GTMBase64 stringByEncodingData:cipherOrPlainText];
                if (bufferPtr) { free(bufferPtr); }
                return cipherString;
            }
        }
    }
    NSLog(@"DES加密失败");
    return nil;
}

-(NSString*)encodeData:(NSString*)data{
    
    NSString* str = [self encryptUseDES:data key:DES_KEY];
    
    return str;
}

-(NSString*)decodeData:(NSString*)str{
    
    NSData *encodeData = [GTMBase64 decodeBytes:[str UTF8String] length:str.length];
    
 
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding| kCCOptionECBMode,
                                          [DES_KEY UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [encodeData bytes],
                                          [encodeData length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
  
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
 
        plainText = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)buffer length:(NSUInteger)numBytesEncrypted] encoding:NSUTF8StringEncoding] ;
        
    }else{
        NSLog(@"DES解密失败");
    }

    return plainText;
    
}


- (NSString*)getJSONStr:(NSDictionary*)dict {

    NSString *jsonstring = [dict mj_JSONString];
    
    return jsonstring;
}

- (NSString *)URLEncodedString: (NSString *)param
{
    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                  (CFStringRef)param, nil,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    return encodedValue;
}

-(NSMutableDictionary*)createRequsetData:(NSDictionary*)postDic{
    
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];
    
    NSString *jsonstr = [self getJSONStr:postDic];
    jsonstr = [self encodeData:jsonstr];
    
    [loginDic setObject:jsonstr forKey:@"data"];
    
    return loginDic;
}

-(NSArray*)getSignArray:(NSDictionary*)postDic{
    
    NSArray *sortArr = [[postDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *key in sortArr) {
        if ([postDic objectForKey:key]) {
            [mArr addObject:[postDic objectForKey:key]];
        }
    }
    [mArr addObject:DES_KEY];
    return mArr;
}

- (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (NSString*)getSign:(NSArray*)array {
    NSString *sign_base = @"";
    for (int i=0; i<array.count; i++) {
        NSString *str = [array objectAtIndex:i];
        if(![str isKindOfClass:[NSString class]]){
            str = [NSString stringWithFormat:@"%@",str];
        }
        if (str && str.length >= 1) {
            sign_base = [NSString stringWithFormat:@"%@%@",sign_base,str];
        }
    }

    sign_base = [self getMd5_32Bit_String:sign_base];
    return sign_base;
}


- (NSMutableDictionary *)decodeRequstData:(NSDictionary*)dic{


    NSString *base64Str  = [dic objectForKey:@"data"];
    NSString *jsonStr= [self decodeData:base64Str];
    
    NSDictionary *decodeDic = [jsonStr  mj_JSONObject];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:decodeDic];
    
    return result;
    
}

@end
