//
//  Pallet.h
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TargetActionHandler;
@class CALayer;

@interface Pallet : UIView {
    TargetActionHandler *handler;
    
    CALayer *selectedLayer;
    CALayer *lastLayer;
    
    //UIView *lastView;
    //UIView *selectedView;
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event;
- (UIColor*)selectedColor;

@end

enum {
    PalletEvent_Touched,  // 指が触れた
    PalletEvent_ValueChanged,  // 色が変わった
    PalletEvent_Released  // 指が離れた
};
