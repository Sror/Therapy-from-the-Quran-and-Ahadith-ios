//
//  Stack.m
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 3/22/13.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import "Stack.h"

@implementation HsuStack
@synthesize count;
- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}
- (void)push:(id)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
}
-(id)top
{
       id obj = nil;
    if(m_array.count > 0)
    {
        obj = [m_array lastObject];
        
    }
    return obj;
    
}
- (id)pop
{
    id obj = nil;
    if(m_array.count > 0)
    {
        obj = [m_array lastObject];
        [m_array removeLastObject];
        count = m_array.count;
    }
    return obj;
}
- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}
- (BOOL)isEmpty{
    if(count == 0)
        return YES;
    else
        return NO;
}
@end
