//
//  AppDelegate.m
//  CanvasWithPallet
//
//  Created by 古川 涼太 on 12/10/31.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "AppDelegate.h"
#import "CanvasView.h"
#import "Pallet.h"
#import "FbViewController.h"

@implementation AppDelegate

@synthesize canvasview;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];

    CGRect r = [UIScreen mainScreen].applicationFrame;
    
    // ツールバーの設置
    CGRect toolbarFrame = r;
    toolbarFrame.size.height = 44;
    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:toolbarFrame] autorelease];
    toolBar.tintColor = [UIColor blackColor];
    [self.window addSubview:toolBar];
    
    // 画像保存ボタンの設置
    UIBarButtonItem *saveBtn =  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self
                                                                                action:@selector(save:)] autorelease];

    // 可変長のスペースを設置
    UIBarButtonItem *space =  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    // 削除ボタンの設置
    UIBarButtonItem *clearBtn =  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self
                                                                               action:@selector(clear:)] autorelease];
    toolBar.items = [NSArray arrayWithObjects:saveBtn, space, clearBtn, nil];
    
    
    // キャンバス作成
    r = CGRectOffset(r, 0, toolbarFrame.size.height);
    r.size.width -= 44;
    canvasview = [[CanvasView alloc] initWithFrame:r];
    
    [self.window addSubview:canvasview];
    
    // パレット作成
    r = CGRectOffset(r, r.size.width, 0);
    r.size.width = 44;
    Pallet *pallet = [[[Pallet alloc] initWithFrame:r] autorelease];
    // 押下時のメソッド指定
    [pallet setTarget:self action:@selector(palletActionValueChanged:) forEvent:PalletEvent_ValueChanged];
    [self.window addSubview:pallet];

    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        // ペンの太さ設定用スライダー
        slider = [[[UISlider alloc] initWithFrame:CGRectMake(self.window.frame.size.width - 83, self.window.frame.size.height - 150, 120, 50)] autorelease];
        
        slider.minimumValue = 1.0;
        slider.maximumValue = 100.0;
        slider.value = canvasview.penWidth;
        
        CGAffineTransform scale  = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform trans  = CGAffineTransformMakeRotation(M_PI / 180.0f * 270.0f);
        CGAffineTransform concat = CGAffineTransformConcat(scale,trans);
        [slider setTransform:concat];
        [self.window addSubview:slider];
        
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
            
    }
    
    //FbViewController *FbZone = [[[FbViewController alloc] init] autorelease];
    //[self.window addSubview:(UIView*)FbZone];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

// キャンバス画像を保存
-(void)save:(UIButton *)saveBtn {
    
    UIImage *image = [canvasview getImage];
        
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ova1.png"];
    [imageData writeToFile:filePath atomically:YES];
    printf("%s\n", [documentsDirectory UTF8String]);
    
}

// 現キャンバスを破棄
- (void)clear:(UIButton *)clearBtn
{
    
    [canvasview clearImage];
    
    slider.value = canvasview.penWidth;
}

// ペンの太さを変えるスライダー変動時
- (void)sliderValueChange:(UISlider*)_slider
{
    canvasview.penWidth = _slider.value;
}

// パレットの色選択時
- (void)palletActionValueChanged:(Pallet*)sender
{
    canvasview.penColor = [sender selectedColor];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    //NSLog(@"aaa");
}

// ホームボタン押下時
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // websocketの接続を切断
    [canvasview wsClose];
}

// バックグラウンドから復活したとき
- (void)applicationWillEnterForeground:(UIApplication *)application
{    
    // キャンバスを再作成
    CGRect r = [UIScreen mainScreen].applicationFrame;
    r = CGRectOffset(r, 0, 44);
    r.size.width -= 44;
    canvasview = [[[CanvasView alloc] initWithFrame:r] autorelease];
    [self.window addSubview:canvasview];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //NSLog(@"ccc");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //NSLog(@"ddd");
}

@end
