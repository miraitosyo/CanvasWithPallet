//
//  CanvasView.m
//  Canvas
//
//  Created by 古川 涼太 on 12/10/28.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "CanvasView.h"
#import "SBJson.h"


@implementation CanvasView

@synthesize penColor, penColorX, penWidth, penWidthX;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 描画スタイルのデフォルト設定
        penWidth = 3;
        self.penColor = [UIColor redColor];

        // websocketサーバーに接続
        socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://54.248.80.194:8080/"]]];
        
        socket.delegate = self;
        [socket open];
        
    }
    return self;
}

- (UIImage *)image
{
    return canvas;
}

- (void)setImage:(UIImage *)image
{
    if (canvas == image)
    {
        return;
    }
    
    UIGraphicsBeginImageContext(self.bounds.size);
    UIRectFill(self.bounds);
    [image drawAtPoint:CGPointZero];
    [canvas release];
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}

// 描画処理（自分）
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
    // 魔法の処理 
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    [canvas release];
    
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
}

// 描画処理（他クライアント）
- (void)canvasImageX:(CGPoint)newPtX
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    //NSLog(@"%@", penColorX);
    
    UIRectFill(self.bounds);
    [canvas drawAtPoint:CGPointZero];

    [penColor set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, penWidthX);
    CGContextMoveToPoint(context, curtPtX.x, curtPtX.y);
    CGContextAddLineToPoint(context, newPtX.x, newPtX.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    [canvas release];
    
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
}

- (void)dealloc
{
    [penColor release];
    [penColorX release];
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
    NSString *touchBegan = [NSString stringWithFormat:@"{\"x\":\"%lf\",\"y\":\"%lf\",\"z\":\"began\",\"penWidth\":\"%lf\",\"penColor\":\"%@\"}",
                            curtPt.x, curtPt.y, penWidth, penColor];
    //NSString *touchBegan = [NSString stringWithFormat:@"{\"x\":\"%lf\",\"y\":\"%lf\",\"z\":\"began\"}", curtPt.x, curtPt.y];

    [socket send:touchBegan];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newPt = [touch locationInView:self];

    [self canvasImage:newPt];
    
    // 描画の必要がある事を自信に通知する
    [self setNeedsDisplay];
    curtPt = newPt;
     
    //int x = curtPt.x;
    //int y = curtPt.y;
    
    NSString *requestBody = [NSString stringWithFormat:@"{\"x\":\"%lf\",\"y\":\"%lf\"}", curtPt.x, curtPt.y];
    
    [socket send:requestBody];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    NSString *touchEnd = [[NSString alloc] initWithFormat:@"{\"x\":\"end\"}"];
    [socket send:touchEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


// サーバーに接続したとき
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

    NSLog(@"接続成功");
}

// サーバーから他クライアントの描画情報を受信したとき
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    [self otherPlayerDraw:[message JSONValue]];
}

// 接続に失敗したとき
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"接続失敗");
}

// 他クライアントが描画したとき
- (void)otherPlayerDraw:(NSArray *)drawingPoints{
    
    for (int i = 0; i < [drawingPoints count]; i++) {
        
        NSDictionary *drawingPoint = [drawingPoints objectAtIndex:i];
        
        // タップしたとき、タップしたまま移動時、タップしている指が離れたとき、分岐処理
        if ([[drawingPoint objectForKey:@"z"] isEqualToString:@"began"]) {
            
            curtPtX = CGPointMake([[drawingPoint objectForKey:@"x"] doubleValue], [[drawingPoint objectForKey:@"y"] doubleValue]);
            penWidthX = [[drawingPoint objectForKey:@"penWidth"] doubleValue];
            penColorX = [drawingPoint objectForKey:@"penColor"];
                        
        } else if ([[drawingPoint objectForKey:@"x"] isEqualToString:@"end"]) {
            
            NSLog(@"end");
            
        } else {
        
            CGPoint newPtX = CGPointMake([[drawingPoint objectForKey:@"x"] doubleValue], [[drawingPoint objectForKey:@"y"] doubleValue]);

            [self canvasImageX:newPtX];
            [self setNeedsDisplay];

            curtPtX = newPtX;

            NSLog(@"x = %f : y = %f", [[drawingPoint objectForKey:@"x"] doubleValue], [[drawingPoint objectForKey:@"y"] doubleValue]);
            
        }

    }
}


@end
