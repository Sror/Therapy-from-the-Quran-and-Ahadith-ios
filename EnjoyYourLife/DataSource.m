//
//  DataSource.m
//  TestCoreText
//
//  Created by ahadnawaz on 13/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
EGODatabaseResult *result;

static DataSource * dataSource;
static EGODatabase *db;

+ (DataSource*) sharedInstance{
    if(dataSource == nil){
        dataSource = [[DataSource alloc]init];
        db = [EGODatabase databaseWithPath:[DataSource getDatabasePath]];
    }
    return dataSource;
}


//-(void) dbConnection:(NSString *)dbName
//{
//    //creating db connection
//    NSString * path1 = [DataSource getDatabasePath];//[[NSBundle mainBundle ] pathForResource:dbName ofType:@"sqlite"];
//    self.db=[EGODatabase databaseWithPath:path1];
//   
//
//}

+(void)showAllert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)checkAndCreateDatabase {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFileName = [docDir stringByAppendingPathComponent:@"DTech.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSDictionary * attributes = [fileManager attributesOfItemAtPath:dbFileName error:nil];
    
    NSInteger fileSize = (NSInteger)[attributes objectForKey:NSFileSize];
    
    if (![fileManager fileExistsAtPath:dbFileName] || fileSize == 0) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"DTech" ofType:@"sqlite"];
        if(path != nil)
            [fileManager copyItemAtPath:path toPath:dbFileName error:&error];
        else {
            //NSLog(@"Failed to create database");
        }
    }
}
+ (NSString*) getDatabasePath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFileName = [docDir stringByAppendingPathComponent:@"DTech.sqlite"];
   // NSLog(@"%@",dbFileName);
    return dbFileName;
}
-(void)setBookPageNo:(int)bookId pageNo:(int)pno
{
    result=[db executeQuery:[NSString stringWithFormat: @"UPDATE book  SET page_no =%i where id=%i",pno,bookId]];
    
}
-(int)getBookPageNo:(int)bookId
{
    result=[db executeQuery:[NSString stringWithFormat: @"select page_no from book where id=%i",bookId]];
    int no=0;
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
        no=[row intForColumn:@"page_no"];
        
    }
    return no;
}
-(void)setChapterPageNo:(int)chID pageNo:(int)pno
{
    result=[db executeQuery:[NSString stringWithFormat: @"UPDATE CHAPTER  SET page_no =%i where id=%i",pno,chID]];
    
}
-(int)getChapterPageNo:(int)chID
{
    result=[db executeQuery:[NSString stringWithFormat: @"select page_no from Chapter where id=%i",chID]];
    int no=0;
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
        no=[row intForColumn:@"page_no"];
        
    }
    return no;
}

-(void) tbName:(NSString *)tableName
{
    self.tbName=tableName;
}
-(NSString *) chapterTitle:(int)chid
{
    result=[db executeQuery:[NSString stringWithFormat: @"Select title,offset from chapter where id=%i",chid]];//and id>=%i
    NSString *chTitle;
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
        chTitle=[row stringForColumn:@"title"];
//         int isPreface = [row intForColumn:@"preface"];
        chTitle=[chTitle unicodeToString];
//        if (isPreface !=1)
//            chTitle = [NSString stringWithFormat:@"Chapter \n%@\n",chTitle];
//        else
            chTitle = [NSString stringWithFormat:@"\n%@\n\n",chTitle];

    }
    return chTitle;
}

