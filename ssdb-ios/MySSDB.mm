//
//  MySSDB.m
//  ssdb-ios
//
//  Created by ideawu on 8/7/15.
//  Copyright (c) 2015 ideawu. All rights reserved.
//

#import "MySSDB.h"
#import "ssdb/ssdb.h"

@interface MySSDB ()
@property (nonatomic) SSDB *ssdb;
@end

@implementation MySSDB

+ (MySSDB *)open:(NSString *)path{
	if([path characterAtIndex:0] != '/'){
		path = [NSString stringWithFormat:@"Documents/%@", path];
		path = [NSHomeDirectory() stringByAppendingPathComponent:path];
	}
	Options opt;
	opt.compression = "yes";

	MySSDB *my = [[MySSDB alloc] init];
	my.ssdb = SSDB::open(opt, path.UTF8String);
	if(!my.ssdb){
		return nil;
	}
	return my;
}

- (void)close{
	delete _ssdb;
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

@end
