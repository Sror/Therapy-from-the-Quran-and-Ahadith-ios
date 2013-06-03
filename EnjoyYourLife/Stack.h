//
//  Stack.h
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 3/22/13.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HsuStack : NSObject {
    NSMutableArray* m_array;
    int count;
}
- (void)push:(id)anObject;
- (id)pop;
- (id)top;
- (void)clear;
- (BOOL) isEmpty;
@property (nonatomic, readonly) int count;
@end