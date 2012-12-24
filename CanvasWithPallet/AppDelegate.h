//
//  AppDelegate.h
//  CanvasWithPallet
//
//  Created by 古川 涼太 on 12/10/31.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CanvasView;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CanvasView *canvasview;
    UISlider *slider;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) CanvasView *canvasview;

@end
