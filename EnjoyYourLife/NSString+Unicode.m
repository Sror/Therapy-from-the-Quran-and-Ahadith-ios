//
//  NSString+Unicode.m
//  CaptnCrunch
//
//  Created by Faiz Rasool on 2/28/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NSString+Unicode.h"

@implementation NSString (Unicode)

- (NSString *)stringToUnicode{
    NSMutableString * string = [NSMutableString string];
    int index;
    NSMutableString * subString = nil;
    for(index = 0; index < self.length; index++){
        UniChar ch = [self characterAtIndex:index];
        subString = [NSMutableString stringWithFormat:@"%0x",ch];
        switch (subString.length) {
            case 1:
                [subString insertString:@"000" atIndex:0];
                break;
            case 2:
                [subString insertString:@"00" atIndex:0];
                break;
            case 3:
                [subString insertString:@"0" atIndex:0];
                break;
            default:
                break;
        }
        [string appendFormat:@"%@",subString];
    }
    return [string uppercaseString];
}

- (NSString *)unicodeToString{
    NSMutableData * data = [NSMutableData data];
    NSString * string = nil;
    int index;
    for(index = 0; index+2 <= self.length; index+=2){
        NSRange range = NSMakeRange(index, 2);
        NSString * subString = [self substringWithRange:range];
        unsigned int integerVal;
        NSScanner * scanner = [NSScanner scannerWithString:subString];
        [scanner scanHexInt:&integerVal];
        [data appendBytes:&integerVal length:1];         
    }
    string = [[NSString alloc]initWithData:data encoding:NSUnicodeStringEncoding];
    return string;
}

@end
