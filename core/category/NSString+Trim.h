//
//  NSString+Trim.h
//  FloraCore
//
//  Created by Fu Jiaming on 2018/10/12.
//  Copyright © 2018年 Fu Jiaming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Trim)
+ (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet;
//去掉前后空格
+ (NSString *)trimWhitespace:(NSString *)val;
//去掉前后回车符
+ (NSString *)trimNewline:(NSString *)val;
//去掉前后空格和回车符
+ (NSString *)trimWhitespaceAndNewline:(NSString *)val;
@end

NS_ASSUME_NONNULL_END
