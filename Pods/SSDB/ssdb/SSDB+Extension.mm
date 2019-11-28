//
//  SSDB+Extension.m
//  ssdb-ios
//
//  Created by mysteriouss on 21/08/2018.
//  Copyright (c) 2018 mysteriouss. All rights reserved.
//

#import "SSDB+Extension.h"
#import "ssdb/ssdb_impl.h"
using namespace std;

@interface SSDB ()
@property (nonatomic) SSDBImpl *ssdb;
@end

@implementation SSDB (extension)

#pragma mark - set

- (void)setDataValue:(id)aValue forKey:(NSString *)aKey{
	
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return;
	}
	
	NSData * data = aValue;
	if (!data) {
		return;
	}
	
	string k(aKey.UTF8String);
	string v((const char*)data.bytes, data.length);
	self.ssdb->set(k, v);
}

- (void)setStringValue:(NSString *)aStr forKey:(NSString *)aKey{
	if (!aStr) {
		[self del:aKey];
	}
	else if ([aKey isKindOfClass:[NSString class]]) {
		[self setDataValue:[aStr dataUsingEncoding:NSUTF8StringEncoding] forKey:aKey];
	}
}

- (void)setJsonValue:(id)objc forKey:(NSString *)aKey{
	if (!objc) {
		[self del:aKey];
	}
	else{
		[self setDataValue:[NSJSONSerialization dataWithJSONObject:objc options:kNilOptions error:nil] forKey:aKey];
	}
}

- (void)setCodingValue:(id)coder forKey:(NSString *)aKey{
	if (!coder) {
		[self del:aKey];
	}
	else if ([coder conformsToProtocol:@protocol(NSCoding)]) {
		[self setDataValue:[NSKeyedArchiver archivedDataWithRootObject:coder] forKey:aKey];
	}
}

#pragma mark - hset

- (void)hSet:(NSString *)table codingValue:(id)aValue forKey:(NSString *)aKey{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	if ([aValue conformsToProtocol:@protocol(NSCoding)]) {
		[self hSet:table dataValue:[NSKeyedArchiver archivedDataWithRootObject:aValue] forKey:aKey];
	}
}

- (void)hSet:(NSString *)table jsonValue:(id)aValue forKey:(NSString *)aKey{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	if ([aValue isKindOfClass:[NSArray class]] || [aValue isKindOfClass:[NSDictionary class]]) {
		[self hSet:table dataValue:[NSJSONSerialization dataWithJSONObject:aValue options:kNilOptions error:nil] forKey:aKey];
	}
}

- (void)hSet:(NSString *)table dataValue:(id)aValue forKey:(NSString *)aKey{
	
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return;
	}
	
	NSData * data = aValue;
	if (!data) {
		return;
	}
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	string value((const char*)data.bytes, data.length);
	
	self.ssdb->hset(name, key, value);
}

- (void)hSet:(NSString *)table stringValue:(NSString *)aValue forKey:(NSString *)aKey{
	if ([aValue isKindOfClass:[NSString class]]) {
		NSData *data = [aValue dataUsingEncoding:NSUTF8StringEncoding];
		[self hSet:table dataValue:data forKey:aKey];
	}
}

#pragma mark - multi_hset