-(NSMutableArray *) search:(NSString *)searchText
{
    //this funtion is used for searching text in whole book
    
    searchText= [[NSString stringWithFormat:@" %@ ",searchText] lowercaseString];
    NSString *para_search=[searchText stringToUnicode];
    result=[db executeQuery:[NSString stringWithFormat: @"Select p.chapter_id,p.para_text,c.title from paragraph p,chapter c where LOWER(p.para_text) LIKE '%%%@%%' AND  p.chapter_id=c.id",para_search]];
    
    NSMutableArray *paragraphs=[[NSMutableArray alloc]init];
    if(result)
    {
        for (EGODatabaseRow *row in result) {
            
            NSString *whole_para=[row stringForColumn:@"para_text"];//stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange r = [whole_para rangeOfString:para_search ];// options:NSCaseInsensitiveSearch];
            
            
            if (!(r.location == NSNotFound))
            {
//                NSLog(@"You have searched ");
                self.ch=[[Chapter alloc]init];
                NSString *decoded=[whole_para unicodeToString];
                //              searchText= [NSString stringWithFormat:@"%@",searchText];
                NSRange r2 = [decoded rangeOfString:searchText];
                self.ch.chID=[row intForColumn:@"chapter_id"];
                self.ch.chapterTitle= [[row stringForColumn:@"title"] unicodeToString];
                self.ch.paraSummary=[self getSentence:decoded index:r2.location];// specific sentence
                self.ch.searchText = searchText;
                
                
                [paragraphs addObject:self.ch];
                
            }
        }
        
    }
    return paragraphs;
}

-(NSString *) getSentence:(NSString *)para index:(int)i
{
//    NSString * starting = [para substringToIndex:i];
//    return [NSString stringWithFormat:@"%@ %@", starting,[para substringFromIndex:i] ];
     return [para substringFromIndex:i] ;
    //    NSArray * words = [para componentsSeparatedByString:@" "];
    
    /*
    NSMutableString *sentence=[[NSMutableString alloc]init];
    int j=0;
    for(int c=i; c<para.length; c++)
    {
        char nextChar=[para characterAtIndex:c];
        if (nextChar!='.') {
            
            sentence=[NSString stringWithFormat:@"%@%c",sentence,nextChar];
            
        }
       else if (j<2)
            j++;
        else
            break;
        
    }
    j = 0;
    for(int c=i-1; c>=0; c--)
    {
        char prevChar=[para characterAtIndex:c];
        if (prevChar!=' ') {
            sentence=[NSString stringWithFormat:@"%c%@",prevChar,sentence];
            
        }
        else if (prevChar==' ' && j<2)
        {
            sentence=[NSString stringWithFormat:@"%c%@",prevChar,sentence];
            j++;
        }

        else
            break;
        
    }
    
    return sentence;
     */
}
-(int) currentChapterNo:(int) parentID
{
    if (parentID==0){
         result=[db executeQuery:[NSString stringWithFormat: @"Select id,title from chapter where parent_title =''"]];
        
    }
    else{
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,title from chapter where parent_title =%i",parentID]];
    }
    
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
 
        parentID = [row intForColumn:@"id"];
     }
    return parentID;
    
}
-(int) prevChapterNo:(int) ID
{
    result=[db executeQuery:[NSString stringWithFormat: @"Select parent_title from chapter where id =%i",ID]];
     
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
        
        //        self.ch=[[Chapter alloc]init];
        //        NSString *decod=[row stringForColumn:@"title"];// stringByReplacingOccurrencesOfString:@" " withString:@""];
        //        NSString *decoded=[decod unicodeToString];
        //        self.ch.chID=[row intForColumn:@"id"];
        ID = [row intForColumn:@"parent_title"];
        //        self.ch.chapterTitle=decoded;
        //        [self.toc addObject:self.ch];
        //
        //        NSLog(@" parent id = %i",parentID);
        //        [self TOC:parentID];
        
    }
    return ID;
    
}

