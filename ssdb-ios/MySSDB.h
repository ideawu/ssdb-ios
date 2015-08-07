//
//  MySSDB.h
//  ssdb-ios
//
//  Created by ideawu on 8/7/15.
//  Copyright (c) 2015 ideawu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySSDB : NSObject

+ (MySSDB *)open:(NSString *)path;

- (void)close;

- (BOOL)set:(NSString *)key string:(NSString *)string;
- (BOOL)set:(NSString *)key data:(NSData *)data;
/**
 * found:     ret=YES & string != nil
 * not_found: ret=YES & string == nil
 * error:     ret=NO
 */
- (BOOL)get:(NSString *)key string:(NSString **)string;
- (BOOL)get:(NSString *)key data:(NSData **)data;
- (BOOL)del:(NSString *)key;
@end