- (void)hMSet:(NSString *)table dataValue:(NSDictionary *)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	
	if (![aValue isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
	for (NSString * key in aValue.allKeys) {
		[self hSet:table dataValue:[aValue objectForKey:key] forKey:key];
	}
}

- (void)hMSet:(NSString *)table stringValue:(NSDictionary *)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	
	if (![aValue isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
	for (NSString * key in aValue.allKeys) {
		[self hSet:table stringValue:[aValue objectForKey:key] forKey:key];
	}
}

- (void)hMSet:(NSString *)table codingValue:(NSDictionary *)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	
	if (![aValue isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
	for (NSString * key in aValue.allKeys) {
		[self hSet:table codingValue:[aValue objectForKey:key] forKey:key];
	}
}

- (void)hMSet:(NSString *)table jsonValue:(NSDictionary *)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	
	if (![aValue isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
	for (NSString * key in aValue.allKeys) {
		[self hSet:table jsonValue:[aValue objectForKey:key] forKey:key];
	}
}


#pragma mark - queue

- (NSUInteger)qPush:(NSString *)table Value:(id)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return 0;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return 0;
	}
	
	NSData * data = aValue;
	if (!data) {
		return 0;
	}
	
	string name(table.UTF8String);
	string value((const char*)data.bytes, data.length);
	NSUInteger count = (NSUInteger)self.ssdb->qpush_back(name, value);
	return count;
}

- (NSUInteger)qPushFront:(NSString *)table Value:(NSData *)aValue{
	if (![table isKindOfClass:[NSString class]]) {
		return 0;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return 0;
	}
	
	NSData * data = aValue;
	if (!data) {
		return 0;
	}
	
	string name(table.UTF8String);
	string value((const char*)data.bytes, data.length);
	NSUInteger count = (NSUInteger)self.ssdb->qpush_front(name, value);
	return count;
}

- (void)qSet:(NSString *)table Value:(id)aValue atIndex:(NSInteger)index{
	if (![table isKindOfClass:[NSString class]]) {
		return ;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return ;
	}
	
	NSData * data = aValue;
	if (!data) {
		return ;
	}
	
	string name(table.UTF8String);
	string value((const char*)data.bytes, data.length);
	self.ssdb->qset(name, index, value);
}

#pragma mark - zset

- (void)zSet:(NSString *)table dataValue:(NSData *)aValue forKey:(NSString *)aKey{
	
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	if (![aValue isKindOfClass:[NSData class]]) {
		return;
	}
	
	NSData * data = aValue;
	if (!data) {
		return;
	}
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	string value((const char*)data.bytes, data.length);
	self.ssdb->zset(name, key, value);
}

- (void)zSet:(NSString *)table numberValue:(id)aValue forKey:(NSString *)aKey{
	if ([aValue isKindOfClass:[NSString class]]) {
		NSData *data = [(NSString *)aValue dataUsingEncoding:NSUTF8StringEncoding];
		[self zSet:table dataValue:data forKey:aKey];
	}else if ([aValue isKindOfClass:[NSNumber class]]){
		aValue = [NSString stringWithFormat:@"%@",aValue];
		NSData *data = [(NSString *)aValue dataUsingEncoding:NSUTF8StringEncoding];
		[self zSet:table dataValue:data forKey:aKey];
	}
}

#pragma mark - get

- (id)dataValueForKey:(NSString *)aKey{
	
	if (![aKey isKindOfClass:[NSString class]]) {
		return nil;
	}
	string key(aKey.UTF8String);
	string value;
	
	self.ssdb->get(key, &value);
	
	if(value.length()){
		return [NSData dataWithBytes:value.c_str() length:value.length()];
	}
	return nil;
}

- (NSString *)stringValueForKey:(NSString *)aKey{
	NSData * data = [self dataValueForKey:aKey];
	if (data) {
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
	}
	return @"";
}

- (id)jsonValueForKey:(NSString *)aKey{
	NSData * data = [self dataValueForKey:aKey];
	if (data) {
		return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	}
	return nil;
}

- (id)codingValueForKey:(NSString *)aKey{
	NSData * data = [self dataValueForKey:aKey];
	if (data) {
		return [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	return nil;
}

#pragma mark - hget

- (id)hGetData:(NSString *)table forKey:(NSString *)aKey{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	string value;
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	
	self.ssdb->hget(name, key, &value);
	
	if(value.length()){
		return [NSData dataWithBytes:value.c_str() length:value.length()];
	}
	return nil;
}

- (NSString *)hGetString:(NSString *)table forKey:(NSString *)aKey{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	string value;
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	
	self.ssdb->hget(name, key, &value);
	
	if(value.length()){
		return [NSString stringWithUTF8String:value.c_str()];
	}
	return @"";
}

- (id)hGetJson:(NSString *)table forKey:(NSString *)aKey{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	string value;
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	
	self.ssdb->hget(name, key, &value);
	
	if(value.length()){
		NSData *data = [NSData dataWithBytes:value.c_str() length:value.length()];
		if (data) {
			NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
			if ([dic isKindOfClass:[NSDictionary class]]) {
				return  [NSMutableDictionary dictionaryWithDictionary:dic];
			}else{
				return dic;
			}
		}
	}
	return nil;
}

- (id)hGetCoding:(NSString *)table forKey:(NSString *)aKey{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	if (![aKey isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	string value;
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	
	self.ssdb->hget(name, key, &value);
	
	if(value.length()){
		NSData *data = [NSData dataWithBytes:value.c_str() length:value.length()];
		if (data) {
			return [NSKeyedUnarchiver unarchiveObjectWithData:data];
		}
	}
	return nil;
}

#pragma mark - hget all

- (NSMutableDictionary *)hGetAllData:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do {
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSData *value = [NSData dataWithBytes:iterator->val.c_str() length:iterator->val.length()];
			if (key && value) {
				dic[key] = value;
			}
		}
	}while(iterator->next());
	return dic;
}

- (NSMutableDictionary *)hGetAllString:(NSString *)table{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSString *value = [NSString stringWithUTF8String:iterator->val.c_str()];
			dic[key] = value;
		}
	}while(iterator->next());
	return dic;
}

- (NSMutableDictionary *)hGetAllCoding:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do {
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSData *value = [NSData dataWithBytes:iterator->val.c_str() length:iterator->val.length()];
			if (key && value) {
				dic[key] = [NSKeyedUnarchiver unarchiveObjectWithData:value];
			}
		}
	}while(iterator->next());
	return dic;
}