-(NSMutableArray *) TOC:(int)parentID
{
    if (parentID==0){
        self.toc = [[NSMutableArray alloc]init];
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,title,is_read,image_name from chapter where parent_title =''"]];
        
    }
    else{
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,title,is_read,image_name from chapter where parent_title =%i",parentID]];
    }
    
    if (result.rows.count>0) {
        EGODatabaseRow *row=[result rowAtIndex:0];
        
        self.ch=[[Chapter alloc]init];
        NSString *decod=[row stringForColumn:@"title"];// stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *decoded=[decod unicodeToString];
        self.ch.chID=[row intForColumn:@"id"];
        parentID = self.ch.chID;
        self.ch.chapterTitle=decoded;
        self.ch.isRead = [row intForColumn:@"is_read"];
        self.ch.imageName = [row stringForColumn:@"image_name"];
        
        [self.toc addObject:self.ch];
        
       // NSLog(@" parent id = %i",parentID);
        [self TOC:parentID];
        
    }
    return self.toc;
    
}
//-(NSMutableArray *) TOC
//{
//    result=[db executeQuery:[NSString stringWithFormat:@"Select id,title from chapter  where parent_title "]];//@"Select id,title from %@ order by parent_title",self.tbName]];
//      
//    NSMutableArray *toc=[[NSMutableArray alloc]init];
//    if(result)
//    {
//        for (EGODatabaseRow *row in result) {
//              self.ch=[[Chapter alloc]init];
//            NSString *decod=[row stringForColumn:@"title"];// stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSString *decoded=[decod unicodeToString];
//            self.ch.chID=[row intForColumn:@"id"];
//            self.ch.chapterTitle=decoded;
//            [toc addObject:self.ch];
//            // NSLog(@"after decoding %@ \n\n",decoded);
//        }
//        
//        return toc;
//    }
//    return toc;
//    
//    
//}
-(NSString *)createPage:(int)chID childId:(int)childID bit:(int)i
{
    if (i==0){
         self.page=[[NSMutableString alloc]init];
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,para_text from paragraph where chapter_id=%i and para_id =''",chID]];
        i++;
    }
    else{
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,para_text from paragraph where chapter_id=%i and para_id =%i",chID,childID]];
    }
    if (result.rows.count>0) {
         EGODatabaseRow *row=[result rowAtIndex:0];
        NSString *decod=[[row stringForColumn:@"para_text"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *decoded=[decod unicodeToString];
        [self.page appendString:decoded];
        [self.page appendString:@"\n"];
        childID=[row intForColumn:@"id"];
        [self createPage:chID childId:childID bit:i];
            
    }
    
//  NSLog(@"page ==\n %@",self.page);
        return self.page;
    
}

-(int) AddNotes:(NSString*)notes ForChapterId:(int)chID{
    
    // check if notes for this chapter already exists    
    NSString * existsSql = [NSString stringWithFormat:@"SELECT EXISTS (SELECT notes_text FROM Notes WHERE chapter_id=%d)",chID];
    
    result = [db executeQuery:existsSql];
    if(result.rows > 0){
        EGODatabaseRow * row = [result.rows objectAtIndex:0];
        NSString* hasRow = [row.columnData objectAtIndex:0];
        
        if([hasRow intValue] == 1)
            return [self UpdateNotes:notes ForChapterId:chID];
        else{
//            NSDate *notesDate = [NSDate date];
//            
//            NSDateFormatter * df = [[NSDateFormatter alloc] init];
//            [df setDateStyle:NSDateFormatterMediumStyle];
//            NSString * dateString = [df stringFromDate:notesDate];
            NSString * sql = [NSString stringWithFormat:@"INSERT INTO Notes (notes_text, chapter_id) Values ('%@',%d)",notes,chID];
            result = [db executeQuery:sql];
        }
    }
    
    return result.errorCode;
}

-(int) UpdateNotes:(NSString*)notes ForChapterId:(int)chID{
//    NSDate *notesDate = [NSDate date];
    
//    NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    [df setDateStyle:NSDateFormatterMediumStyle];
//    NSString * dateString = [df stringFromDate:notesDate];
    
    NSString * sql = [NSString stringWithFormat:@"UPDATE Notes SET notes_text='%@' WHERE chapter_id=%d",notes,chID];
    result = [db executeQuery:sql];
    
    return result.errorCode;
}

- (NSString *) GetNotesForChapterId:(int)chID{
    NSString * sql = [NSString stringWithFormat:@"SELECT notes_text FROM Notes WHERE chapter_id=%d",chID];
    result = [db executeQuery:sql];
  //  int i=0;
  //  NSMutableArray *chapterNotes =[[NSMutableArray alloc]init];
    NSMutableString * notesStr = [NSMutableString string];
 //   notesStr = nil;
    for(EGODatabaseRow * row in result){
//        if(i==0){
//            i++;
            [notesStr appendString:[row stringForColumn:@"notes_text"]];
   //         [chapterNotes addObject:[row stringForColumn:@"notes_text"]];
  //          [chapterNotes addObject:[row stringForColumn:@"notes_date"]];
            //append date at start of notes
          // [notesStr appendString: [NSString stringWithFormat:@"%@\n",[row stringForColumn:@"notes_date"] ]];
             
//        }
        
      
    }
//    if(notesStr !=nil && notesStr.length>0)
//    [chapterNotes addObject:notesStr];
    return notesStr;
}

- (void) markChapterAsRead:(int)chID isRead:(int)read{
    NSString * sql = [NSString stringWithFormat:@"UPDATE Chapter SET is_read=%d WHERE id=%d",read,chID];
    result = [db executeQuery:sql];
}
- (void) markAllChapterAsRead:(int)read bookId:(int)bookId{
    NSString * sql = [NSString stringWithFormat: @"UPDATE Chapter SET is_read=%d WHERE id IN (Select c.id from Chapter c,Table_of_content toc where toc.book_id = %d and toc.chapter_id=c.id AND c.is_read = 1)",read,bookId];
    result = [db executeQuery:sql];
}
-(NSMutableArray *) getChapterID:(int)parentID uperBound:(int)uperBound isLast:(int)isLast
{
    int chID = 1,pageNo = 0,prevPageNo;
    EGODatabaseRow *row;
    NSMutableArray *chapterDetail =[[NSMutableArray alloc]init];
    
    if (isLast==1) {
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,page_no,parent_title from chapter where page_no = (Select Max(page_no) from chapter)"]];
        
        row=[result rowAtIndex:0];
        pageNo = [row intForColumn:@"page_no"];
        parentID = [row intForColumn:@"id"];

        [chapterDetail addObject:[NSNumber numberWithInt:parentID]];
        [chapterDetail addObject:[NSNumber numberWithInt:pageNo]];
        return chapterDetail;
    }
    
    while (true) {
        if(parentID ==0)
            result=[db executeQuery:[NSString stringWithFormat: @"Select id,page_no,parent_title from chapter where parent_title =''"]];
      else
        result=[db executeQuery:[NSString stringWithFormat: @"Select id,page_no,parent_title from chapter where parent_title =%i",parentID]];
       
    if (result.rows.count>0) {
         row=[result rowAtIndex:0];
        pageNo = [row intForColumn:@"page_no"];
        parentID = [row intForColumn:@"id"];
         
        if (pageNo >uperBound) {
            
            [chapterDetail addObject:[NSNumber numberWithInt:chID]];
            [chapterDetail addObject:[NSNumber numberWithInt:prevPageNo]];
            break;
          
            }
        prevPageNo = pageNo;
        chID = parentID;// [row intForColumn:@"id"];
        }
    }
    
  
 
//    NSString * sql = [NSString stringWithFormat:@"SELECT id,page_no from Chapter "];
//    result = [db executeQuery:sql];
//    int cID =1;
//    int prevChID = 1,pageNo,prevPagNo;
//    NSMutableArray *chapterDetail =[[NSMutableArray alloc]init];
//    
//     
//    if(result.rows > 0){
//        for (EGODatabaseRow *row in result) {
////        EGODatabaseRow * row = [result rowAtIndex:result.count-1];// objectAtIndex:result.count];
//            cID = [row intForColumn:@"id"];
//            pageNo = [row intForColumn:@"page_no"];
//            if (pageNo >uperBound) {
//                [chapterDetail addObject:[NSNumber numberWithInt:prevChID]];
//                [chapterDetail addObject:[NSNumber numberWithInt:prevPagNo]];
//                return chapterDetail;
//            }
//            prevChID = cID;
//            prevPagNo = pageNo;
//            
//      
//        }
//    }

    return chapterDetail;
}
-(int) maxId:(NSString *)tableName field:(NSString *)fieldName
{
    result=[db executeQuery:[NSString stringWithFormat: @"Select Max(%@) from %@",fieldName,tableName]];
    return [[result rowAtIndex:0] intForColumnIndex:0];
    
}
@end