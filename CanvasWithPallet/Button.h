//
//  Button.h
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TargetActionHandler;

@interface Button : UIView {
    NSMutableDictionary *targetAndActionDic;
    
    TargetActionHandler *handler;
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event;

@end