- (NSMutableDictionary *)hGetAllJson:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do {
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSData *value = [NSData dataWithBytes:iterator->val.c_str() length:iterator->val.length()];
			if (key && value) {
				NSDictionary *info =  [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
				if ([info isKindOfClass:[NSDictionary class]]) {
					dic[key] = info.mutableCopy;
				}else{
					dic[key] = info;
				}
			}
		}
	}while(iterator->next());
	return dic;
}

#pragma mark - queue

- (NSMutableArray *)qRange:(NSString *)table from:(NSInteger)offset limit:(NSUInteger)count{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	string name(table.UTF8String);
	
	NSUInteger size = (NSUInteger)self.ssdb->qsize(name);
	NSMutableArray *values = [NSMutableArray array];
	if (offset >= 0) {
		string value;
		for(NSInteger i = offset; i < MIN(offset + count, size) ; i++){
			self.ssdb->qget(name, i, &value);
			if(value.length()){
				id object = [NSData dataWithBytes:value.c_str() length:value.length()];
				if (object) {
					[values addObject:object];
				}else{
					NSLog(@"%s-1",__FUNCTION__);
				}
			}
		}
	}else{
		string value;
		for (NSInteger i = offset; i > MAX(offset - count, -size-1); i--) {
			self.ssdb->qget(name, i, &value);
			if(value.length()){
				id object = [NSData dataWithBytes:value.c_str() length:value.length()];
				if (object) {
					[values insertObject:object atIndex:0] ;
				}else{
					NSLog(@"%s-2",__FUNCTION__);
				}
			}
		}
	}
	return values;
}

- (NSMutableArray *)qPop:(NSString *)table from:(NSInteger)offset limit:(NSUInteger)count{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	string name(table.UTF8String);
	NSUInteger size = (NSUInteger)self.ssdb->qsize(name);
	NSMutableArray *values = [NSMutableArray array];
	if (offset >= 0) {
		string value;
		for(NSInteger i = offset; i < MIN(offset + count, size) ; i++){
			self.ssdb->qpop_front(name, &value);
			if(value.length()){
				id object = [NSData dataWithBytes:value.c_str() length:value.length()];
				if (object) {
					[values addObject:object];
				}else{
					NSLog(@"%s-1",__FUNCTION__);
				}
			}
		}
	}else{
		string value;
		for (NSInteger i = offset; i > MAX(offset - count, -size-1); i--) {
			self.ssdb->qpop_back(name, &value);
			if(value.length()){
				id object = [NSData dataWithBytes:value.c_str() length:value.length()];
				if (object) {
					[values insertObject:object atIndex:0] ;
				}else{
					NSLog(@"%s-2",__FUNCTION__);
				}
			}
		}
	}
	return values;
}

#pragma mark - zset

