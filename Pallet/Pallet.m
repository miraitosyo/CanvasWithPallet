//
//  Pallet.m
//  Pallet
//
//  Created by 古川 涼太 on 12/10/30.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Pallet.h"
#import "TargetActionHandler.h"

@implementation Pallet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        handler = [[TargetActionHandler alloc] init];
        CGRect r = CGRectMake(0, 0, 44, 44);
        for (int i = 0; i < 7; i++) {
            
            CALayer *bt = [CALayer layer];
            bt.frame = r;
            bt.backgroundColor = [UIColor colorWithHue:(float)i / 7.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
            [self.layer addSublayer:bt];
            
            r = CGRectOffset(r, 0, r.size.height);
        }
        
        CALayer *bt = [CALayer layer];
        bt.frame = r;
        bt.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:bt];
    }
    return self;
}

- (void)dealloc
{
    [handler release];
    [super dealloc];
}

- (void)setTarget:(id)target action:(SEL)action forEvent:(int)event
{
    [handler setTarget:target action:action forEvent:event];
}

- (void)sendAction:(int)event
{
    [handler sendAction:event sender:self];
}

/*
- (void)select:(UIView*)view{
    if ((view == self) || (view == nil))
        view = lastView;
    
    if (selectedView == view)
        return;
    
    selectedView.alpha = 1.0;
    selectedView = view;
    selectedView.alpha = 0.5;
    
    [self sendAction:PalletEvent_ValueChanged];
}
*/

- (void)select:(CALayer*)layer
{
    if ((layer == self.layer) || (layer == nil))
        layer = lastLayer;
    
    if (selectedLayer == layer)
        return;
    
    selectedLayer.borderWidth = 0;
    selectedLayer = layer;
    selectedLayer.borderWidth = 4;
    
    [self sendAction:PalletEvent_ValueChanged];
}

- (CALayer*)hitLayer:(UITouch*)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint = [self.layer convertPoint:touchPoint toLayer:self.layer.superlayer];
    return [self.layer hitTest:touchPoint];
}

- (UIColor*)selectedColor
{
    
    if (selectedLayer)
        return [UIColor colorWithCGColor:selectedLayer.backgroundColor];
    
    return nil;
    
    //return selectedView.backgroundColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    lastLayer = selectedLayer;
    selectedLayer = nil;
    UITouch *touch = [touches anyObject];
    CALayer *layer = [self hitLayer:touch];
    [self select:layer];

    /*
    lastView = selectedView;
    selectedView = nil;
    UITouch *touch = [touches anyObject];
    UIView *view = [self hitTest:[touch locationInView:self] withEvent:event];
    [self select:view];
    */
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CALayer *layer = [self hitLayer:touch];
    [self select:layer];
    
    /*
    UITouch *touch = [touches anyObject];
    UIView *view = [self hitTest:[touch locationInView:self] withEvent:event];
    [self select:view];
    */
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CALayer *layer = [self hitLayer:touch];
    [self select:layer];
    selectedLayer.borderWidth = 0;
    
    /*
    UITouch *touch = [touches anyObject];
    UIView *view = [self hitTest:[touch locationInView:self] withEvent:event];
    [self select:view];
    selectedView.alpha = 1.0;
    */
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    selectedLayer.borderWidth = 0;
    
    //selectedView.alpha = 1.0;
}


@end
