//
//  CanvasView.h
//  Canvas
//
//  Created by 古川 涼太 on 12/10/28.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface CanvasView : UIView<SRWebSocketDelegate> {
    UIImage *canvas;
    CGPoint curtPt;
    
    // WebSocket用インスタンス変数
    SRWebSocket *socket;
}

@property(retain) UIColor *penColor;
@property(assign) float penWidth;

@end