- (NSMutableArray *)zScan:(NSString *)table keyStart:(NSString *)key scoreStart:(NSString *)start scoreEnd:(NSString *)end limit:(NSInteger)count{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	if (![start isKindOfClass:[NSString class]] &&
		![start isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	if (![end isKindOfClass:[NSString class]] &&
		![end isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	
	if (![key isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	if ([start isKindOfClass:[NSNumber class]]) {
		start = [NSString stringWithFormat:@"%@",start];
	}
	
	if ([end isKindOfClass:[NSNumber class]]) {
		end = [NSString stringWithFormat:@"%@",end];
	}
	
	string name(table.UTF8String);
	string keystart(key.UTF8String);
	string scorestart(start.UTF8String);
	string scoreend(end.UTF8String);
	
	NSMutableArray *array = [NSMutableArray array];
	
	ZIterator *iterator = self.ssdb->zscan(name, keystart, scorestart, scoreend, count);
	do{
		if (iterator && iterator->key.length() && iterator->score.length()) {
			
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSString *value = [NSString stringWithUTF8String:iterator->score.c_str()];
			NSMutableDictionary * dic = [NSMutableDictionary dictionary];
			dic[key] = value;
			[array addObject:dic];
		}
	}while(iterator->next());
	
	return array;
}

- (NSMutableArray *)zrScan:(NSString *)table keyStart:(NSString *)key scoreStart:(NSString *)start scoreEnd:(NSString *)end limit:(NSUInteger)count{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	if (![start isKindOfClass:[NSString class]] &&
		![start isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	if (![end isKindOfClass:[NSString class]] &&
		![end isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	
	if (![key isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	if ([start isKindOfClass:[NSNumber class]]) {
		start = [NSString stringWithFormat:@"%@",start];
	}
	
	if ([end isKindOfClass:[NSNumber class]]) {
		end = [NSString stringWithFormat:@"%@",end];
	}

	string name(table.UTF8String);
	string keystart(key.UTF8String);
	string scorestart(start.UTF8String);
	string scoreend(end.UTF8String);
	
	NSMutableArray *array = [NSMutableArray array];
	
	ZIterator *iterator = self.ssdb->zrscan(name, keystart, scorestart, scoreend, count);
	do{
		if (iterator && iterator->key.length() && iterator->score.length()) {
			
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSString *value = [NSString stringWithUTF8String:iterator->score.c_str()];
			NSMutableDictionary * dic = [NSMutableDictionary dictionary];
			dic[key] = value;
			[array addObject:dic];
		}
	}while(iterator->next());
	
	return array;
	
}

#pragma mark - size

- (NSInteger)hSize:(NSString *)table{
	string name(table.UTF8String);
	NSInteger size = (NSInteger)self.ssdb->hsize(name);
	return size;
}

- (NSInteger)qSize:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return -1;
	}
	
	string name(table.UTF8String);
	NSInteger size = (NSInteger)self.ssdb->qsize(name);
	
	return size;
}

- (NSInteger)zSize:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return -1;
	}
	
	string name(table.UTF8String);
	NSInteger size = (NSInteger)self.ssdb->zsize(name);
	
	return size;
}

#pragma mark - del/clear

- (void)hDel:(NSString *)table Key:(NSString *)aKey{
	
	if (![table isKindOfClass:[NSString class]]) {
		return;
	}
	
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	
	string name(table.UTF8String);
	string key(aKey.UTF8String);
	self.ssdb->hdel(name, key);
	
}

- (void)hClear:(NSString *)aKey{
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	string key(aKey.UTF8String);
	self.ssdb->hclear(key);
}

- (void)qClear:(NSString *)aKey{
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	string key(aKey.UTF8String);
	unsigned long size = [self qSize:aKey];
	string value;
	for (int i = 0; i < size; i++) {
		self.ssdb->qpop_front(key, &value);
	}
}

- (void)zClear:(NSString *)aKey{
	
	if (![aKey isKindOfClass:[NSString class]]) {
		return;
	}
	string key(aKey.UTF8String);
	
	ZIterator *iterator =  self.ssdb->zscan(key, "", "", "", -1);
	do{
		if (iterator && iterator->key.length() && iterator->score.length()) {
			self.ssdb->zdel(key, iterator->key);
		}
	}while(iterator->next());
}

#pragma mark - others

- (NSMutableDictionary *)hGetString:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	HIterator *iterator = ascending? self.ssdb->hscan(name, "", "", count) : self.ssdb->hrscan(name, "", "", count);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSString *value = [NSString stringWithUTF8String:iterator->val.c_str()];
			dic[key] = value;
		}
	}while(iterator->next());
	return dic;
}


- (NSMutableArray *)hGetAllStringSortedKey:(NSString *)table{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			[array addObject:key];
		}
	}while(iterator->next());
	return array;
	
}

- (NSMutableArray *)hGetAllStringSortedKeyReverse:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hrscan(name, "", "", -1);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			[array addObject:key];
		}
	}while(iterator->next());
	return array;
}

