//
//  SSDB.h
//  ssdb-ios
//
//  Created by mysteriouss on 21/08/2018.
//  Copyright (c) 2018 mysteriouss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSDB : NSObject

+ (SSDB *)shared;

- (BOOL)set:(NSString *)key string:(NSString *)string;
- (BOOL)set:(NSString *)key data:(NSData *)data;
/**
 * found:		ret == YES & string != nil
 * not_found:	ret == YES & string == nil
 * error:		ret == NO
 */
- (BOOL)get:(NSString *)key string:(NSString **)string;
- (BOOL)get:(NSString *)key data:(NSData **)data;
- (BOOL)del:(NSString *)key;

- (BOOL)hset:(NSString *)table key:(NSString *)key data:(NSData *)data;
- (BOOL)hset:(NSString *)table key:(NSString *)key string:(NSString *)string;

- (BOOL)hget:(NSString *)table key:(NSString *)key data:(NSData **)data;
- (BOOL)hget:(NSString *)table key:(NSString *)key string:(NSString **)string;

- (NSInteger)hsize:(NSString *)table;
- (BOOL)hclear:(NSString *)table;

- (BOOL)set:(NSString *)key json:(id)objc;
- (BOOL)set:(NSString *)key coding:(id)objc;

- (BOOL)hset:(NSString *)table key:(NSString *)key json:(id)objc;
- (BOOL)hset:(NSString *)table key:(NSString *)key coding:(id)objc;

@end

#import "SSDB+Extension.h"
