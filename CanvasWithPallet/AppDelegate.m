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
    
    // ツールバーに画像保存ボタンの設置
    UIBarButtonItem *saveBtn =  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                                                                action:@selector(save:)] autorelease];

    UIBarButtonItem *space =  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
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
    
    
    // 画像保存ボタン
    /*
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraBtn.frame = CGRectMake(self.window.frame.size.width - 30, self.window.frame.size.height - 250, 20, 20);
    [self.window addSubview:cameraBtn];
    
    [cameraBtn addTarget:self action:@selector(saveToPhotoAlbum:) forControlEvents:UIControlEventTouchDown];
    
    
    // クリアーボタン
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.frame = CGRectMake(self.window.frame.size.width - 30, self.window.frame.size.height - 30, 20, 20);
    [self.window addSubview:clearBtn];
    
    [clearBtn addTarget:self action:@selector(zenkeshi:) forControlEvents:UIControlEventTouchDown];
    */
    
    //canvasview.image = [self loadImage];
    [self.window makeKeyAndVisible];
    return YES;
}


- (UIImage*)createImage:(CGSize)contentsSize
{
    UIGraphicsBeginImageContext(contentsSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setFill];
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, contentsSize.width, contentsSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
// 描画情報を読み込む
- (UIImage *)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"canvasimage.png"];
    return [UIImage imageWithContentsOfFile:filePath];
}

// 描画情報を保存 
- (void)saveImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"canvasimage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
}
*/

// キャンバス画像を保存
-(void)save:(UIButton *)saveBtn {
    
    UIImage *image = [self createImage:CGSizeMake(100, 100)];
    //UIImage *image = [self createImage:[canvasview image]];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ova1.png"];
    [imageData writeToFile:filePath atomically:YES];
    printf("%s\n", [documentsDirectory UTF8String]);
    
}

- (void)clear:(UIButton *)clearBtn
{
    // キャンバス作成
    CGRect r = [UIScreen mainScreen].applicationFrame;
    r = CGRectOffset(r, 0, 44);
    r.size.width -= 44;
    canvasview = [[[CanvasView alloc] initWithFrame:r] autorelease];
    [self.window addSubview:canvasview];
    
    slider.value = canvasview.penWidth;
}


- (void)sliderValueChange:(UISlider*)slider
{
    canvasview.penWidth = slider.value;
}


- (void)palletActionValueChanged:(Pallet*)sender
{
    canvasview.penColor = [sender selectedColor];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //[self saveImage:canvasview.image];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //[self saveImage:canvasview.image];
}

@end