- (NSMutableArray *)hGetAllStringSortedValue:(NSString *)table{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	HIterator *iterator = self.ssdb->hscan(name, "", "", -1);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *value = [NSString stringWithUTF8String:iterator->val.c_str()];
			[array addObject:value];
		}
	}while(iterator->next());
	return array;
}

- (NSMutableArray *)hGetStringSortedKey:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	HIterator *iterator = ascending? self.ssdb->hscan(name, "", "", count) : self.ssdb->hrscan(name, "", "", count);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			if (!ascending) {
				[array insertObject:key atIndex:0];
			}else{
				[array addObject:key];
			}
		}
	}while(iterator->next());
	return array;
}
- (NSMutableArray *)hGetStringSortedValue:(NSString *)table limit:(NSInteger)count ascending:(BOOL)ascending{
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	
	HIterator *iterator = ascending? self.ssdb->hscan(name, "", "", count) : self.ssdb->hrscan(name, "", "", count);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *value = [NSString stringWithUTF8String:iterator->val.c_str()];
			if (!ascending) {
				[array insertObject:value atIndex:0];
			}else{
				[array addObject:value];
			}
		}
	}while(iterator->next());
	return array;
}

- (NSMutableArray *)hGetStringSortedKey:(NSString *)table limit:(NSInteger)count descending:(BOOL)descending{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	HIterator *iterator = !descending? self.ssdb->hscan(name, "", "", count) : self.ssdb->hrscan(name, "", "", count);
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			if (descending) {
				[array addObject:key];
			}else{
				[array insertObject:key atIndex:0];
			}
		}
	}while(iterator->next());
	return array;
	
}
- (NSMutableArray *)hGetStringSortedValue:(NSString *)table limit:(NSInteger)count descending:(BOOL)descending{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSMutableArray * array = [NSMutableArray array];
	string name(table.UTF8String);
	
	HIterator *iterator = !descending? self.ssdb->hscan(name, "", "", count) : self.ssdb->hrscan(name, "", "", count);
	
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *value = [NSString stringWithUTF8String:iterator->val.c_str()];
			if (descending) {
				[array addObject:value];
			}else{
				[array insertObject:value atIndex:0];
			}
		}
	}while(iterator->next());
	return array;
	
}

- (NSMutableDictionary *)hGetSortedJson:(NSString *)table limit:(NSInteger)count from:(NSString *)key ascending:(BOOL)ascending{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	if (![key isKindOfClass:[NSString class]] || !key.length) {
		key = @"";
	}
	NSMutableDictionary * dic = [NSMutableDictionary dictionary];
	string name(table.UTF8String);
	HIterator *iterator = ascending ? self.ssdb->hscan(name, key.UTF8String, "", count) : self.ssdb->hrscan(name, "", key.UTF8String, count);
	do {
		if (iterator && iterator->key.length() && iterator->val.length()) {
			NSString *key = [NSString stringWithUTF8String:iterator->key.c_str()];
			NSData *value = [NSData dataWithBytes:iterator->val.c_str() length:iterator->val.length()];
			if (key && value) {
				NSDictionary *info =  [NSJSONSerialization JSONObjectWithData:value options:kNilOptions error:nil];
				if ([info isKindOfClass:[NSDictionary class]]) {
					dic[key] = info.mutableCopy;
				}else{
					dic[key] = info;
				}
			}
		}
	}while(iterator->next());
	return dic;
}

- (NSString *)hGetFirstKey:(NSString *)table ascending:(BOOL)ascending{
	
	if (![table isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSString *key = nil;
	string name(table.UTF8String);
	HIterator *iterator = ascending? self.ssdb->hscan(name, "", "", 1) : self.ssdb->hrscan(name, "", "", 1);
	
	do{
		if (iterator && iterator->key.length() && iterator->val.length()) {
			key = [NSString stringWithUTF8String:iterator->key.c_str()];
		}else{
			//NSLog(@"%s,%@,%@",__FUNCTION__,@(iterator->key.length()),@(iterator->val.length()));
		}
	}while(!key && iterator->next());
	
	return key;
	
}

@end
