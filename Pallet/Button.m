//
//  Button.m
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "Button.h"
#import "TargetActionHandler.h"

@implementation Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        handler = [[TargetActionHandler alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [handler release];
    [super dealloc];
}

- (void)sendAction:(int)event
{
    [handler sendAction:event sender:self];
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event
{
    [handler setTarget:target action:action forEvent:event];
}

@end
