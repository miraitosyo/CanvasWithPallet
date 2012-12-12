//
//  CanvasView.m
//  Canvas
//
//  Created by 古川 涼太 on 12/10/28.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

@synthesize penColor, penWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 描画スタイルのデフォルト設定
        penWidth = 3;
        self.penColor = [UIColor redColor];
        
    }
    return self;
}

- (void)canvasImage:(CGPoint)newPt
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    UIRectFill(self.bounds);
    [canvas drawAtPoint:CGPointZero];
    [penColor set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, penWidth);
    CGContextMoveToPoint(context, curtPt.x, curtPt.y);
    CGContextAddLineToPoint(context, newPt.x, newPt.y);
    CGContextStrokePath(context);
    [canvas release];
    
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
}

- (void)dealloc
{
    [penColor release];
    [canvas release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    //canvas = [self canvasImage];
    [canvas drawAtPoint:CGPointMake(0, 0)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    curtPt = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newPt = [touch locationInView:self];

    [self canvasImage:newPt];
    [self setNeedsDisplay];
    curtPt = newPt;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ws://conett.jp:3000/"]];
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url]];
    socket.delegate = self;
    [socket open];
    
    //NSLog(@"kita?");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


// サーバーに接続したとき（サーバー側のログに出力）
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [webSocket send:@"テストメッセージ"];
}

// サーバーからメッセージを受信したとき
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"didReceiveMessage: %@", [message description]);
}

// 接続に失敗したとき
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"接続失敗");
}


@end
