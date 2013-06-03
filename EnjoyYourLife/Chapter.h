//
//  Chapter.h
//  TestCoreText
//
//  Created by ahadnawaz on 14/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject
@property (strong,nonatomic) NSString *chapterTitle,*paraSummary;
@property (nonatomic) int chID;
@property (nonatomic) int isRead;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * searchText;

@end
