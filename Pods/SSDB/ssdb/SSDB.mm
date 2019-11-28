//
//  SSDB.m
//  ssdb-ios
//
//  Created by mysteriouss on 21/08/2018.
//  Copyright (c) 2018 mysteriouss. All rights reserved.
//

#import "SSDB.h"
#import "ssdb/ssdb_impl.h"

@interface SSDB ()
@property (nonatomic) SSDBImpl *ssdb;
@end

@implementation SSDB

+ (SSDB *)shared{
	static SSDB * _ssdb = nil;
	if (!_ssdb) {
		NSString *  db_path = [NSString stringWithFormat:@"Documents/db"];
		db_path = [NSHomeDirectory() stringByAppendingPathComponent:db_path];
		NSLog(@"%@",db_path);
		_ssdb = [[SSDB alloc] init];
		Options opt; opt.compression = "yes";
		_ssdb.ssdb = SSDBImpl::open(opt, db_path.UTF8String);
	}
	return _ssdb;
}

- (BOOL)set:(NSString *)key string:(NSString *)string{
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return [self set:key data:data];
}

- (BOOL)set:(NSString *)key data:(NSData *)data{
	std::string k(key.UTF8String);
	std::string v((const char*)data.bytes, data.length);
	int ret = _ssdb->set(k, v);
	if(ret == 0){
		return YES;
	}
	return NO;
}

- (BOOL)get:(NSString *)key string:(NSString **)string{
	NSData *data = nil;
	BOOL ret = [self get:key data:&data];
	if(ret && data != nil){
		*string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        *string = nil;
    }
	return ret;
}

- (BOOL)get:(NSString *)key data:(NSData **)data{
	std::string k(key.UTF8String);
	std::string v;
	int ret = _ssdb->get(k, &v);
	if(ret == 0){
		*data = nil;
		return YES;
	}else if(ret == 1){
		*data = [NSData dataWithBytes:(const void *)v.data() length:(NSUInteger)v.size()];
		return YES;
	}
	return NO;
}

- (BOOL)del:(NSString *)key{
	std::string k(key.UTF8String);
	int ret = _ssdb->del(k);
	if(ret == 0){
		return YES;
	}
	return NO;
}

#pragma mark - set

- (BOOL)set:(NSString *)key json:(id)objc{
	NSData *data = [NSJSONSerialization dataWithJSONObject:objc options:kNilOptions error:nil];
	if (data) {
		return [self set:key data:data];
	}
	return NO;
}
- (BOOL)set:(NSString *)key coding:(id)objc{
	if ([objc conformsToProtocol:@protocol(NSCoding)]) {
		return [self set:key data:[NSKeyedArchiver archivedDataWithRootObject:objc]];
	}
	return NO;
}

- (BOOL)hset:(NSString *)table key:(NSString *)key data:(NSData *)data{
	std::string t(table.UTF8String);
	std::string k(key.UTF8String);
	std::string v((const char*)data.bytes, data.length);
	int ret = _ssdb->hset(t, k, v);
	if(ret == 0){
		return YES;
	}
	return NO;
}

- (BOOL)hset:(NSString *)table key:(NSString *)key string:(NSString *)string{
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	return [self hset:table key:key data:data];
}

- (BOOL)hset:(NSString *)table key:(NSString *)key json:(id)objc{
	NSData *data = [NSJSONSerialization dataWithJSONObject:objc options:kNilOptions error:nil];
	if (data) {
		return [self hset:table key:key data:data];
	}
	return NO;
}
- (BOOL)hset:(NSString *)table key:(NSString *)key coding:(id)objc{
	if ([objc conformsToProtocol:@protocol(NSCoding)]) {
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objc];
		if (data) {
			return [self hset:table key:key data:data];
		}
	}
	return NO;
}


#pragma mark - get


- (BOOL)hget:(NSString *)table key:(NSString *)key string:(NSString **)string{
	NSData *data = nil;
	BOOL ret = [self hget:table key:key data:&data];
	if(ret && data != nil){
		*string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        *string = nil;
    }
	return ret;
}

- (BOOL)hget:(NSString *)table key:(NSString *)key data:(NSData **)data{
	std::string t(table.UTF8String);
	std::string k(key.UTF8String);
	std::string v;
	int ret = _ssdb->hget(t, k, &v);
	if(ret == 0){
		*data = nil;
		return YES;
	}else if(ret == 1){
		*data = [NSData dataWithBytes:(const void *)v.data() length:(NSUInteger)v.size()];
		return YES;
	}
	return NO;
}

- (NSInteger)hsize:(NSString *)table{
	std::string name(table.UTF8String);
	NSInteger size = (NSUInteger)_ssdb->hsize(name);
	return size;
}

- (BOOL)hclear:(NSString *)table{
	std::string name(table.UTF8String);
	int64_t ret = _ssdb->hclear(name);
	if(ret == 0){
		return YES;
	}
	return NO;
}


@end
