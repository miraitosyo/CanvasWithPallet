//
//  TargetActionHandler.h
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetActionHandler : NSObject {
    NSMutableDictionary *targetAndActionDic;
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event;
- (void)sendAction:(int)event sender:(id)sender;

@end
