//
//  MySSDB+Extension.h
//  ssdb-ios
//
//  Created by mysteriouss on 21/11/2017.
//  Copyright © 2017 mysteriouss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySSDB.h"

@interface MySSDB (extension)

#pragma mark - set

- (void)setDataValue:(NSData *)aValue forKey:(NSString *)aKey;
- (void)setStringValue:(NSString *)aStr forKey:(NSString *)aKey;
- (void)setCodingValue:(id)coder forKey:(NSString *)aKey;
- (void)setJsonValue:(id)objc forKey:(NSString *)aKey;

#pragma mark - hset

- (void)hSet:(NSString *)table codingValue:(id)aValue forKey:(NSString *)aKey;
- (void)hSet:(NSString *)table jsonValue:(id)aValue forKey:(NSString *)aKey;
- (void)hSet:(NSString *)table dataValue:(NSData *)aValue forKey:(NSString *)aKey;
- (void)hSet:(NSString *)table stringValue:(NSString *)aValue forKey:(NSString *)aKey;

#pragma mark - multi_hset

- (void)hMSet:(NSString *)table dataValue:(NSDictionary *)aValue;
- (void)hMSet:(NSString *)table stringValue:(NSDictionary *)aValue;
- (void)hMSet:(NSString *)table codingValue:(NSDictionary *)aValue;
- (void)hMSet:(NSString *)table jsonValue:(NSDictionary *)aValue;

#pragma mark - queue

- (NSUInteger)qPush:(NSString *)table Value:(NSData *)aValue;
- (NSUInteger)qPushFront:(NSString *)table Value:(NSData *)aValue;
- (void)qSet:(NSString *)table Value:(NSData *)aValue atIndex:(NSInteger)index;

- (NSMutableArray *)qRange:(NSString *)table from:(NSInteger)offset limit:(NSUInteger)count;
- (NSMutableArray *)qPop:(NSString *)table from:(NSInteger)offset limit:(NSUInteger)count;


#pragma mark - zset

- (void)zSet:(NSString *)table dataValue:(NSData *)aValue forKey:(NSString *)aKey;
- (void)zSet:(NSString *)table numberValue:(id)aValue forKey:(NSString *)aKey;

- (NSMutableArray *)zScan:(NSString *)table keyStart:(NSString *)key scoreStart:(id)start scoreEnd:(id)end limit:(NSInteger)count;
- (NSMutableArray *)zrScan:(NSString *)table keyStart:(NSString *)key scoreStart:(id)start scoreEnd:(id)end limit:(NSUInteger)count;

#pragma mark - get

- (id)dataValueForKey:(NSString *)akey;
- (NSString *)stringValueForKey:(NSString *)aKey;
- (id)jsonValueForKey:(NSString *)aKey;
- (id)codingValueForKey:(NSString *)aKey;

#pragma mark - hget

- (NSData *)hGetData:(NSString *)table forKey:(NSString *)aKey;
- (NSString *)hGetString:(NSString *)table forKey:(NSString *)aKey;
- (id)hGetJson:(NSString *)table forKey:(NSString *)aKey;
- (id)hGetCoding:(NSString *)table forKey:(NSString *)aKey;

#pragma mark - hget all

- (NSMutableDictionary *)hGetAllData:(NSString *)table;
- (NSMutableDictionary *)hGetAllString:(NSString *)table;
- (NSMutableDictionary *)hGetAllJson:(NSString *)table;
- (NSMutableDictionary *)hGetAllCoding:(NSString *)table;

#pragma mark - size

- (NSInteger)hSize:(NSString *)table;
- (NSInteger)qSize:(NSString *)table;

#pragma mark - del/clear

- (void)hDel:(NSString *)table Key:(NSString *)akey;
- (void)hClear:(NSString *)key;
- (void)qClear:(NSString *)key;
- (void)zClear:(NSString *)key;

#pragma mark - others

- (NSMutableDictionary *)hGetString:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending;

- (NSMutableArray *)hGetAllStringSortedKey:(NSString *)table;
- (NSMutableArray *)hGetAllStringSortedKeyReverse:(NSString *)table;
- (NSMutableArray *)hGetAllStringSortedValue:(NSString *)table;

- (NSMutableArray *)hGetStringSortedKey:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending;
- (NSMutableArray *)hGetStringSortedValue:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending;

- (NSMutableArray *)hGetStringSortedKey:(NSString *)table limit:(NSInteger)count descending:(BOOL)descending;
- (NSMutableArray *)hGetStringSortedValue:(NSString *)table limit:(NSInteger)count descending:(BOOL)descending;

- (NSMutableDictionary *)hGetSortedJson:(NSString *)table limit:(NSInteger)count from:(NSString *)key ascending:(BOOL)ascending;

- (NSString *)hGetFirstKey:(NSString *)table ascending:(BOOL)ascending;


@end
