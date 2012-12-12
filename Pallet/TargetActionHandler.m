//
//  TargetActionHandler.m
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "TargetActionHandler.h"

@interface TargetAndAction : NSObject {
    
@public
    id target;
    SEL action;
    
}

@end

@implementation TargetAndAction

@end

@implementation TargetActionHandler
- (id)init

{
    self = [super init];
    if (self) {
        targetAndActionDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [targetAndActionDic release];
    [super dealloc];
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event
{
    TargetAndAction *ta = [[[TargetAndAction alloc] init] autorelease];
    
    ta->target = target;
    ta->action = action;
    NSString *key = [NSString stringWithFormat:@"%d", event];
    [targetAndActionDic setObject:ta forKey:key];
}

- (void)sendAction:(int)event sender:(id)sender
{
    NSString *key = [NSString stringWithFormat:@"%d", event];
    TargetAndAction *ta = [targetAndActionDic objectForKey:key];
    if (ta) {
        [ta->target performSelector:ta->action withObject:sender];
    }
}

@end
