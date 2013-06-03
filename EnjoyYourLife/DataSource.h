//
//  DataSource.h
//  TestCoreText
//
//  Created by ahadnawaz on 13/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "EGODatabase.h"
#import "NSString+Unicode.h"
#import "Chapter.h"

@interface DataSource : NSObject
//@property (strong,nonatomic) EGODatabase *db;
@property (strong,nonatomic) Chapter *ch;
@property (strong,nonatomic) NSString *tbName;
@property (strong,nonatomic) NSMutableString *page;
@property (strong,nonatomic) NSMutableArray *toc;

//-(void) dbConnection:(NSString *)dbName;
-(void) tbName:(NSString *)tableName;
-(NSMutableArray *) TOC:(int)parentID;
-(NSMutableArray *) search:(NSString *)searchText;
-(NSString *) getSentence:(NSString *)para index:(int)i;
-(NSString *)createPage:(int)chID childId:(int)childID bit:(int)i;
-(NSString *) chapterTitle:(int)chid;
-(void)setBookPageNo:(int)bookId pageNo:(int)pno;
-(int)getBookPageNo:(int)bookId;
-(void)setChapterPageNo:(int)chID pageNo:(int)pno;
-(int)getChapterPageNo:(int)chID;
+(void)checkAndCreateDatabase;
+ (NSString*) getDatabasePath;
+ (DataSource*) sharedInstance;
-(int) currentChapterNo:(int) parentID;
-(int) prevChapterNo:(int) ID;
- (void) markChapterAsRead:(int)chID isRead:(int)read;
- (void) markAllChapterAsRead:(int)read bookId:(int)bookId;

-(int) UpdateNotes:(NSString*)notes ForChapterId:(int)chID;
-(int) AddNotes:(NSString*)notes ForChapterId:(int)chID;
- (NSString *) GetNotesForChapterId:(int)chID;
-(NSMutableArray *) getChapterID:(int)lowerBound uperBound:(int)uperBound isLast:(int)isLast;
-(int) maxId:(NSString *)tableName field:(NSString *)fieldName;
+(void)showAllert:(NSString*)message;
@end
