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
    
    // 現在座標（自分）
    CGPoint curtPt;
    // 現在座標（他クライアント）
    CGPoint curtPtX;
    // WebSocket用インスタンス変数
    SRWebSocket *socket;
}

// ペンカラー（自分）
@property(retain) UIColor *penColor;
// ペンカラー（他クライアント）
@property(retain) UIColor *penColorX;
// ペンの太さ（自分）
@property(assign) float penWidth;
// ペンの太さ（他クライアント）
@property(assign) float penWidthX;

@property (nonatomic, assign) NSInteger userID;

- (void)wsClose;
- (UIImage*)getImage;
- (void)setImage:(UIImage *)image;
- (void)clearImage;

@end
